---
title: "I built a city explorer using the Strands Agents SDK"
url: "https://dev.to/aws/i-built-a-city-explorer-using-the-strands-agents-sdk-4n9b"
author: "Veliswa Boya"
category: "aws-agents"
---

# I built a city explorer using the Strands Agents SDK
**Author:** Veliswa Boya
**Published:** June 24, 2025

## Overview
Building a city explorer application using Strands Agents SDK with Amazon Bedrock. Compares Strands approach to previous Knowledge Bases for Amazon Bedrock implementation, highlighting model-driven design over predefined templates.

## Key Concepts

### Setup

```bash
python -m venv .venv
source .venv/bin/activate
pip install strands-agents strands-agents-tools
```

### City Explorer Implementation

```python
from strands import Agent
from strands.models import BedrockModel
from botocore.config import Config as BotocoreConfig

boto_config = BotocoreConfig(
    retries={"max_attempts": 3, "mode": "standard"},
    connect_timeout=5,
    read_timeout=60
)

bedrock_model = BedrockModel(
    model_id="us.anthropic.claude-3-7-sonnet-20250219-v1:0",
    region_name="us-east-1",
    temperature=0.3,
    top_p=0.8,
    stop_sequences=["###", "END"],
    boto_client_config=boto_config,
)

city_explorer_agent = Agent(
    model=bedrock_model,
    system_prompt="You are a knowledgeable city facts assistant. Provide concise, interesting facts about cities when asked. Keep responses brief and engaging."
)

print("City Facts Assistant - Ask me about any city! (type 'quit' to exit)")

while True:
    user_input = input("\nYou: ").strip()
    if user_input.lower() in ['quit', 'exit', 'bye']:
        print("Goodbye!")
        break
    if user_input:
        response = city_explorer_agent(user_input)
        print(f"\nAssistant: {response}")
```

### Strands vs Bedrock Agents
- Strands: Open source framework deployable anywhere, better for experimentation
- Bedrock Agents: Fully managed hosted solutions for production
- They are complementary, not competing
