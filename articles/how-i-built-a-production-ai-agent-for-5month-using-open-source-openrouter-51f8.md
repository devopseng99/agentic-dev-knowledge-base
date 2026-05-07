---
title: "How I Built a Production AI Agent for $5/month Using Open Source + OpenRouter"
url: "https://dev.to/ramosai/how-i-built-a-production-ai-agent-for-5month-using-open-source-openrouter-51f8"
author: "RamosAI"
category: "full-code-examples"
---

# How I Built a Production AI Agent for $5/month Using Open Source + OpenRouter
**Author:** RamosAI
**Published:** April 17, 2026

## Overview
Building production-grade AI agents affordably by combining open source tools with OpenRouter API aggregator. Mistral 7B at $0.00014 per 1K input tokens vs GPT-4 pricing.

## Key Concepts

### Environment Setup

```python
python -m venv ai_agent_env
source ai_agent_env/bin/activate
pip install langchain openai python-dotenv requests
pip install langchain-community
```

### Environment Variables

```
OPENROUTER_API_KEY=your_key_here
OPENROUTER_BASE_URL=https://openrouter.ai/api/v1
```

### Agent Implementation

```python
import os
from langchain.chat_models import ChatOpenAI
from langchain.agents import AgentExecutor, create_react_agent
from langchain.tools import tool
from langchain import hub
from dotenv import load_dotenv

load_dotenv()

llm = ChatOpenAI(
    model_name="mistralai/mistral-7b-instruct",
    openai_api_base="https://openrouter.ai/api/v1",
    openai_api_key=os.getenv("OPENROUTER_API_KEY"),
    temperature=0.7,
)

@tool
def get_weather(location: str) -> str:
    """Get current weather for a location"""
    return f"Weather in {location}: Sunny, 72F"

@tool
def search_documentation(query: str) -> str:
    """Search your product documentation"""
    return f"Found documentation about: {query}"

tools = [get_weather, search_documentation]
prompt = hub.pull("hwchase17/react")
agent = create_react_agent(llm, tools, prompt)
agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)

response = agent_executor.invoke({
    "input": "What's the weather in San Francisco and find me docs on authentication?"
})
print(response["output"])
```

### Cost Monitoring

```python
import json
import time
from datetime import datetime
from typing import Any, Dict

class AgentMonitor:
    def __init__(self, log_file: str = "agent_logs.jsonl"):
        self.log_file = log_file

    def log_call(self, input_text, output_text, model, tokens_used, cost, execution_time):
        log_entry = {
            "timestamp": datetime.utcnow().isoformat(),
            "input": input_text,
            "output": output_text,
            "model": model,
            "tokens_used": tokens_used,
            "cost_usd": cost,
            "execution_time_seconds": execution_time,
        }
        with open(self.log_file, "a") as f:
            f.write(json.dumps(log_entry) + "\n")

    def get_daily_cost(self, date: str = None) -> float:
        if date is None:
            date = datetime.utcnow().strftime("%Y-%m-%d")
        total = 0.0
        with open(self.log_file, "r") as f:
            for line in f:
                entry = json.loads(line)
                if entry["timestamp"].startswith(date):
                    total += entry["cost_usd"]
        return total
```
