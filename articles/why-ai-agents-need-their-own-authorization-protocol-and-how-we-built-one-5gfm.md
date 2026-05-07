---
title: "Why AI Agents Need Their Own Authorization Protocol (and how we built one)"
url: "https://dev.to/sanjeev_kumar_1755fc90023/why-ai-agents-need-their-own-authorization-protocol-and-how-we-built-one-5gfm"
author: "Sanjeev Kumar"
category: "ai-agent-authentication-authorization"
---

# Why AI Agents Need Their Own Authorization Protocol

**Author:** Sanjeev Kumar
**Published:** March 1, 2026

## Overview
Grantex: purpose-built authorization protocol for AI agents addressing four gaps in OAuth 2.0 -- agent identity, scope delegation chains, real-time revocation, and action-level audit trails.

## Key Concepts

### TypeScript SDK

```typescript
import { Grantex } from '@grantex/sdk';

const gx = new Grantex({ apiKey: process.env.GRANTEX_API_KEY });

const agent = await gx.agents.register({
  name: 'travel-booking-agent',
  description: 'Books flights and hotels for users',
  scopes: ['flights:book', 'hotels:search'],
});

const auth = await gx.authorize({
  agentId: agent.id,
  userId: 'user_alice',
  scopes: ['flights:book', 'hotels:search'],
  callbackUrl: 'https://app.example.com/callback',
});

const token = await gx.tokens.exchange({
  code: callbackCode,
  agentId: agent.id,
});

const result = await gx.tokens.verify(token.grantToken);

await gx.audit.log({
  agentId: agent.id,
  grantId: token.grantId,
  action: 'flight.booked',
  status: 'success',
  metadata: { airline: 'Air India', amount: 420 },
});
```

### Python SDK

```python
from grantex import Grantex, ExchangeTokenParams

client = Grantex(api_key=os.environ["GRANTEX_API_KEY"])

agent = client.agents.register(
    name="travel-booking-agent",
    scopes=["flights:book", "hotels:search"],
)

auth = client.authorize(
    agent_id=agent.id,
    user_id="user_alice",
    scopes=["flights:book", "hotels:search"],
)
```

### Delegation Chain

```
Root user grants: [files:read, files:write, email:send]
  +- Parent agent:  [files:read, files:write]  (delegationDepth: 0)
       +- Child agent:  [files:read]            (delegationDepth: 1)
```

### Installation

```bash
npm install @grantex/sdk        # TypeScript
pip install grantex             # Python
go get github.com/mishrasanjeev/grantex-go  # Go
```

8 framework integrations: LangChain, AutoGen, CrewAI, Vercel AI, OpenAI Agents SDK, Google ADK, Claude Desktop MCP, Express.js/FastAPI.
