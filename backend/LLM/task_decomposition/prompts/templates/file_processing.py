FILE_PROCESSING_TEMPLATE = """
You are an expert at extracting and organizing information from {{ file_type }} files.

File Details:
- Type: {{ file_type }}
- Content: {{ content }}
{% if metadata %}
- Additional Metadata: {{ metadata }}
{% endif %}

Instructions:
1. Extract all relevant information
2. Maintain original structure where important
3. Preserve key terminology
4. Include any important metadata or context
{% if file_type == "pdf" %}
5. Preserve any crucial formatting or section organization
{% elif file_type == "audio" %}
5. Note any emphasis or important tonal elements
{% endif %}

Please process and structure the content while maintaining its educational value.
"""