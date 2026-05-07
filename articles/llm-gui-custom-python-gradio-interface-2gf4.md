---
title: "LLM GUI: Custom Python Gradio Interface"
url: "https://dev.to/admantium/llm-gui-custom-python-gradio-interface-2gf4"
author: "Sebastian"
category: "agent-ui-frameworks"
---

# LLM GUI: Custom Python Gradio Interface
**Author:** Sebastian
**Published:** October 31, 2024

## Overview
Building a custom GUI for LLM agents using Gradio, leveraging persistent global objects that avoid code reload issues found in Streamlit.

## Key Concepts

### Layout Architecture
```python
with gr.Blocks() as gui:
    with gr.Row() as config:
        with gr.Column():
            # model config
        with gr.Column():
            # history
```

### Persistent LLM Objects
```python
AGENT = GradioAssistantAgent(...)
USER = GradioUserProxyAgent(...)
USER.initiate_chat(AGENT, message="...", clear_history=False)
```

### Configuration
```python
MODEL = "llama3"
TEMPERATURE = 0.0
SYSTEM_PROMPT = "You are a knowledgeable librarian..."
```

Stack: Python 3.11, Gradio 4.28.3, Ollama 0.1.7, AutoGen 0.2.27
