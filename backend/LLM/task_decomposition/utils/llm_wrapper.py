from typing import Optional, Dict, Any, List, Union
import logging
from pathlib import Path
from dotenv import load_dotenv
import os
import openai

from langchain_anthropic import ChatAnthropic
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_core.language_models import BaseChatModel

class LLMWrapper:
    def __init__(self):
        """Initialize LLM wrapper with environment variables."""
        load_dotenv()
        
        # Setup logging
        self.logger = logging.getLogger(__name__)
        
        # Get API keys
        self.openai_api_key = os.getenv("OPENAI_API_KEY")
        self.anthropic_api_key = os.getenv("ANTHROPIC_API_KEY")
        
        if not self.openai_api_key or not self.anthropic_api_key:
            raise ValueError("Missing required API keys")
        
        # Initialize OpenAI client
        self.openai_client = openai.OpenAI(api_key=self.openai_api_key)
        
        # Initialize assistant
        self.assistant = self.openai_client.beta.assistants.create(
            name="PDF assistant",
            instructions="An assistant to extract the contents of PDF files.", #TODO
            model="gpt-4o",
            tools=[{"type": "file_search"}],
        )
        
        # Initialize LangChain models
        self.models = {
            'gpt-4': self._init_openai_model("gpt-4-turbo-preview"),
            'gpt-3.5': self._init_openai_model("gpt-3.5-turbo"),
            'claude': self._init_claude_model()
        }
        
    def _init_openai_model(self, model_name: str) -> ChatOpenAI:
        """Initialize OpenAI model."""
        return ChatOpenAI(
            model_name=model_name,
            openai_api_key=self.openai_api_key,
            temperature=0.7
        )
        
    def _init_claude_model(self) -> ChatAnthropic:
        """Initialize Claude model."""
        return ChatAnthropic(
            model="claude-3-sonnet-20240229",
            anthropic_api_key=self.anthropic_api_key,
            temperature=0.7
        )
    
    def get_model(self, model_name: str) -> BaseChatModel:
        """Get the specified model."""
        if model_name not in self.models:
            raise ValueError(f"Unknown model: {model_name}")
        return self.models[model_name]
    
    def add_pdf(
        self,
        file_streams: List[Any]
    ) :
        # Upload files and add them to vector store
        vector_store = self.openai_client.beta.vector_stores.create(name="PDF")
        file_batch = self.openai_client.beta.vector_stores.file_batches.upload_and_poll(
            vector_store_id=vector_store.id, files=file_streams
        )
        
        # update pdf assistant to use vector store
        self.assistant = self.openai_client.beta.assistants.update(
            assistant_id=self.assistant.id,
            tool_resources={"file_search": {"vector_store_ids": [vector_store.id]}},
        )
        
        self.logger.info("PDF added")
    
    async def get_completion(
        self,
        prompt: str,
        model_name: str = 'gpt-4',
        system_prompt: Optional[str] = None
    ) -> str:
        """Get completion from specified model."""
        try:
            model = self.get_model(model_name)
            
            messages = []
            if system_prompt:
                messages.append({"role": "system", "content": system_prompt})
            messages.append({"role": "user", "content": prompt})
            
            
            self.logger.info(f"Getting completion from {model_name}")
            # create thread to execute
            thread = self.openai_client.beta.threads.create(messages=messages)
            run = self.openai_client.beta.threads.runs.create_and_poll(
                thread_id=thread.id, assistant_id=self.assistant.id, timeout=1000
            )
            
            if run.status != "completed":
                raise Exception("Run failed:", run.status)

            messages_cursor = self.openai_client.beta.threads.messages.list(thread_id=thread.id)
            messages = [message for message in messages_cursor]

            # Output text
            res_txt = messages[0].content[0].text.value
            return res_txt

            
        except Exception as e:
            self.logger.error(f"Error getting completion: {str(e)}")
            raise
    
    async def transcribe_audio(self, audio_file: Union[str, bytes]) -> str:
        """Transcribe audio using OpenAI Whisper API directly."""
        try:
            self.logger.info("Transcribing audio")
            transcript = self.openai_client.audio.transcriptions.create(
                model="whisper-1",
                file=audio_file,
            )
            return transcript.text
        except Exception as e:
            self.logger.error(f"Error transcribing audio: {str(e)}")
            raise
            
    async def create_speech(
        self,
        text: str,
        model: str = "tts-1",
        voice: str = "alloy",
        output_path: Optional[str] = None
    ) -> Union[bytes, str]:
        """Create speech from text using OpenAI TTS API."""
        try:
            self.logger.info(f"Creating speech with voice: {voice}")
            response = await self.openai_client.audio.speech.create(
                model=model,
                voice=voice,
                input=text
            )
            
            if output_path:
                # Save to file if path provided
                output_path = Path(output_path)
                response.stream_to_file(output_path)
                return str(output_path)
            else:
                # Return bytes if no path provided
                return response.read()
                
        except Exception as e:
            self.logger.error(f"Error creating speech: {str(e)}")
            raise

# Example usage
if __name__ == "__main__":
    import asyncio
    
    async def test_llm_wrapper():
        # Set up logging
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        logger = logging.getLogger(__name__)
        
        try:
            llm = LLMWrapper()
            
            # Test GPT-4
            logger.info("Testing GPT-4...")
            gpt_response = await llm.get_completion(
                "Explain the concept of microservices in one paragraph.",
                model_name='gpt-4'
            )
            logger.info("GPT-4 Response:\n%s", gpt_response)
            
            # Test Claude
            logger.info("\nTesting Claude...")
            claude_response = await llm.get_completion(
                "Explain the concept of containerization in one paragraph.",
                model_name='claude',
                system_prompt="You are a helpful expert in software architecture."
            )
            logger.info("Claude Response:\n%s", claude_response)
            
            # Test audio transcription if you have an audio file
            audio_file_path = "sample.mp3"
            if Path(audio_file_path).exists():
                logger.info("\nTesting audio transcription...")
                with open(audio_file_path, "rb") as audio_file:
                    transcript = await llm.transcribe_audio(audio_file)
                logger.info("Transcription:\n%s", transcript)
            
            # Test text-to-speech
            logger.info("\nTesting text-to-speech...")
            speech_file = await llm.create_speech(
                "Hello! This is a test of the text-to-speech system.",
                voice="alloy",
                output_path="test_speech.mp3"
            )
            logger.info(f"Speech saved to: {speech_file}")
            
        except Exception as e:
            logger.error("Test failed: %s", str(e), exc_info=True)
            raise

    # Run the test
    asyncio.run(test_llm_wrapper())