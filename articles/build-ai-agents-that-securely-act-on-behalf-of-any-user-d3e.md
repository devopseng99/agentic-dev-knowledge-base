---
title: "Build AI Agents That Securely Act on Behalf of Any User"
url: "https://dev.to/scalekit-inc/build-ai-agents-that-securely-act-on-behalf-of-any-user-d3e"
author: "Harsh"
category: "ai-agent-authentication-authorization"
---

# Build AI Agents That Securely Act on Behalf of Any User

**Author:** Harsh (Scalekit Inc)
**Published:** May 4, 2026

## Overview
AgentKit by Scalekit: access orchestration for AI agents with delegated auth, scoped access, built-in audit logs, and 40+ connectors.

## Key Concepts

### Problems with Traditional Auth for Agents

| Problem | Explanation |
|---------|-------------|
| Context blindness | Agent can't identify which user it serves |
| Scope creep | Agents request excessive permissions |
| Audit nightmare | Can't distinguish agent vs human actions |
| Short-lived sessions | Agents need auto-expiring tokens |

### SDK Setup

```python
from scalekit import ScalekitClient
import os

sc = ScalekitClient(
    env_url="https://devagentlabs.scalekit.dev",
    client_id="skc_123451560272397061",
    client_secret=os.environ.get("SCALEKIT_CLIENT_SECRET")
)
print("SDK initialized!")
```

### Security

```bash
export SCALEKIT_CLIENT_SECRET="your_secret_here"
```

Never hardcode secrets. Use environment variables.

### Connected Accounts
1. Create Gmail connector with OAuth + readonly scope
2. Link user to connector
3. Complete OAuth flow
4. Agent can now read emails with scoped, auditable access

### Agent Capabilities
- List connected accounts per user
- Check authorization before API calls
- Fetch data through connectors without raw OAuth tokens
- Automatic token refresh and scope validation
