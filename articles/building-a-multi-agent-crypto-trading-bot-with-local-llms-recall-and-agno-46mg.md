---
title: "Building a Multi-Agent Crypto Trading Bot with Local LLMs, Recall, and Agno"
url: "https://dev.to/harishkotra/building-a-multi-agent-crypto-trading-bot-with-local-llms-recall-and-agno-46mg"
author: "Harish Kotra"
category: "web3-blockchain-agents"
---

# Building a Multi-Agent Crypto Trading Bot with Local LLMs, Recall, and Agno
**Author:** Harish Kotra
**Published:** October 14, 2025

## Overview
Two-agent autonomous trading system using Ollama for local LLM reasoning with Agno framework and Recall Network's paper trading API.

## Key Concepts

### Agent Architecture
1. Analyst Agent: Synthesizes live market data + news for BUY/SELL/HOLD decisions
2. Trader Agent: Executes trades on Recall Network sandbox after safety checks

### News Gathering

```python
search_results_json = self.search_tool.duckduckgo_news(
    query=f"latest cryptocurrency news {topic}",
    max_results=4
)
```

### Portfolio Safety

```python
def _get_portfolio(self):
    endpoint = f"{self.base_url}/api/agent/balances"
    r = requests.get(endpoint, headers={"Authorization": f"Bearer {self.api_key}"})
```

### Stack
- Ollama with GPT-OSS-20B for local reasoning
- Python + Agno framework
- DuckDuckGo news tool
- Recall Network paper trading
- Continuous 5-minute cycles, no cloud costs
