---
title: "AWS re:Invent 2025 - Autonomous Web3 agents on AWS (DAT457)"
url: "https://dev.to/kazuya_dev/aws-reinvent-2025-autonomous-web3-agents-on-aws-dat457-3da"
author: "Kazuya"
category: "web3-blockchain-agents"
---

# AWS re:Invent 2025 - Autonomous Web3 agents on AWS (DAT457)
**Author:** Kazuya
**Published:** December 8, 2025

## Overview
Demonstrates building Web3 agents using Amazon Bedrock AgentCore and Strands Agents SDK with blockchain data access, long-term memory, and agent-to-agent communication capabilities.

## Key Concepts

### Memory Implementation

```python
from bedrock_agent_core.memory import MemoryClient
from memory import LongTermMemoryHooks

memory_client = MemoryClient(memory_id="your-memory-id")
hooks_provider = LongTermMemoryHooks(memory_client)
```

### Browser Integration for Market Data

```python
from bedrock_agent_core.tools import BrowserClient

async def get_coin_data(coin_name: str) -> str:
    browser_client = BrowserClient(region=AWS_REGION)
    session = browser_client.create_session()
    return extracted_market_data
```

### Agent-to-Agent Communication

```python
import boto3

bedrock_client = boto3.client('bedrock-agent-runtime')

def invoke_crypto_agent(prompt: str) -> str:
    response = bedrock_client.invoke_agent(
        agentId='AGENT_ID',
        agentAliasId='ALIAS_ID',
        inputText=prompt,
        sessionId='session-123'
    )
    return response['output']
```

### AWS KMS for Ethereum Wallet Management

```python
from eth_account import Account
import hashlib

def calc_eth_address(public_key_bytes):
    eth_address = '0x' + hashlib.sha3_256(
        public_key_bytes
    ).hexdigest()[-40:]
    return Account.to_checksum_address(eth_address)
```

### Docker Deployment

```dockerfile
FROM python:3.11-slim
COPY requirements.txt .
RUN pip install -r requirements.txt
ENV AWS_REGION=us-east-1
ENV MEMORY_ID=your-memory-id
ENTRYPOINT ["python", "-m", "strands_agent_streaming_memory"]
```

### Key Takeaway
Session isolation creates micro VMs with isolated compute, memory, and file systems for each agent invocation -- critical for protecting sensitive blockchain data.
