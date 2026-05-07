---
title: "Introduction to SmolAgents"
url: "https://dev.to/samagra07/introduction-to-smolagents-52bp"
author: "Samagra Shrivastava"
category: "smolagents-huggingface"
---

# Introduction to SmolAgents

**Author:** Samagra Shrivastava
**Published:** January 27, 2025

## Overview

SmolAgents is a cutting-edge library developed by Hugging Face designed to streamline the creation and management of AI agents that autonomously execute tasks using large language models.

## Key Concepts

### Core Features

- **Code Agents** for task-specific code generation
- **ToolCallingAgents** for JSON/text-based actions
- Extensive technology integrations
- User-friendly interface

### Key Benefits

- Eliminates complex coding requirements
- Ensures reliability for production use
- Supports dynamic task adaptation

### What Are AI Agents?

AI agents autonomously execute tasks for users or systems, integrating tools like web searches and coding utilities. SmolAgents provides the framework to build these agents with minimal boilerplate.

## Getting Started

The SmolAgents documentation and tutorials are available on:
- GitHub repository: https://github.com/huggingface/smolagents
- Hugging Face blog tutorials

```bash
pip install smolagents
```

```python
from smolagents import CodeAgent, HfApiModel

agent = CodeAgent(
    tools=[],
    model=HfApiModel(model_id="Qwen/Qwen2.5-Coder-32B-Instruct")
)

response = agent.run("What is the capital of France?")
print(response)
```
