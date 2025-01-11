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
        
        try:
            instructions_path = Path(__file__).parent / "pdf_assistant_instructions.txt"
            with open(instructions_path, 'r', encoding='utf-8') as f:
                pdf_instructions = f.read()
        except FileNotFoundError:
            self.logger.warning("PDF instructions file not found, using default instructions")
            pdf_instructions = "An assistant to extract the contents of PDF files."
        except Exception as e:
            self.logger.error(f"Error loading PDF instructions: {e}")
            pdf_instructions = "An assistant to extract the contents of PDF files."
        
        # Initialize assistant
        self.assistant = self.openai_client.beta.assistants.create(
            name="PDF assistant",
            instructions=pdf_instructions,
            model="gpt-4o",
            tools=[{"type": "file_search"}],
        )
        
        # Initialize LangChain models
        self.models = {
            'gpt-4o': self._init_openai_model(),
            'claude': self._init_claude_model()
        }
        
    def _init_openai_model(self) -> ChatOpenAI:
        """Initialize OpenAI model."""
        return ChatOpenAI(
            model_name="gpt-4o",
            openai_api_key=self.openai_api_key,
            temperature=0.7
        )
        
    def _init_claude_model(self) -> ChatAnthropic:
        """Initialize Claude model."""
        return ChatAnthropic(
            model="claude-3-5-sonnet-20241022",
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
    file_streams: List[Any]) -> None:
        """Upload PDF files and add them to vector store."""
        try:
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
        except Exception as e:
            self.logger.error(f"Error adding PDF: {str(e)}")
            raise
    
    async def get_openai_completion(
    self,
    prompt: str,
    system_prompt: Optional[str] = None) -> str:
        """Get completion from specified model."""
        try:
            # For threads API, we'll combine system prompt and user prompt
            thread_messages = []
            if system_prompt:
                combined_prompt = f"{system_prompt}\n\nUser Query: {prompt}"
            else:
                combined_prompt = prompt
                
            thread_messages.append({"role": "user", "content": combined_prompt})
            
            # create thread to execute
            thread = self.openai_client.beta.threads.create(messages=thread_messages)
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
    
    async def get_llm_completion(
        self,
        prompt: str,
        model_name: str = 'claude',
        system_prompt: Optional[str] = None
    ) -> str:
        """Get completion from specified model."""
        try:
            model = self.get_model(model_name)
            
            messages = []
            if system_prompt:
                messages.append(SystemMessage(content=system_prompt))
            messages.append(HumanMessage(content=prompt))
            
            self.logger.info(f"Getting completion from {model_name}")
            response = await model.ainvoke(messages)
            return response.content
            
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
# Initialize wrapper
if __name__ == "__main__":
    import asyncio
    import logging
    from pathlib import Path

    async def test_llm_wrapper():
        # Set up logging
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        
        logger = logging.getLogger(__name__)
        llm = LLMWrapper()
        logger.info("LLM Wrapper initialized successfully")
        
        # Test 1: PDF Processing
        logger.info("\n=== Testing PDF Processing ===")
        pdf_path = Path("/Users/grace/gdc_hakathon/backend/LLM/hashing_pdf.pdf")
        if pdf_path.exists():
            with open(pdf_path, "rb") as pdf_file:
                # Remove await here
                llm.add_pdf([pdf_file])
                logger.info("PDF added successfully")
                
                pdf_query = "What is the main topic of this document? Give a brief summary."
                pdf_response = await llm.get_completion(
                    prompt=pdf_query,
                    model_name='gpt-4o'
                )
                logger.info(f"PDF Analysis Response:\n{pdf_response}")
        else:
            logger.warning(f"PDF file not found at {pdf_path}")
                
        # Test 2: Audio Transcription
        logger.info("\n=== Testing Audio Transcription ===")
        audio_path = Path("/Users/grace/gdc_hakathon/backend/LLM/hashing_audio.mp3")
        if audio_path.exists():
            with open(audio_path, "rb") as audio_file:
                transcript = await llm.transcribe_audio(audio_file)
                logger.info(f"Transcription Result:\n{transcript}")
                
                analysis_prompt = "Analyze the main points from this transcription:"
                analysis_response = await llm.get_completion(
                    prompt=f"{analysis_prompt}\n\n{transcript}",
                    model_name='gpt-4o'
                )
                logger.info(f"Transcription Analysis:\n{analysis_response}")
        else:
            logger.warning(f"Audio file not found at {audio_path}")
        
        # Test 3: Different Models
        logger.info("\n=== Testing Different Models ===")
        test_prompt = "Explain the concept of neural networks in one paragraph."
        
        logger.info("Testing GPT-4...")
        gpt4_response = await llm.get_completion(
            prompt=test_prompt,
            model_name='gpt-4o'
        )
        logger.info(f"GPT-4 Response:\n{gpt4_response}")
        
        logger.info("\nTesting Claude...")
        claude_response = await llm.get_completion(
            prompt=test_prompt,
            model_name='claude',
            system_prompt="You are an AI expert explaining concepts to a technical audience."
        )
        logger.info(f"Claude Response:\n{claude_response}")
        
        logger.info("\nAll tests completed successfully!")
        
    asyncio.run(test_llm_wrapper())
