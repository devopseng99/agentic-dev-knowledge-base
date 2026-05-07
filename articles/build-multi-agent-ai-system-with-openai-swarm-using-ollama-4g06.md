---
title: "Build Multi-Agent AI System with OpenAI Swarm using Ollama"
url: "https://dev.to/nodeshiftcloud/build-multi-agent-ai-system-with-openai-swarm-using-ollama-4g06"
author: "Aditi Bindal (NodeShift)"
category: "ai-agents-multi-agent"
---

# Build Multi-Agent AI System with OpenAI Swarm using Ollama

**Author:** Aditi Bindal (NodeShift)
**Published:** February 1, 2025
**Tags:** #ai #openai #performance #opensource

---

## Overview

This article demonstrates constructing a multi-agent AI system using OpenAI's Swarm framework with Ollama instead of API keys. The guide covers deploying on NodeShift's GPU infrastructure and implementing agent handoffs.

---

## Key Concepts

The article explains that "multi-agent AI systems represent a significant shift in how we approach complex problem-solving and task automation." Rather than relying on OpenAI's paid API, developers can leverage locally-installed language models through Ollama for greater autonomy.

---

## System Requirements

- **GPU:** A100 or RTX 4090
- **Storage:** 100-300 GB
- **RAM:** Minimum 16 GB
- **Software:** Jupyter Notebook

---

## Step-by-Step Implementation

### Steps 1-5: NodeShift Setup
Create a GPU node on NodeShift with RTX 4090 configuration, 100GB storage, and Jupyter Notebook image.

### Step 6: SSH Connection
Connect to the active compute node via SSH to access the Jupyter environment.

### Step 7: Ollama Installation

**Terminal Commands:**

```bash
curl -fsSL https://ollama.com/install.sh | sh
sudo apt install pciutils lshw
ollama serve
ollama pull llama3.3
```

---

## Step 8: Multi-Agent System Code

### Initial Setup

```python
!pip install git+https://github.com/openai/swarm.git --quiet
!pip install ollama openai --quiet

import ollama
from openai import OpenAI

model = "llama3.3"

ollama_client = OpenAI(
    base_url = "http://localhost:11434/v1",
    api_key = "ollama"
)
```

### Agent Definition

```python
from swarm import Swarm, Agent

client = Swarm(ollama_client)

def escalate_to_tech_support():
    return tech_support_agent

# Sales Agent
sales_agent = Agent(
    name="Sales Agent",
    model=model,
    instructions="You only handle inquiries related to product pricing and offers.",
    functions=[escalate_to_tech_support],
)

# Technical Support Agent
tech_support_agent = Agent(
    name="Tech Support Agent",
    model=model,
    instructions="You only handle technical issues related to product troubleshooting.",
)

# Test conversation
response = client.run(
    agent=sales_agent,
    messages=[{"role": "user", "content": "I need some help from the Tech support. Are you the tech support agent?"}],
)

print(response.messages[-1]["content"])
```

---

## How It Works

The system demonstrates agent handoff: when a user queries the Sales Agent about technical support, that agent properly transfers the conversation to the Tech Support Agent, proving inter-agent collaboration.

---

## Key Takeaways

- Multi-agent systems enable specialized agents to collaborate on complex tasks
- Ollama allows running capable local models without external API dependencies
- NodeShift provides affordable, accessible GPU infrastructure for AI workloads
- Agent handoff functionality creates seamless user experiences across agent specialties

---

## Resources

- [NodeShift Website](https://nodeshift.com)
- [NodeShift Documentation](https://docs.nodeshift.com)
- [NodeShift Discord Community](https://discord.gg/4dHNxnW7p7)
