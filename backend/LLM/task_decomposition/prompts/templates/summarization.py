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
   - Mark sequential dependencies (concepts that must be learned in order)

2. Knowledge Components:
   - Highlight key concepts, definitions, and terminology
   - Identify practical examples and applications
   - Note any formulas, frameworks, or methodologies

3. Learning Progression:
   - Flag prerequisite knowledge
   - Indicate complexity levels of different sections
   - Mark natural breaking points between concepts

4. Goal Alignment:
   - Emphasize content most relevant to the user's learning goal
   - Note practical applications related to the goal
   - Identify which sections directly support the learning objective

FORMAT YOUR RESPONSE AS:

CORE CONCEPTS:
[List the fundamental ideas and concepts, organized hierarchically]

DETAILED BREAKDOWN:
[Comprehensive summary with clear section breaks and progression]

LEARNING DEPENDENCIES:
[Map showing which concepts depend on understanding of others]

GOAL-SPECIFIC HIGHLIGHTS:
[Elements particularly relevant to the user's stated learning goal]

Remember: Your summary should be detailed enough to support breaking this content into 5-20 minute learning segments while maintaining logical coherence.
"""