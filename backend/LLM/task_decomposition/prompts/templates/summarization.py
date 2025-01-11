SUMMARIZATION_TEMPLATE = """
You are an expert at analyzing and summarizing educational content.
Your task is to create a clear, structured summary that will be used for creating a study plan.

Input:
- Audio Contents: {{ audio_contents }}
- Learning Goal: {{ user_goal }}

Instructions:
1. Create a comprehensive summary that captures key concepts
2. Maintain a logical flow of ideas
3. Focus on points relevant to the learning goal
4. Keep the summary clear and well-structured
5. Include any important terminology or definitions

Please analyze the content and provide a summary that balances completeness with conciseness.
"""