---
title: "First Impressions with Strands Agents SDK"
url: "https://dev.to/aws/first-impressions-with-strands-agents-sdk-4hha"
author: "Laura Salinas"
category: "aws-agents"
---

# First Impressions with Strands Agents SDK
**Author:** Laura Salinas
**Published:** June 23, 2025

## Overview
Hands-on first impressions of Strands Agents SDK, the open-source tool for building AI agents. Covers setup, basic agent creation, adding tools, and challenges with throttling. AWS teams built Q CLI using Strands in just 3 weeks.

## Key Concepts

### Setup

```bash
pip3 install strands-agents
pip3 install strands-agents-tools
```

Default model provider: Amazon Bedrock with Claude 3.7 Sonnet in US Oregon (us-west-2).

### Basic Agent

```python
from strands import Agent

agent = Agent()
agent("Tell me about agentic AI")
```

### Agent with Tools and System Prompt

```python
from strands import Agent
from strands_tools import http_request

dog_breed_helper = Agent(
    system_prompt="""You are a dog breed expert specializing
    in helping new pet parents decide what breed meets their lifestyles. Your expertise
    covers dog behavior, dog training, basic veterinary care, and dog breed standards.

    When giving recommendations:
    1. Provide both benefits and challenges of owning that breed.
    2. Only provide 3 recommendations at a time.
    3. Give examples when necessary
    4. Avoid jargon, but indicate when complex concepts are important

    Your goal is to help pet parents make an informed decision about their choice in a dog.
    """,
    tools=[http_request]
)

query = """
Answer these questions:
1. Which dog should I adopt as a first time owner?
2. Search wikipedia for the top 5 most popular dog breeds of 2024
"""
response = dog_breed_helper(query)
```

Strands automatically knows which tools to invoke based on conversation context.

### Throttling Workaround
When encountering ThrottlingException, switch models: `model="anthropic.claude-3-5-sonnet-20240620-v1:0"`
