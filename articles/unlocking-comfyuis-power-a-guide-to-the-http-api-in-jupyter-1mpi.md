---
title: "Unlocking ComfyUI's Power: A Guide to the HTTP API in Jupyter"
url: "https://dev.to/raphiki/unlocking-comfyuis-power-a-guide-to-the-http-api-in-jupyter-1mpi"
author: "Raphael Semeteys"
category: "ai-image-video-generation"
---
# Unlocking ComfyUI's Power: A Guide to the HTTP API in Jupyter
**Author:** Raphael Semeteys  **Published:** 2025-09-04

## Overview
First in a four-part series about integrating ComfyUI with external tools. Demonstrates connecting a generative AI workflow through code: user prompt → OpenAI Assistant transforms it into JSON → injected into ComfyUI workflow via API → results displayed in notebook.

## Key Concepts

- **ComfyUI:** A powerful, modular node-based editor for generative image, video, and sound generation workflows
- **Integration Approach:** Moving "beyond the graphical interface to build automated, intelligent systems for creative tasks"
- **Workflow Preparation:** Export workflows as JSON files using ComfyUI's "File / Export (API)" menu
- **Asynchronous Processing:** ComfyUI processes workflows asynchronously; polling the `/history` endpoint retrieves results

```python
# Step 1: Get User Input
print("Please enter your prompt")
user_prompt = input()
```

```python
# Step 2: Generate JSON Style Guide Using OpenAI Assistant
import os
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()
client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))
thread = client.beta.threads.create()
message = client.beta.threads.messages.create(
    thread_id=thread.id,
    role="user",
    content=user_prompt
)
run = client.beta.threads.runs.create(
    thread_id=thread.id,
    assistant_id="asst_Uj0Qr0rG0bz8NVk1LWiS9UKv"
)

import time
while run.status != "completed":
    time.sleep(1)
    run = client.beta.threads.runs.retrieve(thread_id=thread.id, run_id=run.id)

messages = client.beta.threads.messages.list(thread_id=thread.id)
json_prompt = messages.data[0].content[0].text.value
```

```python
# Step 3: Trigger ComfyUI Workflow
import requests
import json

comfy_url = "http://127.0.0.1:8188"
prompt_url = f"{comfy_url}/prompt"

with open("t2i-krea.json", "r") as f:
    workflow = json.load(f)

workflow["39:6"]["inputs"]["text"] = json_prompt

payload = {
    "prompt": workflow,
    "client_id": "jupyter_notebook"
}

response = requests.post(prompt_url, json=payload)
prompt_id = response.json()['prompt_id']
```

```python
# Step 4: Retrieve Generated Images
import time
from IPython.display import Image, display

time.sleep(25)
history_url = f"{comfy_url}/history/{prompt_id}"
history = requests.get(history_url).json()

image_outputs = history[prompt_id]["outputs"]["9"]["images"]

for image in image_outputs:
    filename = image["filename"]
    image_url = f"{comfy_url}/view?filename={filename}"
    display(Image(url=image_url, width=200))
```

### Series Context
1. HTTP API in Jupyter (this article)
2. WebSockets & ComfyUI: Building Interactive AI Applications
3. Automating Image Generation with n8n and ComfyUI
4. Beyond the API: Integrating ComfyUI and Flowise via MCP

## GitHub Repository
[comfyanonymous/ComfyUI](https://github.com/comfyanonymous/ComfyUI)
