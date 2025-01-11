from pathlib import Path
from typing import List, Dict, Optional
from jinja2 import Environment, FileSystemLoader
import logging

class PromptManager:
    def __init__(self):
        """Initialize the PromptManager with Jinja2 environment."""
        self.templates_dir = Path(__file__).parent / "templates"
        self.env = Environment(
            loader=FileSystemLoader(str(self.templates_dir)),
            trim_blocks=True,
            lstrip_blocks=True
        )
        self.logger = logging.getLogger(__name__)

    def load_prompt(self, template_name: str, **kwargs) -> List[Dict[str, str]]:
        """
        Load and render a prompt template.
        
        Args:
            template_name (str): Name of the template file (without .txt extension)
            **kwargs: Variables to pass to the template
            
        Returns:
            List[Dict[str, str]]: List of message dictionaries for the LLM
        """
        try:
            # Get template
            template = self.env.get_template(f"{template_name}.py")
            
            # Render template with provided variables
            rendered_content = template.render(**kwargs)
            
            # Convert to messages format
            return [{"role": "user", "content": rendered_content.strip()}]
        
        except Exception as e:
            self.logger.error(f"Error loading prompt {template_name}: {str(e)}")
            raise


# 프롬프트 형태를 테스트 해볼 수 있음 
if __name__ == "__main__":
    import logging

    # Set up logging
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)

    try:
        # Initialize prompt manager
        prompt_manager = PromptManager()

        # Test summarization prompt
        summary_messages = prompt_manager.load_prompt(
            'summarization',
            content="A PDF on system architecture that covers fundamental concepts including distributed systems, microservices, and scalability patterns. The document includes detailed explanations of various architectural styles and their trade-offs.",
            user_goal="Understand core system architecture concepts for software design"
        )

        # Print the generated prompt
        print("\nGenerated Prompt Messages:")
        for message in summary_messages:
            print(f"\nRole: {message['role']}")
            print(f"Content:\n{message['content']}")

    except Exception as e:
        logger.error(f"Error occurred: {str(e)}")