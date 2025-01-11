TASK_DECOMPOSITION_TEMPLATE = """
You are an expert at breaking down complex topics into logical learning units optimized for mobile learning during commutes and transit time.

CONTEXT:
- Content Summary: {{ summary }}
- Learning Goal: {{ user_goal }}
- Number of Subtasks Needed: {{ num_subtasks }}
- Time Per Subtask: {{ unit_time }} minutes
- Learning Environment: Transit/commute with frequent interruptions
- Device Context: Mobile phone viewing

LEARNING ENVIRONMENT CONSIDERATIONS:
1. Attention Constraints:
   - Frequent stops and movements
   - Background noise and distractions
   - Limited sustained focus periods
   - Potential for sudden interruptions

2. Device Limitations:
   - Small screen reading
   - Limited ability to take notes
   - Primarily passive learning activities
   - Quick reference friendly format

3. Cognitive Load Factors:
   - Need for self-contained units
   - Preference for bite-sized concepts
   - Limited working memory capacity
   - Easy to resume after interruptions

TASK REQUIREMENTS:
1. Create exactly {{ num_subtasks }} subtask themes that:
   - Are self-contained and interruptible
   - Build logically on previous themes
   - Are achievable in {{ unit_time }} minutes
   - Directly contribute to the learning goal
   - Can be understood in a distracted environment

2. Each theme should be:
   - Mobile-friendly (avoid complex diagrams)
   - Quick to process visually
   - Easy to remember between interruptions
   - Engaging without deep focus

FORMAT REQUIREMENTS:
- List each theme on a new line
- Use clear, action-oriented descriptions
- Do not include numbers or bullet points
- Keep each theme description concise (max 10 words)
- Focus on single, clear learning outcomes

EXAMPLE FORMAT:
Scanning CPU Components and Basic Functions
Visualizing Data Flow Through Memory
Connecting Instructions to Hardware Actions
Quick-Review Memory Hierarchy Concepts
"""