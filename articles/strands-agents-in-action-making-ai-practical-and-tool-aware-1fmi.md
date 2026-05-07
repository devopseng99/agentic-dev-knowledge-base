---
title: "Strands Agents in Action: Making AI Practical and Tool-Aware"
url: "https://dev.to/girishmukim/strands-agents-in-action-making-ai-practical-and-tool-aware-1fmi"
author: "Girish Mukim"
category: "aws-agents"
---

# Strands Agents in Action: Making AI Practical and Tool-Aware
**Author:** Girish Mukim
**Published:** September 1, 2025

## Overview
Hands-on tutorial on Strands Agents combining LLM reasoning with tool integration on Amazon Bedrock. Progresses from basic model-only agent to tool-enabled system with calculator. Demonstrates the SDK's automatic decision-making on when to use tools vs. pure model reasoning. Covers installation, version management, and BedrockModel configuration.

## Key Concepts

### Strands Agent Workflow
User Query -> Strands Agent SDK (determines tool necessity) -> LLM and Tools -> Combined Result

### SDK Packages
- `strands-agents`: Core framework (v1.4.0 -> v1.6.0)
- `strands-agents-tools`: Optional specialized tools (v0.2.3 -> v0.2.5)
- `boto3`: AWS SDK dependency

### Tool Integration
SDK automatically decides whether queries require tool invocation or can be answered through model reasoning alone.

## Code Examples

### Basic Agent (No Tools)
```python
from strands import Agent
from strands.models import BedrockModel

model = BedrockModel(model_id="amazon.nova-lite-v1:0", region_name="us-east-1")
agent = Agent(model=model)
response = agent("Hello! Can you introduce yourself in one line?")
print(response)
```

### Agent with Calculator Tool
```python
from strands import Agent
from strands.models import BedrockModel
from strands_tools import calculator

model = BedrockModel(
    model_id="amazon.nova-lite-v1:0",
    region_name="us-east-1"
)

system_prompt = """You are a simple, dedicated calculator. Your sole purpose is to perform mathematical calculations.

Instructions:
1.  Identify: Check if the user's input contains a clear mathematical operation.
2.  Use Tool: If the input is a calculation, you must use the provided `calculator` tool.
3.  Respond Directly: Your output must be the input from user and final numerical result.
4.  Handle Non-Calculations: Respond that you can only perform mathematical operations.
5.  Be Concise: Responses should be as brief as possible."""

agent = Agent(model=model, system_prompt=system_prompt, tools=[calculator])
result = agent("What is 23 * 17?")
print("\n\nFinal Answer:", result)
```

### Installation
```bash
pip install strands-agents strands-agents-tools boto3
```

### Version Check and Upgrade
```bash
pip show strands-agents | findstr Version
pip install --upgrade strands-agents strands-agents-tools
```
