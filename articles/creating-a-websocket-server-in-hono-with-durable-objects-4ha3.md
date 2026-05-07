---
title: "Creating a Websocket server in Hono with Durable Objects"
url: "https://dev.to/fiberplane/creating-a-websocket-server-in-hono-with-durable-objects-4ha3"
author: "Laurynas Keturakis"
category: "cloudflare-durable-objects"
---

# Creating a Websocket server in Hono with Durable Objects
**Author:** Laurynas Keturakis
**Published:** September 2, 2024

## Overview
Building a webhook inspection service using Cloudflare Workers, Hono framework, and Durable Objects with WebSocket Hibernation API.

## Key Concepts

### Configuration
```toml
[durable_objects]
bindings = [
  { name = "WEBHOOK_RECEIVER", class_name = "WebhookReceiver" }
]
```

### Middleware Pattern
```typescript
app.use("*", async (c, next) => {
  const id = c.env.WEBHOOK_RECEIVER.idFromName("default");
  const stub = c.env.WEBHOOK_RECEIVER.get(id);
  c.set("receiver", stub);
  await next();
});
```

### Request Broadcasting
```typescript
app.all("/receiver-listen/*", async (c) => {
  const method = c.req.method;
  const path = c.req.path;
  const body = await c.req.text();
  const received = { method, path, body };
  const stub = c.get("receiver");
  await stub.broadcast(JSON.stringify(received));
  return c.text("OK");
});
```

### WebSocket Hibernation API
Uses `.acceptWebSocket()` instead of standard `.accept()`, allowing DOs to hibernate during inactivity while maintaining connections. Cloudflare handles ping-pong heartbeat logic automatically.
