---
title: "How to Build an AI Trading Agent with Swap API"
url: "https://dev.to/moonsoon69/how-to-build-an-ai-trading-agent-with-swap-api-2jgi"
author: "Moon Soon"
category: "web3-blockchain-agents"
---

# How to Build an AI Trading Agent with Swap API
**Author:** Moon Soon
**Published:** April 3, 2026

## Overview
Build an LLM-powered trading agent accepting natural language instructions to retrieve real-time swap quotes from swapapi.dev across 46 EVM chains, with executable transaction data -- no API keys needed.

## Key Concepts

### Define the Swap Tool

```python
swap_tool = {
    "type": "function",
    "function": {
        "name": "get_swap_quote",
        "parameters": {
            "type": "object",
            "properties": {
                "chain_id": {"type": "integer", "description": "EVM chain ID"},
                "token_in": {"type": "string"},
                "token_out": {"type": "string"},
                "amount": {"type": "string", "description": "Amount in smallest unit (wei)"},
                "sender": {"type": "string"}
            },
            "required": ["chain_id", "token_in", "token_out", "amount", "sender"]
        }
    }
}
```

### Swap Function

```python
import requests

def get_swap_quote(chain_id, token_in, token_out, amount, sender):
    url = f"https://api.swapapi.dev/v1/swap/{chain_id}"
    params = {"tokenIn": token_in, "tokenOut": token_out, "amount": amount, "sender": sender}
    resp = requests.get(url, params=params, timeout=15)
    data = resp.json()
    if not data.get("success"):
        return {"error": data.get("error", {}).get("message", "Unknown error")}
    return {
        "status": data["data"]["status"],
        "token_in": data["data"]["tokenFrom"]["symbol"],
        "expected_out": data["data"]["expectedAmountOut"],
        "price_impact": data["data"]["priceImpact"],
    }
```

### Agent Loop

```python
import openai, json

client = openai.OpenAI()

def run_agent(user_message, wallet_address):
    messages = [
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": user_message},
    ]
    response = client.chat.completions.create(model="gpt-4o", messages=messages, tools=TOOLS)
    msg = response.choices[0].message
    if msg.tool_calls:
        for call in msg.tool_calls:
            args = json.loads(call.function.arguments)
            args["sender"] = wallet_address
            result = get_swap_quote(**args)
            messages.append(msg)
            messages.append({"role": "tool", "tool_call_id": call.id, "content": json.dumps(result)})
        final = client.chat.completions.create(model="gpt-4o", messages=messages, tools=TOOLS)
        return final.choices[0].message.content
    return msg.content

print(run_agent("Swap 0.5 ETH to USDC on Arbitrum", "0xYourWallet"))
```

### Safety Checks

```python
def validate_quote(quote):
    if quote.get("error"):
        return False, f"API error: {quote['error']}"
    if quote["status"] == "NoRoute":
        return False, "No route found"
    impact = abs(quote.get("price_impact", 0))
    if impact > 0.05:
        return False, f"Price impact too high: {impact:.2%}"
    return True, "Quote validated"
```

### Stats
AI trading agents executed over $44 billion in notional volume across prediction and DeFi markets in 2025. Supports 46 EVM chains including Ethereum, Arbitrum, Base, Optimism, Polygon, BSC, Avalanche.
