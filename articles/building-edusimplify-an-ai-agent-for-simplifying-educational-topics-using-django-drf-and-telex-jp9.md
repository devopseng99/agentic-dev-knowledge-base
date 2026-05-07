---
title: "Building EduSimplify: An AI Agent for Simplifying Educational Topics using Django, DRF, and Telex A2A Protocol"
url: "https://dev.to/elkufahn_muhammadahmad_/building-edusimplify-an-ai-agent-for-simplifying-educational-topics-using-django-drf-and-telex-jp9"
author: "El-kufahn Muhammad Ahmad"
category: "ai-agent-django"
---

# Building EduSimplify: An AI Agent for Simplifying Educational Topics using Django, DRF, and Telex A2A Protocol

**Author:** El-kufahn Muhammad Ahmad
**Published:** November 3, 2025

## Overview
EduSimplify is an educational assistant powered by AI that breaks down complex science concepts into accessible explanations. It integrates with Django and Django REST Framework and communicates through Telex.im's Mastra A2A (Agent-to-Agent) Protocol using JSON-RPC 2.0 format.

## Key Concepts
- Django REST Framework for API development
- Google Gemini for content generation
- A2A (Agent-to-Agent) Protocol with JSON-RPC 2.0
- Conversation persistence with Django models

## Code Examples

### Project Structure
```
agents/
  views.py          # A2A JSON-RPC request handling
  serializers.py    # DRF validation for JSON-RPC schema
  models.py         # Conversation, Message, Artifact models
  utils.py          # Google Gemini integration
```

### JSON-RPC Message Format
```json
{
  "jsonrpc": "2.0",
  "id": "001",
  "method": "message/send",
  "params": {
    "message": {
      "role": "user",
      "messageId": "12345",
      "parts": [
        { "kind": "text", "text": "Explain Newton's third law" }
      ]
    }
  }
}
```

### Google Gemini Integration (utils.py)
```python
import os
from google import genai
from django.conf import settings

def _get_genai_client():
    api_key = getattr(settings, "GEMINI_API_KEY", None) or os.environ.get("GEMINI_API_KEY")
    if not api_key:
        raise RuntimeError("Gemini API key not configured (GEMINI_API_KEY)")
    return genai.Client(api_key=api_key)

def ask_gemini(prompt, model="gemini-2.5-flash"):
    client = _get_genai_client()
    try:
        response = client.models.generate_content(model=model, contents=prompt)
    except Exception as exc:
        raise RuntimeError(f"genai request failed: {exc}") from exc

    text = getattr(response, "text", str(response))
    if not text:
        raise RuntimeError("genai returned empty response")
    return text
```

### Core View Implementation
```python
class A2AAgentView(APIView):
    def post(self, request, *args, **kwargs):
        raw = request.data or {}
        top_serializer = JSONRPCRequestSerializer(data=raw)
        # ... validation ...
        if method == "message/send":
            pser = MessageParamsSerializer(data=params)
            # ... extract user prompt ...
        user_prompt = last["text"]

        explanation = ask_gemini(
            f"You are EduSimplify... Concept: {user_prompt}\nAnswer:"
        )

        result = {
            "id": task_id,
            "contextId": conv.context_id,
            "status": {
                "state": "completed",
                "timestamp": datetime.utcnow().isoformat() + "Z",
                "status": {
                    "role": "agent",
                    "parts": [{"kind": "text", "text": explanation}]
                },
            },
        }
        return Response(make_a2a_success(request_id, result))
```

### cURL Example
```bash
curl -X POST https://el-kufahn-hng13.up.railway.app/a2a/agent/edusimplify \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": "001",
    "method": "message/send",
    "params": {
      "message": {
        "role": "user",
        "messageId": "abc123",
        "parts": [
          {"kind": "text", "text": "Explain photosynthesis in simple terms"}
        ]
      }
    }
  }'
```

### A2A Response Format
```json
{
  "jsonrpc": "2.0",
  "id": "001",
  "result": {
    "status": {
      "state": "completed",
      "message": {
        "role": "agent",
        "parts": [
          {
            "kind": "text",
            "text": "Photosynthesis is how plants convert sunlight into energy..."
          }
        ]
      }
    }
  }
}
```

## Request Processing Flow
1. Telex sends JSON-RPC request to public endpoint
2. A2AAgentView validates using DRF serializers
3. Unique context_id identifies each conversation
4. User message stored in database
5. Text passed to ask_gemini() helper function
6. Gemini generates simplified explanation
7. Structured A2A-compliant JSON response returned
