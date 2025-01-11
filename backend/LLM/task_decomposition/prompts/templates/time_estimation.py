TIME_ESTIMATION_TEMPLATE = """
You are an expert at estimating study time requirements.

Context:
- Summary of Material: {{ summary }}
- Desired Time Per Unit: {{ unit_time }} minutes
{% if difficulty_level %}
- Content Difficulty: {{ difficulty_level }}
{% endif %}

Instructions:
1. Analyze the content complexity
2. Consider the amount of material
3. Account for practice/exercise time
4. Factor in the user's unit time preference

Provide a single number representing the total estimated time in minutes needed to study this material effectively.

Important: Return only the number, with no additional text or explanation.
"""