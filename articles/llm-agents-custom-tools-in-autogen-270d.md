---
title: "LLM Agents: Custom Tools in Autogen"
url: "https://dev.to/admantium/llm-agents-custom-tools-in-autogen-270d"
author: "Sebastian"
category: "agent-tool-use"
---

# LLM Agents: Custom Tools in Autogen

**Author:** Sebastian
**Published:** September 30, 2024

## Overview

Explains how to implement and configure custom tools within the Autogen framework for LLMs, addressing documentation gaps around local LLM implementations versus OpenAI-only examples.

## Key Concepts

### Requirements

- autogen v0.2.27
- Ollama as LLM engine wrapped with LiteLLM server for OpenAI API compatibility

### Tool Implementation

Tools are Python functions with type annotations. The article provides a Wikipedia search example using the Wikipedia API and `mwparserfromhell` library.

### Three Essential Configuration Steps

1. **Specification** -- Define tools as OpenAI API-compatible JSON structures within the agent's `llm_config`
2. **Registration** -- Use `register_function()` to connect functions with agents and executors
3. **LLM Awareness** -- Optionally add tool definitions to system prompts for specific LLM formats (natural-functions, nexusraven)

### Implementation Pattern

The complete implementation involves:
- Function specification with parameters and type definitions
- Agent creation with `AssistantAgent`
- User proxy configuration with `UserProxyAgent`
- Function registration and chat initialization

### Common Debugging Issues

- Unfounded tool suggestions despite irrelevant tasks
- Continuous function call loops between agents
- Message parsing errors with encoding or formatting problems

### Key Insight

Effective tool usage requires "thorough system prompts" and careful configuration to prevent agents from repeatedly invoking functions unnecessarily.
