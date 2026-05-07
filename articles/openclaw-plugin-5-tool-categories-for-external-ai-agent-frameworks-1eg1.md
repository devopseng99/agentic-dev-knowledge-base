---
title: "OpenClaw Plugin: 5 Tool Categories for External AI Agent Frameworks"
url: "https://dev.to/walletguy/openclaw-plugin-5-tool-categories-for-external-ai-agent-frameworks-1eg1"
author: "Wallet Guy"
category: "web3-blockchain-agents"
---

# OpenClaw Plugin: 5 Tool Categories for External AI Agent Frameworks
**Author:** Wallet Guy
**Published:** April 15, 2026

## Overview
OpenClaw plugin from WAIaaS provides 5 tool categories (Wallet, Transfer, DeFi, NFT, Utility) enabling LangChain, CrewAI, and AutoGPT agents to interact with blockchains safely.

## Key Concepts

### LangChain Integration

```python
from langchain.tools import Tool
from waiaas.openclaw import OpenClawProvider

openclaw = OpenClawProvider(
    base_url="http://127.0.0.1:3100",
    session_token="wai_sess_eyJhbGciOiJIUzI1NiJ9..."
)
tools = openclaw.get_tools(categories=["wallet", "transfer", "defi"])
agent = initialize_agent(tools, llm, agent=AgentType.STRUCTURED_CHAT)
```

### CrewAI Integration

```python
from crewai import Agent, Tool
from waiaas.openclaw import OpenClawProvider

trading_agent = Agent(
    role="DeFi Trading Specialist",
    goal="Execute optimal trading strategies",
    tools=OpenClawProvider().get_tools(categories=["wallet", "defi"])
)
```

### JavaScript Integration

```javascript
const { OpenClawProvider } = require('@waiaas/openclaw-plugin');
const provider = new OpenClawProvider({
  baseUrl: 'http://127.0.0.1:3100',
  sessionToken: process.env.WAIAAS_SESSION_TOKEN
});
const walletTools = await provider.getTools(['wallet']);
```

### DeFi Yield Farmer Example

```python
positions = openclaw.call_tool("defi", "get_positions")
if aave_yield > current_yield * 1.1:
    openclaw.call_tool("defi", "withdraw", {"protocol": "compound", "amount": "1000"})
    openclaw.call_tool("defi", "deposit", {"protocol": "aave", "amount": "1000"})
```

### 5 Tool Categories
1. Wallet: Balance, address, transaction history
2. Transfer: Token sending, batch transfers, payments
3. DeFi: 15 protocols including Jupiter, Aave, Hyperliquid
4. NFT: ERC-721/1155 + Metaplex with metadata caching
5. Utility: Simulation, gas optimization, x402 payments
