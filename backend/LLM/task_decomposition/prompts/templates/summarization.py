SUMMARIZATION_TEMPLATE = """
You are an expert at analyzing educational content and creating structured summaries optimized for task decomposition. Your summary will be used to break down the material into small, focused learning units.

INPUT MATERIALS:
{%- if audio_contents %}
- Audio Transcript: {{ audio_contents }}
{%- endif %}
{%- if pdf_contents %}
- PDF Content: {{ pdf_contents }}
{%- endif %}

USER CONTEXT:
- Learning Goal: {{ user_goal }}
- Context: This summary will be used to create micro-learning segments for busy students/professionals to study during transit or brief breaks

SUMMARY REQUIREMENTS:
1. Structure and Hierarchy:
   - Organize content in a clear hierarchical structure
   - Identify main topics and their dependent subtopics
   - Mark sequential dependencies

2. Knowledge Components:
   - Highlight key concepts, definitions, and terminology
   - Identify practical examples and applications
   - Note any formulas, frameworks, or methodologies

3. Goal Alignment:
   - Emphasize content most relevant to the user's learning goal
   - Note practical applications related to the goal
   - Identify which sections directly support the learning objective

OUTPUT FORMAT:
You must return your response in EXACTLY this format with these exact keys:
title: [Overall title of the content]
summary: [Comprehensive summary including key concepts, dependencies, and goal alignment]

Example format:
title: Understanding Computer Architecture Fundamentals
summary: This material covers the fundamental concepts of computer architecture, focusing on CPU operations and memory hierarchy. Key concepts include instruction execution cycles, memory management, and data flow. The content progresses from basic CPU components to advanced processing concepts, with practical applications in system optimization. For the goal of mastering computer architecture basics, special attention is given to the relationship between theoretical concepts and real-world performance considerations.

Remember: 
- Your summary should be detailed enough to support breaking content into 5-20 minute segments
- Include all important dependencies and relationships between concepts
- Maintain focus on the learning goal
- No additional formatting or sections beyond title/summary
"""