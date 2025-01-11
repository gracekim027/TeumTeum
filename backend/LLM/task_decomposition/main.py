import asyncio
import logging
from pathlib import Path
from typing import List, Dict, Optional
from dotenv import load_dotenv
import os

from utils.llm_wrapper import LLMWrapper
from utils.file_manager import FileManager, FileProcessingError
from prompts.prompt_manager import PromptManager

class TaskDecompositionSystem:
    def __init__(self):
        """Initialize the task decomposition system."""
        # Setup logging
        self.logger = logging.getLogger(__name__)
        
        # Initialize components
        self.llm = LLMWrapper()
        self.file_manager = FileManager()
        self.prompt_manager = PromptManager()

    async def process_content_from_file(
        self,
        pdf_files: List[str],
        audio_files: List[str],
        user_goal: str,
        unit_time: int,
        model: str = 'gpt-4'
    ) -> Dict:
        """
        Process content from a file and break it into subtasks.
        
        Args:
            file_path: Path to the input file
            file_type: Type of file ('pdf' or 'audio')
            user_goal: User's learning goal
            unit_time: Time per subtask in minutes
            model: Model to use for processing
            
        Returns:
            Dict containing summary and subtasks
        """
        
        try:
            pdf_raws = await self.file_manager.load_file(pdf_files)
            audio_raws = await self.file_manager.load_file(audio_files)
            
            audio_contents = []
            for audio_raw in audio_raws:
                audio_content = await self.llm.transcribe_audio(audio_raw)
                audio_contents.append(audio_content)
            
            self.llm.add_pdf(pdf_raws)
            
            summary_messages = self.prompt_manager.load_prompt(
                'summarization',
                audio_contents=" ".join(audio_contents),
                user_goal=user_goal
            )
            
            summary = await self.llm.get_completion(
                summary_messages[0]['content'],
                model_name=model
            )

            # Estimate total time
            time_messages = self.prompt_manager.load_prompt(
                'time_estimation',
                summary=summary,
                unit_time=unit_time
            )
            total_time_str = await self.llm.get_completion(
                time_messages[0]['content'],
                model_name=model
            )
            print(total_time_str.strip())
            total_time = int(total_time_str.strip())

            # Create subtasks
            num_subtasks = (total_time + unit_time - 1) // unit_time
            task_messages = self.prompt_manager.load_prompt(
                'task_decomposition',
                summary=summary,
                user_goal=user_goal,
                num_subtasks=num_subtasks,
                unit_time=unit_time
            )
            tasks_raw = await self.llm.get_completion(
                task_messages[0]['content'],
                model_name=model
            )
            subtask_themes = [task.strip() for task in tasks_raw.split('\n') if task.strip()]

            # Generate content for each subtask
            subtasks = []
            for theme in subtask_themes:
                content_messages = self.prompt_manager.load_prompt(
                    'subtask_context',
                    theme=theme,
                    summary=summary,
                    unit_time=unit_time,
                    user_goal=user_goal
                )
                content = await self.llm.get_completion(
                    content_messages[0]['content'],
                    model_name=model
                )
                subtasks.append({
                    'theme': theme,
                    'content': content,
                    'duration': unit_time
                })

            return {
                'summary': summary,
                'total_time': total_time,
                'unit_time': unit_time,
                'num_subtasks': len(subtasks),
                'user_goal': user_goal,
                'subtasks': subtasks
            }

        except Exception as e:
            self.logger.error(f"Error processing content: {str(e)}")
            raise

async def main():
    # Set up logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    logger = logging.getLogger(__name__)

    # Load environment variables
    load_dotenv()

    try:
        # Initialize system
        system = TaskDecompositionSystem()

        # Example usage with a PDF file
        pdf_path = "sample/lecture.pdf"
        audio_path = "sample/lecture.m4a"
        if Path(pdf_path).exists():
            logger.info("Processing PDF file...")
            result = await system.process_content_from_file(
                pdf_files=[pdf_path],
                audio_files=[audio_path],
                user_goal="Understand the key concepts for the exam",
                unit_time=400  # 400 minutes per subtask
            )
            
            # Print results
            logger.info("\nProcessing Results:")
            logger.info(f"Summary:\n{result['summary']}")
            logger.info(f"\nTotal Time: {result['total_time']} minutes")
            logger.info(f"Number of Subtasks: {result['num_subtasks']}")
            
            for i, subtask in enumerate(result['subtasks'], 1):
                logger.info(f"\nSubtask {i}:")
                logger.info(f"Theme: {subtask['theme']}")
                logger.info(f"Duration: {subtask['duration']} minutes")
                logger.info(f"Content:\n{subtask['content']}")


    except Exception as e:
        logger.error(f"Program failed: {str(e)}", exc_info=True)
        raise

if __name__ == "__main__":
    asyncio.run(main())