---
title: "Automate Your Health: Building an AI Medical Agent with GPT-4 Function Calling and Google Calendar"
url: "https://dev.to/beck_moulton/automate-your-health-building-an-ai-medical-agent-with-gpt-4-function-calling-and-google-calendar-47nk"
author: "Beck_Moulton"
category: "function-calling-gpt"
---

# Automate Your Health: Building an AI Medical Agent with GPT-4 Function Calling and Google Calendar

**Author:** Beck_Moulton
**Published:** January 20, 2026

## Overview
A tutorial for creating an intelligent healthcare scheduling system that uses OpenAI's GPT-4 model with function calling capabilities to automate medical appointment booking through integration with Google Calendar and a FastAPI backend.

## Key Concepts
The system combines GPT-4's reasoning abilities, function calling for structured API interactions, Google Calendar API integration, and a FastAPI backend architecture. The architecture separates the "Brain" (LLM reasoning) from the "Hands" (API execution).

## Code Examples

### Tools Definition (Python)

```python
# tools.py
tools = [
    {
        "type": "function",
        "function": {
            "name": "get_calendar_availability",
            "description": "Check if a specific time slot is free on the doctor's calendar",
            "parameters": {
                "type": "object",
                "properties": {
                    "start_time": {"type": "string", "description": "ISO format string"},
                    "end_time": {"type": "string", "description": "ISO format string"},
                },
                "required": ["start_time", "end_time"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "book_appointment",
            "description": "Create a new calendar event for the medical appointment",
            "parameters": {
                "type": "object",
                "properties": {
                    "summary": {"type": "string", "description": "Reason for visit"},
                    "start_time": {"type": "string"},
                    "end_time": {"type": "string"},
                },
                "required": ["summary", "start_time", "end_time"],
            },
        },
    }
]
```

### Google Calendar Integration (Python)

```python
from googleapiclient.discovery import build

def create_appointment(summary, start_time, end_time):
    event = {
        'summary': summary,
        'start': {'dateTime': start_time, 'timeZone': 'UTC'},
        'end': {'dateTime': end_time, 'timeZone': 'UTC'},
    }
    return service.events().insert(calendarId='primary', body=event).execute()
```

### FastAPI Agent Controller (Python)

```python
from fastapi import FastAPI
from openai import OpenAI
import os

app = FastAPI()
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

@app.post("/schedule")
async def handle_medical_request(user_input: str):
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": user_input}],
        tools=tools,
        tool_choice="auto"
    )

    message = response.choices[0].message

    if message.tool_calls:
        for tool_call in message.tool_calls:
            if tool_call.function.name == "book_appointment":
                args = json.loads(tool_call.function.arguments)
                result = create_appointment(args['summary'], args['start_time'], args['end_time'])
                return {"status": "success", "data": result}

    return {"status": "clarification_needed", "message": message.content}
```
