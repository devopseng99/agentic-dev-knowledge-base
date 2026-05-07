---
title: "Chatbot with Semantic Kernel - Part 6: AI Connectors"
url: "https://dev.to/davidgsola/chatbot-with-semantic-kernel-part-6-ai-connectors-4b63"
author: "David Sola"
category: "a2a-protocols"
---

# Chatbot with Semantic Kernel: AI Connectors
**Author:** David Sola
**Published:** February 17, 2025

## Overview
How Semantic Kernel enables swapping between AI providers to compare model performance, with Ollama for local model execution.

## Key Concepts

```python
from semantic_kernel.connectors.ai.ollama import OllamaChatCompletion

self.kernel.add_service(OllamaChatCompletion(service_id='chat_completion'))
self.chat_service = self.kernel.get_service(type=OllamaChatCompletion)
```

Use environment variables to dynamically select providers (Azure OpenAI, OpenAI, Ollama) without code changes.
