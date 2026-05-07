---
title: "Your AI Agents Need an Accountability Layer"
url: "https://dev.to/slythefox/your-ai-agents-need-an-accountability-layer-267p"
author: "sly-the-fox"
category: "immutable-arch-rust-flink"
---
# Your AI Agents Need an Accountability Layer
**Author:** sly-the-fox  **Published:** March 19, 2026

## Overview
Standard logging is insufficient for AI agent accountability. An append-only, hash-chained attestation chain with Ed25519 signatures provides cryptographic immutability, attribution, and provable ordering. Required by EU AI Act for high-risk AI systems.

## Key Concepts
Three critical failures in traditional logging:
1. **Mutability**: Logs can be edited or deleted without cryptographic evidence
2. **Attribution**: Entries lack signatures proving which agent produced them
3. **Ordering**: Timestamps can be spoofed without hash chains

```python
import hashlib
import json
from datetime import datetime, timezone

def create_attestation(agent_id: str, action: str, data: dict, prev_hash: str) -> dict:
    """Create a hash-chained attestation record."""
    record = {
        "agent_id": agent_id,
        "action": action,
        "data": data,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "prev_hash": prev_hash,
    }
    content = json.dumps(record, sort_keys=True)
    record["hash"] = hashlib.sha256(content.encode()).hexdigest()
    return record

# Build a chain
chain = []
prev = "genesis"

chain.append(create_attestation("researcher", "fetch_data", {"sources": 3}, prev))
prev = chain[-1]["hash"]

chain.append(create_attestation("analyst", "process", {"rows": 1420}, prev))
prev = chain[-1]["hash"]

chain.append(create_attestation("writer", "generate_report", {"words": 2100}, prev))
```

```python
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey

def sign_attestation(record: dict, private_key: Ed25519PrivateKey) -> bytes:
    """Sign an attestation with the agent's private key."""
    content = json.dumps(record, sort_keys=True).encode()
    return private_key.sign(content)
```

Architecture:
```
Agent → Attestation (sign + hash-chain) → Storage
                                            ↓
                              Verification (any time, by anyone)
```

Library: `pip install sigil-notary` (Sigil with MCP integration)
