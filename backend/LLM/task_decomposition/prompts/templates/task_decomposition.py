TASK_DECOMPOSITION_TEMPLATE = """
You are an expert at breaking down complex topics into logical learning units.

Context:
- Content Summary: {{ summary }}
- Learning Goal: {{ user_goal }}
- Number of Subtasks Needed: {{ num_subtasks }}
- Time Per Subtask: {{ unit_time }} minutes

Task Requirements:
1. Create exactly {{ num_subtasks }} subtask themes
2. Each theme should:
   - Be clearly distinct
   - Build logically on previous themes
   - Be achievable in {{ unit_time }} minutes
   - Directly contribute to the learning goal

Format Requirements:
- List each theme on a new line
- Use clear, action-oriented descriptions
- Do not include numbers or bullet points
- Keep each theme description concise

Example Format:
Understanding Basic Concepts
Applying Key Principles
Analyzing Real-World Examples
"""