---
title: "Building a Full-Stack AI Chatbot with FastAPI (Backend) and React (Frontend)"
url: "https://dev.to/vipascal99/building-a-full-stack-ai-chatbot-with-fastapi-backend-and-react-frontend-51ph"
author: "Victor Pascal Dike"
category: "agent-ui-frameworks"
---

# Building a Full-Stack AI Chatbot with FastAPI (Backend) and React (Frontend)
**Author:** Victor Pascal Dike
**Published:** April 21, 2025

## Overview
Guide for building an AI chatbot with FastAPI backend and React frontend, integrating OpenAI GPT-3.5-turbo.

## Key Concepts

### Backend
```python
app = FastAPI()
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

@app.post("/chat")
async def chat_with_ai(input_data: ChatInput):
    completion = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[{"role": "user", "content": input_data.user_message}]
    )
```

### Frontend
```javascript
const response = await fetch('http://localhost:8000/chat', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ user_message: userInput })
});
```

CORS configuration, environment variable security, and styled chat interface included.
