import asyncio
import logging
from pathlib import Path
from typing import List, Dict, Optional
from dotenv import load_dotenv
import os
import re

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
        model: str = 'gpt-4o'
    ) -> Dict:
        
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
            
            summary_str = await self.llm.get_openai_completion(
                summary_messages[0]['content']
            )
            
            try:
                title_match = re.search(r'title:\s*(.*?)(?=\n|$)', summary_str)
                summary_match = re.search(r'summary:\s*(.*?)(?=\n|$)', summary_str, re.DOTALL)
                
                if not all([title_match, summary_match]):
                    raise ValueError("Summary response missing required sections")
                
                main_task_title = title_match.group(1).strip()
                summary = summary_match.group(1).strip()
                
            except Exception as e:
                self.logger.error(f"Error parsing summary: {str(e)}")
                self.logger.error(f"Raw summary response: {summary_str}")
                raise ValueError(f"Failed to parse summary: {str(e)}")

            # Estimate total time
            time_messages = self.prompt_manager.load_prompt(
                'time_estimation',
                summary=summary,
                unit_time=unit_time
            )
            total_time_str = await self.llm.get_llm_completion(
                time_messages[0]['content'],
                model_name='claude'
            )
            
            try:
                # Extract the number after "estimation_time:"
                match = re.search(r'estimation_time:\s*(\d+)', total_time_str)
                if not match:
                    self.logger.error(f"Invalid time format in response: {total_time_str}")
                    raise ValueError("Response not in correct format")
                
                total_time = int(match.group(1))
                
                # Validate the time
                if total_time <= 0:
                    raise ValueError("Total time must be positive")
                if total_time > 60:
                    total_time = 60  # Cap at 60 minutes
                    
                self.logger.info(f"Extracted total time: {total_time} minutes")

            except Exception as e:
                self.logger.error(f"Error processing time estimation: {str(e)}")
                self.logger.error(f"Raw time estimation response: {total_time_str}")
                raise ValueError(f"Failed to process time estimation: {str(e)}")

            # Create subtasks
            num_subtasks = (total_time + unit_time - 1) // unit_time
            task_messages = self.prompt_manager.load_prompt(
                'task_decomposition',
                summary=summary,
                user_goal=user_goal,
                num_subtasks=num_subtasks,
                unit_time=unit_time
            )
            tasks_raw = await self.llm.get_llm_completion(
                task_messages[0]['content'],
                model_name='claude'
            )
            subtask_themes = [task.strip() for task in tasks_raw.split('\n') if task.strip()]

            subtasks = []
            for idx, theme in enumerate(subtask_themes, 1):  # start enumeration at 1
                content_messages = self.prompt_manager.load_prompt(
                    'subtask_context',
                    theme=theme,
                    summary=summary,
                    unit_time=unit_time,
                    user_goal=user_goal
                )
                content_str = await self.llm.get_llm_completion(
                    content_messages[0]['content'],
                    model_name='claude'
                )
                
                print(content_str)
                
                try:
                    title_match = re.search(r'title:\s*(.*?)(?=\n|$)', content_str)
                    summary_match = re.search(r'summary:\s*(.*?)(?=\n|$)', content_str)
                    content_match = re.search(r'content:\s*\|\n(.*)', content_str, re.DOTALL)
                    content = content_match.group(1) if content_match else ''
                    
                    # Split content into sections
                    sections = []
                    if content:
                        # Split by ### and remove any leading empty sections
                        raw_sections = content.split('### ')[1:]
                        
                        for section in raw_sections:
                            # Split each section into title and body
                            parts = section.split('\n', 1)
                            title = parts[0].strip()
                            body = parts[1].strip() if len(parts) > 1 else ''
                            
                            sections.append({
                                'title': title,
                                'body': body
                            })
                    
                    if not all([title_match, summary_match, content_match]):
                        raise ValueError("Subtask response missing required sections")
                    
                    subtasks.append({
                        'order': idx,  # Add the order number
                        'title': title_match.group(1).strip(),
                        'summary': summary_match.group(1).strip(),
                        'content': sections
                    })
                    
                except Exception as e:
                    self.logger.error(f"Error parsing subtask content: {str(e)}")
                    self.logger.error(f"Raw content response: {content_str}")
                    raise ValueError(f"Failed to parse subtask content: {str(e)}")

            return {
                'title': main_task_title,
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
        pdf_path = "/Users/grace/gdc_hakathon/backend/LLM/hasing_pdf.pdf"
        audio_path = "/Users/grace/gdc_hakathon/backend/LLM/hashing_audio.m4a"
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
                logger.info(f"Content:\n{subtask['content']}")
                

    except Exception as e:
        logger.error(f"Program failed: {str(e)}", exc_info=True)
        raise


if __name__ == "__main__":
    import asyncio
    import json
    
    async def validate_subtask(subtask: dict) -> bool:
        """Validate subtask structure and content."""
        required_fields = {'order', 'title', 'summary', 'content'}
        
        # Check all required fields exist
        if not all(field in subtask for field in required_fields):
            missing = required_fields - set(subtask.keys())
            print(f"Missing fields in subtask: {missing}")
            return False
            
        # Check types
        if not isinstance(subtask['order'], int):
            print(f"Order should be int, got {type(subtask['order'])}")
            return False
        if not all(isinstance(subtask[field], str) for field in ['title', 'summary', 'content']):
            print("Title, summary, and content should be strings")
            return False
            
        # Check content
        if len(subtask['title']) < 1:
            print("Title is empty")
            return False
        if len(subtask['summary']) < 1:
            print("Summary is empty")
            return False
        if len(subtask['content']) < 1:
            print("Content is empty")
            return False
            
        return True

    async def test_task_decomposition():
        # Set up logging
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        logger = logging.getLogger(__name__)
        
        try:
            system = TaskDecompositionSystem()
            
            # Test with sample files
            pdf_files = ["hashing_pdf.pdf"]
            audio_files = [] #["hashing_audio.mp3"]
            user_goal = "어제 교수님이 수업시간에 다룬 것에 대한 간단한 복습. 차후 과제에 대비하기 위한 용."
            unit_time = 5
            
            logger.info("=== Starting Task Decomposition Test ===")
            logger.info(f"Processing files: PDF={pdf_files}, Audio={audio_files}")
            logger.info(f"User Goal: {user_goal}")
            logger.info(f"Unit Time: {unit_time} minutes")
            
            result = await system.process_content_from_file(
                pdf_files=pdf_files,
                audio_files=audio_files,
                user_goal=user_goal,
                unit_time=unit_time
            )
            
            # Validate result structure
            required_fields = {
                'title', 'summary', 'total_time', 'unit_time', 
                'num_subtasks', 'user_goal', 'subtasks'
            }
            
            if not all(field in result for field in required_fields):
                missing = required_fields - set(result.keys())
                raise ValueError(f"Missing fields in result: {missing}")
            
            # Validate time constraints
            if not (0 < result['total_time'] <= 60):
                raise ValueError(f"Invalid total time: {result['total_time']}")
            if result['unit_time'] != unit_time:
                raise ValueError(f"Unit time mismatch: {result['unit_time']} != {unit_time}")
            
            # Validate subtasks
            if len(result['subtasks']) != result['num_subtasks']:
                raise ValueError("Number of subtasks doesn't match num_subtasks field")
                
            # Check each subtask
            for subtask in result['subtasks']:
                if not await validate_subtask(subtask):
                    raise ValueError(f"Invalid subtask structure: {subtask}")
            
            # Print successful result
            logger.info("\n=== Test Results ===")
            logger.info(f"Main Task Title: {result['title']}")
            logger.info(f"Summary: {result['summary'][:100]}...")
            logger.info(f"Total Time: {result['total_time']} minutes")
            logger.info(f"Number of Subtasks: {result['num_subtasks']}")
            logger.info("\nSubtasks:")
            
            '''
            for subtask in result['subtasks']:
                logger.info(f"\nTask {subtask['order']}:")
                logger.info(f"Title: {subtask['title']}")
                logger.info(f"Summary: {subtask['summary']}")
                logger.info(f"Content preview: {subtask['content'][:100]}...")'''
            
            # Save test results to file
            test_output = {
                'input_parameters': {
                    'pdf_files': pdf_files,
                    'audio_files': audio_files,
                    'user_goal': user_goal,
                    'unit_time': unit_time
                },
                'result': result
            }
            
            with open('task_decomposition_test_result.json', 'w', encoding='utf-8') as f:
                json.dump(test_output, f, ensure_ascii=False, indent=2)
            
            logger.info("\n=== Test Completed Successfully ===")
            logger.info("Results saved to task_decomposition_test_result.json")
                
        except Exception as e:
            logger.error(f"Test failed: {str(e)}", exc_info=True)
            raise

    # Run the test
    asyncio.run(test_task_decomposition())