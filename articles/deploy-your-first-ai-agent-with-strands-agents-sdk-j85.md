---
title: "Deploy your first AI agent with Strands Agents SDK"
url: "https://dev.to/aws-builders/deploy-your-first-ai-agent-with-strands-agents-sdk-j85"
author: "Davide De Sio"
category: "serverless-agents"
---

# Deploy your first AI agent with Strands Agents SDK

**Author:** Davide De Sio
**Published:** May 26, 2025

## Overview
Strands Agents SDK is a simple-to-use Python-based SDK and code-first framework for building AI applications with reduced complexity. This guide deploys a weather agent on AWS Lambda.

## Code Examples

### Installation

```bash
pip install strands-agents
pip install strands-agents-tools
```

### Weather Agent Handler

```python
import boto3
from strands import Agent
from strands.models import BedrockModel
from strands_tools import http_request

WEATHER_SYSTEM_PROMPT = """You are a weather assistant with HTTP capabilities.
When retrieving weather information:
1. First get coordinates using https://api.weather.gov/points/{latitude},{longitude}
2. Then use the returned forecast URL to get the actual forecast
"""

bedrock_model = BedrockModel(
    model_id="us.amazon.nova-micro-v1:0",
    region_name='us-east-1'
)

def weather(event, _context):
    weather_agent = Agent(
        model=bedrock_model,
        system_prompt=WEATHER_SYSTEM_PROMPT,
        tools=[http_request],
    )
    response = weather_agent(event.get('prompt'))
    return str(response)
```

### Serverless Framework Config

```yaml
service: serverless-strands-weather-agent
frameworkVersion: '3'
plugins:
  - serverless-python-requirements
provider:
  name: aws
  runtime: python3.12
functions:
  weather:
    handler: src/agent/weather/handler.weather
    url: true
```

### Testing

```bash
sls invoke local -f weather --data '{"prompt": "What is the weather in Seattle?"}'
```

## Architecture Note
Amazon API Gateway has a hard timeout limit of 30 seconds. Lambda Function URLs support streaming without this constraint -- recommended for LLM-based agents.
