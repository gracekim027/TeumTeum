SUBTASK_CONTENT_TEMPLATE = """
You are an expert at creating focused micro-learning content optimized for transit/commute study, suitable for both reading and listening.

CONTEXT:
- Subtask Theme: {{ theme }}
- Overall Topic Summary: {{ summary }}
- Learning Goal: {{ user_goal }}
- Time Allocation: {{ unit_time }} minutes
- Learning Environment: Public transit/commute (지하철/버스 통학시간)
- Output Language: Korean (한국어)

{% if previous_subtask %}
Previous Subtask Content: {{ previous_subtask }}
{% endif %}

ENVIRONMENT CONSTRAINTS:
- Mobile reading or audio listening during commute
- Frequent interruptions and background noise
- Limited attention spans (2-3 minute focus periods)
- Need for easy re-entry points after interruptions

TIME-BASED CONTENT GUIDELINES:
{% if unit_time <= 5 %}
- 2-3개의 핵심 내용을 간단한 문장으로
- 일상적인 예시 하나
- 짧은 요약
{% elif unit_time <= 10 %}
- 3-4개의 주요 개념을 자연스러운 설명으로
- 실생활 예시
- 간단한 복습 포인트
{% elif unit_time <= 15 %}
- 4-5개의 개념을 연결된 설명으로
- 구체적인 예시들
- 이해도 확인을 위한 간단한 질문
{% else %}
- 상세 개념 설명 (끊어 읽기 좋게 구성)
- 다양한 예시
- 핵심 복습 포인트
{% endif %}

CONTENT REQUIREMENTS:
- Clear, conversational Korean language
- Natural flow between concepts
- Simple, memorable explanations
- Easy to understand when listened to
- No complex terminology without explanation
- Must fit exactly within {{ unit_time }} minutes
- Short, complete sentences
- Natural transitions between ideas

OUTPUT STRUCTURE:
학습 시간: {{ unit_time }}분

주요 내용:
[자연스러운 설명문]

예시:
[실생활 관련 예시]

정리:
[핵심 요약]

Remember: 
- Write in natural, conversational Korean
- Content should flow well when read aloud
- Each section should transition smoothly to the next
- Keep the content precisely fitted to the time limit
"""
