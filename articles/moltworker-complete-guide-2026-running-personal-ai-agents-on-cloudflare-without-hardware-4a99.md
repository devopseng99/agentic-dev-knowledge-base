---
title: "Moltworker Complete Guide 2026: Running Personal AI Agents on Cloudflare Without Hardware"
url: "https://dev.to/sienna/moltworker-complete-guide-2026-running-personal-ai-agents-on-cloudflare-without-hardware-4a99"
author: "Sienna"
category: "cloudflare-agents"
---

# Moltworker Complete Guide 2026: Running Personal AI Agents on Cloudflare Without Hardware
**Author:** Sienna
**Published:** January 30, 2026

## Overview
Comprehensive guide to Moltworker, an open-source middleware enabling deployment of AI agents on Cloudflare's infrastructure starting at $5/month instead of dedicated hardware.

## Key Concepts

### Deployment

```shell
git clone https://github.com/cloudflare/moltworker.git
cd moltworker
npm install
wrangler login
npx wrangler secret put ANTHROPIC_API_KEY
npm run deploy
```

### Core Architecture

```typescript
import { getSandbox } from '@cloudflare/sandbox';

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const sandbox = getSandbox(env.Sandbox, 'user-123');
    await sandbox.exec('moltbot-gateway start');
    return Response.json({ status: 'running' });
  }
};
```

### Request Routing

```javascript
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (url.pathname.startsWith('/_admin/')) return handleAdminUI(request, env);
    if (url.pathname.startsWith('/cdp/')) return handleCDPProxy(request, env);
    if (url.pathname === '/ws') return handleWebSocket(request, env);
    return handleControlUI(request, env);
  }
};
```

### Three-Layer Authentication
1. Gateway Token - Controls Control UI access
2. Device Pairing - Per-device authorization
3. Cloudflare Access - Protects admin interface
