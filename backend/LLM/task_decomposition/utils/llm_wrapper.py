from typing import Optional, Dict, Any, List
from openai import OpenAI
from anthropic import Anthropic
import asyncio
from functools import wraps
import time

class LLMWrapper:
    def __init__(self, openai_api_key: str, anthropic_api_key: str):
        self.openai_client = OpenAI(api_key=openai_api_key)
        self.anthropic_client = Anthropic(api_key=anthropic_api_key)
        
    async def retry_with_exponential_backoff(
        self,
        func,
        max_retries: int = 3,
        initial_delay: float = 1,
        max_delay: float = 10,
        exponential_base: float = 2,
    ):
        """Retry decorator with exponential backoff."""
        retries = 0
        delay = initial_delay

        while retries < max_retries:
            try:
                return await func()
            except Exception as e:
                retries += 1
                if retries == max_retries:
                    raise e
                
                delay = min(delay * exponential_base, max_delay)
                await asyncio.sleep(delay)

    async def call_openai(
        self,
        messages: List[Dict[str, str]],
        model: str = "gpt-4-turbo-preview",
        temperature: float = 0.7,
        max_tokens: Optional[int] = None,
    ) -> str:
        """Wrapper for OpenAI API calls"""
        async def _call():
            response = await self.openai_client.chat.completions.create(
                model=model,
                messages=messages,
                temperature=temperature,
                max_tokens=max_tokens,
            )
            return response.choices[0].message.content

        return await self.retry_with_exponential_backoff(_call)

    async def call_claude(
        self,
        messages: List[Dict[str, str]],
        model: str = "claude-3-sonnet-20240229",
        temperature: float = 0.7,
        max_tokens: Optional[int] = None,
    ) -> str:
        """Wrapper for Anthropic Claude API calls"""
        async def _call():
            response = await self.anthropic_client.messages.create(
                model=model,
                messages=messages,
                temperature=temperature,
                max_tokens=max_tokens,
            )
            return response.content

        return await self.retry_with_exponential_backoff(_call)

    async def process_audio(self, audio_file: bytes) -> str:
        """Process audio using OpenAI Whisper"""
        async def _call():
            transcript = await self.openai_client.audio.transcriptions.create(
                model="whisper-1",
                file=audio_file
            )
            return transcript.text

        return await self.retry_with_exponential_backoff(_call)

    async def process_file(self, file: bytes, file_type: str) -> str:
        """Process file using OpenAI's file API"""
        async def _call():
            file_response = await self.openai_client.files.create(
                file=file,
                purpose="assistants"
            )
            
            response = await self.openai_client.chat.completions.create(
                model="gpt-4-turbo-preview",
                messages=[
                    {"role": "system", "content": f"Extract and summarize the content from this {file_type} file."},
                    {"role": "user", "content": f"File ID: {file_response.id}"}
                ]
            )
            return response.choices[0].message.content

        return await self.retry_with_exponential_backoff(_call)