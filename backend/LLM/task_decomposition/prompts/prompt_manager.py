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


if __name__ == "__main__":
    prompt_manager = PromptManager()

    summary_messages = prompt_manager.load_prompt(
        'summarization',
        content="A Pdf on system architcture",
        user_goal="Understanding basic concepts"
    )