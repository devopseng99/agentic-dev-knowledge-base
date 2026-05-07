---
title: "Build a Custom ChatGPT-like Chatbot with Chainlit"
url: "https://dev.to/edenai/build-a-custom-chatgpt-like-chatbot-with-chainlit-2d89"
author: "Eden AI"
category: "agent-ui-frameworks"
---

# Build a Custom ChatGPT-like Chatbot with Chainlit
**Author:** Eden AI
**Published:** March 12, 2024

## Overview
Tutorial building a conversational AI chatbot using Chainlit with AskYoda (Eden AI), supporting multiple LLM providers including OpenAI, Cohere, and Google Cloud.

## Key Concepts

### Chat Settings
```python
cl.ChatSettings([
    Select(id="llm_provider", label="LLM Provider",
           values=["cohere", "amazon", "anthropic", "ai21labs", "openai", "google"]),
    Select(id="llm_model", label="LLM Model", values=["command", "command-light"])
])
```

### Message Handler
```python
@cl.on_message
async def main(message: cl.Message):
    headers = {"Authorization": f"Bearer {Api_Key}"}
    json_payload = {
        "query": f"{message.content}",
        "llm_provider": llm_provider,
        "history": history,
        "llm_model": llm_model,
    }
    response = requests.post(url, json=json_payload, headers=headers)
    result = json.loads(response.text)
    await cl.Message(content=f"{result['result']}", author='AskYoda').send()
```

Run with: `chainlit run app.py`
