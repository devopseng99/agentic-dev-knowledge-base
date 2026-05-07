---
title: "First Impressions with Amazon Bedrock AgentCore"
url: "https://dev.to/aws/first-impressions-with-amazon-bedrock-agentcore-5dje"
author: "Laura Salinas"
category: "aws-agents"
---

# First Impressions with Amazon Bedrock AgentCore
**Author:** Laura Salinas
**Published:** September 10, 2025

## Overview
First-hand experience deploying an AI agent using Amazon Bedrock AgentCore. Covers the seven modular components (Runtime, Identity, Memory, Code Interpreter, Browser, Gateway, Observability), implementation with Strands Agents framework and Anthropic Claude, and honest assessment of documentation gaps.

## Key Concepts

### AgentCore Components (7 in Preview)

1. **AgentCore Runtime:** Serverless runtime for deploying and scaling AI agents
2. **AgentCore Identity:** Secure agent identity and access management
3. **AgentCore Memory:** Short-term and long-term memory across sessions
4. **AgentCore Code Interpreter:** Secure code execution in isolated sandboxes
5. **AgentCore Browser:** Cloud-based browser runtime for web interaction at scale
6. **AgentCore Gateway:** Secure tool discovery and API transformation
7. **AgentCore Observability:** Tracing, debugging, monitoring with OpenTelemetry

### Implementation with Strands Agents

```python
import os
from bedrock_agentcore.runtime import BedrockAgentCoreApp
from strands import Agent
from strands.models.anthropic import AnthropicModel
from strands_tools import use_aws

app = BedrockAgentCoreApp()

model = AnthropicModel(
    client_args={
        "api_key": os.getenv("api_key"),
    },
    max_tokens=1028,
    model_id="claude-sonnet-4-20250514",
    params={"temperature": 0.3,}
)

agent = Agent(model=model, tools=[use_aws])

@app.entrypoint
def strands_agent_anthropic(payload):
    user_input = payload.get("prompt")
    response = agent(user_input)
    return response.message["content"][0]['text'].replace('\\n', '\n')

if __name__ == "__main__":
    app.run()
```

### Deployment with Starter Toolkit

```bash
agentcore configure -e agent.py
agentcore launch
agentcore invoke '{"prompt": "your query"}'
```

### Challenges Encountered

- Sample notebooks don't mention enabling CloudWatch Transaction Search (mandatory for Runtime)
- IAM permissions complexity: finding the agent's execution role requires searching IAM for "agentcore"
- Using use_aws tool requires local AWS credentials at ~/.aws/credentials
