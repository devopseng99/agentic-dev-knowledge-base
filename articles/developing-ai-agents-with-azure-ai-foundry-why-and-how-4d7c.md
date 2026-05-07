---
title: "Developing AI Agent Application with Azure AI Foundry - Why and How?"
url: "https://dev.to/imaginex/developing-ai-agents-with-azure-ai-foundry-why-and-how-4d7c"
author: "Yaohua Chen"
category: "cloud-agents"
---

# Developing AI Agent Application with Azure AI Foundry - Why and How?
**Author:** Yaohua Chen
**Published:** June 11, 2025

## Overview
End-to-end guide for building an AI image design agent application using Azure AI Foundry with OpenAI models (gpt-4o, gpt-image-1). Covers platform comparison (vs AWS Bedrock, Google Vertex, open-source frameworks), architecture design with RAG via Azure AI Search, agent orchestration, and step-by-step Python implementation with Streamlit UI.

## Key Concepts

### Analyze User Input

```python
from openai import AzureOpenAI
import os

def analyze_user_input_agent(user_input):
    client = AzureOpenAI(
        api_version="2024-12-01-preview",
        azure_endpoint=os.getenv('AZURE_GPT4_MODEL_ENDPOINT'),
        api_key=os.getenv("AZURE_API_KEY")
    )
    completion = client.chat.completions.create(
        model="gpt-4o",
        messages=[{
            "role": "user",
            "content": f"""Analyze the user's input and determine the image type.
            User's input: {user_input}"""
        }],
        temperature=0.0,
    )
    return completion.choices[0].message.content
```

### Convert Reference Image

```python
from openai import AzureOpenAI
import base64

def convert_image_agent(image_file):
    client = AzureOpenAI(
        api_version="2025-04-01-preview",
        azure_endpoint=os.getenv('AZURE_IMAGE_MODEL_ENDPOINT'),
        api_key=os.getenv('AZURE_API_KEY')
    )
    result = client.images.edit(
        model="gpt-image-1",
        image=image_file,
        prompt="Convert the given image to a simplified outline vector .svg image.",
    )
    image_bytes = base64.b64decode(result.data[0].b64_json)
    with open("temp/vector_image.png", "wb") as f:
        f.write(image_bytes)
    return "temp/vector_image.png"
```

### AI Agent for Instruction Analysis

```python
from azure.ai.projects import AIProjectClient
from azure.identity import DefaultAzureCredential

def analyze_instruction_agent(image_type):
    agent_client = AIProjectClient.from_connection_string(
        credential=DefaultAzureCredential(),
        conn_str=os.getenv("AZURE_PROJECT_CONNECTION_STRING")
    )
    agent = agent_client.agents.get_agent(os.getenv("AZURE_AGENT_ID"))
    thread = agent_client.agents.create_thread()
    message = agent_client.agents.create_message(
        thread_id=thread.id,
        role="user",
        content=f"What recommendations for {image_type} design?"
    )
    run = agent_client.agents.create_and_process_run(
        thread_id=thread.id, agent_id=agent.id)
    messages = agent_client.agents.list_messages(thread_id=thread.id)
    return messages.text_messages[0].get("text")["value"]
```

### Generate Design Images

```python
def generate_image_agent(user_input, image_type, recommendation, num_designs, reference_image):
    client = AzureOpenAI(
        api_version="2025-04-01-preview",
        azure_endpoint=os.getenv('AZURE_IMAGE_MODEL_ENDPOINT'),
        api_key=os.getenv('AZURE_API_KEY')
    )
    result = client.images.edit(
        model="gpt-image-1",
        image=open(reference_image, "rb"),
        prompt=f"Professional image design for {image_type}: {user_input}. Recommendation: {recommendation}",
        size="1024x1024",
        quality="high",
        n=num_designs
    )
    for index, image in enumerate(result.data):
        image_bytes = base64.b64decode(image.b64_json)
        with open(f"temp/generated_image_{index+1}.png", "wb") as f:
            f.write(image_bytes)
    return result
```

### Architecture
User Input -> Streamlit UI -> Azure AI Foundry Agent Orchestration -> OpenAI Models (gpt-4o, gpt-image-1) -> Azure Blob Storage + Azure AI Search (RAG)
