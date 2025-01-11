from typing import Optional, Dict, Any, Union, BinaryIO
from pathlib import Path
import logging
import mimetypes
import magic
import os
from datetime import datetime

class FileValidationError(Exception):
    """Exception raised for file validation errors."""
    pass

class FileProcessingError(Exception):
    """Exception raised for file processing errors."""
    pass

class FileManager:
    # Allowed file types and their mime types
    ALLOWED_TYPES = {
        'pdf': ['application/pdf'],
        'audio': ['audio/mpeg', 'audio/wav', 'audio/x-wav', 'audio/mp3', 'audio/m4a'],
        'text': ['text/plain'],
    }
    
    # Maximum file sizes in bytes
    MAX_FILE_SIZES = {
        'pdf': 50 * 1024 * 1024,  # 50MB
        'audio': 25 * 1024 * 1024,  # 25MB
        'text': 10 * 1024 * 1024,  # 10MB
    }

    def __init__(self, upload_dir: Optional[str] = None):
        """Initialize FileManager with optional upload directory."""
        self.logger = logging.getLogger(__name__)
        
        # Set up upload directory
        if upload_dir:
            self.upload_dir = Path(upload_dir)
        else:
            self.upload_dir = Path(__file__).parent / "uploads"
            
        self.upload_dir.mkdir(parents=True, exist_ok=True)
        self.logger.info(f"Using upload directory: {self.upload_dir}")

    def _get_safe_filename(self, filename: str) -> str:
        """Generate a safe filename with timestamp."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        stem = Path(filename).stem
        suffix = Path(filename).suffix
        return f"{stem}_{timestamp}{suffix}"

    def _validate_file_type(self, file_content: bytes, allowed_types: list) -> str:
        """Validate file content type using python-magic."""
        try:
            mime_type = magic.from_buffer(file_content, mime=True)
            if mime_type not in allowed_types:
                raise FileValidationError(
                    f"Invalid file type. Got {mime_type}, expected one of {allowed_types}"
                )
            return mime_type
        except Exception as e:
            raise FileValidationError(f"File type validation failed: {str(e)}")

    def _validate_file_size(self, file_size: int, file_type: str) -> None:
        """Validate file size against maximum allowed size."""
        max_size = self.MAX_FILE_SIZES.get(file_type)
        if max_size and file_size > max_size:
            raise FileValidationError(
                f"File too large. Maximum allowed size for {file_type} is "
                f"{max_size / (1024 * 1024):.1f}MB"
            )

    async def save_file(
        self,
        file: Union[BinaryIO, bytes],
        filename: str,
        file_type: str
    ) -> Dict[str, Any]:
        """
        Save and validate uploaded file.
        
        Args:
            file: File-like object or bytes
            filename: Original filename
            file_type: Type of file ('pdf', 'audio', 'text')
            
        Returns:
            Dict with file info including path, size, mime type
        """
        try:
            # Read file content if file-like object
            if hasattr(file, 'read'):
                content = file.read()
            else:
                content = file

            # Validate file type and size
            if file_type not in self.ALLOWED_TYPES:
                raise FileValidationError(f"Unsupported file type: {file_type}")
                
            mime_type = self._validate_file_type(content, self.ALLOWED_TYPES[file_type])
            self._validate_file_size(len(content), file_type)

            # Generate safe filename and save
            safe_filename = self._get_safe_filename(filename)
            file_path = self.upload_dir / safe_filename
            
            with open(file_path, 'wb') as f:
                f.write(content)

            self.logger.info(f"Successfully saved file: {file_path}")
            
            return {
                'path': str(file_path),
                'filename': safe_filename,
                'original_filename': filename,
                'size': len(content),
                'mime_type': mime_type,
                'file_type': file_type
            }

        except Exception as e:
            self.logger.error(f"Error saving file {filename}: {str(e)}")
            raise FileProcessingError(f"Failed to save file: {str(e)}")

    async def load_file(self, file_path: Union[str, Path]) -> bytes:
        """Load file content from path."""
        try:
            file_path = Path(file_path)
            if not file_path.exists():
                raise FileNotFoundError(f"File not found: {file_path}")
                
            with open(file_path, 'rb') as f:
                content = f.read()
                
            return content
            
        except Exception as e:
            self.logger.error(f"Error loading file {file_path}: {str(e)}")
            raise FileProcessingError(f"Failed to load file: {str(e)}")

    def cleanup_old_files(self, max_age_days: int = 7):
        """Clean up files older than specified days."""
        try:
            current_time = datetime.now().timestamp()
            
            for file_path in self.upload_dir.glob('*'):
                if file_path.is_file():
                    file_age = current_time - file_path.stat().st_mtime
                    if file_age > (max_age_days * 24 * 3600):
                        file_path.unlink()
                        self.logger.info(f"Deleted old file: {file_path}")
                        
        except Exception as e:
            self.logger.error(f"Error during cleanup: {str(e)}")

    def get_file_info(self, file_path: Union[str, Path]) -> Dict[str, Any]:
        """Get information about a file."""
        try:
            file_path = Path(file_path)
            if not file_path.exists():
                raise FileNotFoundError(f"File not found: {file_path}")
            
            stat = file_path.stat()
            content = file_path.read_bytes()
            mime_type = magic.from_buffer(content, mime=True)
            
            return {
                'path': str(file_path),
                'filename': file_path.name,
                'size': stat.st_size,
                'mime_type': mime_type,
                'created': datetime.fromtimestamp(stat.st_ctime),
                'modified': datetime.fromtimestamp(stat.st_mtime),
            }
            
        except Exception as e:
            self.logger.error(f"Error getting file info for {file_path}: {str(e)}")
            raise FileProcessingError(f"Failed to get file info: {str(e)}")

# Example usage
if __name__ == "__main__":
    import asyncio
    
    async def test_file_manager():
        # Set up logging
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        logger = logging.getLogger(__name__)
        
        try:
            # Initialize file manager
            file_manager = FileManager()
            
            # Test saving a PDF file
            test_pdf_content = b"%PDF-1.4\n..."  # Dummy PDF content
            pdf_info = await file_manager.save_file(
                test_pdf_content,
                "test.pdf",
                "pdf"
            )
            logger.info(f"Saved PDF file: {pdf_info}")
            
            # Get file info
            file_info = file_manager.get_file_info(pdf_info['path'])
            logger.info(f"File info: {file_info}")
            
            # Load file
            content = await file_manager.load_file(pdf_info['path'])
            logger.info(f"Loaded file size: {len(content)} bytes")
            
            # Clean up old files
            file_manager.cleanup_old_files(max_age_days=1)
            
        except Exception as e:
            logger.error(f"Test failed: {str(e)}", exc_info=True)
            raise

    # Run the test
    asyncio.run(test_file_manager())