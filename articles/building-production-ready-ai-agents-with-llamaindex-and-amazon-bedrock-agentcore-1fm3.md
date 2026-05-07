---
title: "Building Production-Ready AI Agents with LlamaIndex and Amazon Bedrock AgentCore"
url: "https://dev.to/aws/building-production-ready-ai-agents-with-llamaindex-and-amazon-bedrock-agentcore-1fm3"
author: "Danilo Poccia"
category: "llamaindex-agent"
---

# Building Production-Ready AI Agents with LlamaIndex and Amazon Bedrock AgentCore

**Author:** Danilo Poccia
**Published:** September 15, 2025

## Overview

Demonstrates developing a production-ready AI agent combining LlamaIndex's data-centric approach with Amazon Bedrock AgentCore's memory management capabilities using FunctionAgent and BedrockConverse.

## Key Concepts

### Tool Integration

```python
from llama_index.core.tools import FunctionTool

def calculator(expression: str) -> str:
    """Evaluate a mathematical expression and return the result."""
    try:
        result = eval(expression)
        return f"Result: {result}"
    except Exception as e:
        return f"Error: {str(e)}"

def text_analyzer(text: str) -> str:
    """Analyze text and return word count, character count, and basic statistics."""
    words = text.split()
    return f"Words: {len(words)}, Characters: {len(text)}"

calculator_tool = FunctionTool.from_defaults(fn=calculator)
text_analyzer_tool = FunctionTool.from_defaults(fn=text_analyzer)
```

### Agent Configuration with Bedrock

```python
from llama_index.llms.bedrock_converse import BedrockConverse
from llama_index.embeddings.bedrock import BedrockEmbedding
from llama_index.core import Settings

Settings.llm = BedrockConverse(model="us.anthropic.claude-sonnet-4-20250514-v1:0")
Settings.embed_model = BedrockEmbedding(model_name="amazon.titan-embed-text-v2:0")
```

### FunctionAgent Implementation

```python
from llama_index.core.agent import FunctionAgent

agent = FunctionAgent(
    tools=[calculator_tool, text_analyzer_tool, wiki_tool, memory_tool],
    llm=Settings.llm,
    system_prompt=system_prompt,
)
```

### AgentCore Memory Management

Memory operates through three phases:
1. **Retrieval**: `get_last_k_turns()` for conversation history, `RetrieveMemories` for semantic search
2. **Prompt Enrichment**: Dynamically updates agent's system prompt with retrieved context
3. **Storage**: `create_event()` stores conversations, triggering automatic extraction

### Deployment

```shell
agentcore configure -n llamaindexagent -e main.py
agentcore launch --local  # Test locally
agentcore launch         # Deploy to AWS
agentcore status         # Check deployment
agentcore destroy        # Clean up resources
```

Memory namespaces (`/actor/{actor_id}/`) provide complete user isolation.
