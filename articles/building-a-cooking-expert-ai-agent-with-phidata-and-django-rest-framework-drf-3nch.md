---
title: "Building a Cooking Expert AI Agent with Phidata and Django REST Framework (DRF)"
url: "https://dev.to/shemanto_sharkar/building-a-cooking-expert-ai-agent-with-phidata-and-django-rest-framework-drf-3nch"
author: "Bidut Sharkar Shemanto"
category: "ai-agent-django"
---

# Building a Cooking Expert AI Agent with Phidata and Django REST Framework (DRF)

**Author:** Bidut Sharkar Shemanto
**Published:** December 20, 2024

## Overview
Tutorial demonstrating construction of an AI-powered culinary assistant using Phidata and Django REST Framework. Creates a REST API endpoint that accepts cooking questions and returns intelligent responses from an AI agent powered by Groq's Llama model.

## Key Concepts
- Phidata for AI agent construction with model integration and tool extensibility
- Django REST Framework for robust API development
- Groq LLM (llama-3.3-70b-versatile) as the underlying model
- Serializers for input/output validation

## Code Examples

### Dependencies Installation
```bash
conda create -n myenv python=3.12 -y
conda activate myenv
pip install django djangorestframework phidata python-dotenv groq
```

### Project Setup
```bash
django-admin startproject my_project .
django-admin startapp api
```

### Agent Definition (agents/agent.py)
```python
from phi.agent import Agent
from phi.model.groq import Groq
from dotenv import load_dotenv

load_dotenv()

chef_agent = Agent(
    model=Groq(id='llama-3.3-70b-versatile'),
    tools=[],
    show_tool_calls=True,
    description="You are a recipe expert. You will be given a recipe and you have to answer the questions related to it.",
    instructions=[""],
)

def process_instruction(instruction: str) -> str:
    response = chef_agent.run(instruction, stream=False)
    return response.content
```

### Serializers (api/serializers.py)
```python
from rest_framework import serializers

class InstructionSerializer(serializers.Serializer):
    instruction = serializers.CharField(max_length=500)

class ResponseSerializer(serializers.Serializer):
    response = serializers.CharField(max_length=10000)
```

### Views (api/views.py)
```python
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .serializers import *
from agents.agent import process_instruction

class AgentView(APIView):
    def post(self, request):
        serializer = InstructionSerializer(data=request.data)
        if serializer.is_valid():
            instruction = serializer.validated_data['instruction']
            try:
                agent_response = process_instruction(instruction)
            except Exception as e:
                return Response(str(e), status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            response = {"response": agent_response}
            response_data = ResponseSerializer(data=response)
            if response_data.is_valid():
                return Response(response_data.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
```

### URL Configuration (api/urls.py)
```python
from django.urls import path
from .views import AgentView

urlpatterns = [
    path('agent/', AgentView.as_view(), name='agent-api'),
]
```

### Running the Server
```bash
python manage.py runserver
```

## Future Enhancements
- Adding external tools for web search
- Integrating knowledge bases
- Deploying with ASGI servers (Uvicorn/Daphne)
- Implementing conversation memory functionality
