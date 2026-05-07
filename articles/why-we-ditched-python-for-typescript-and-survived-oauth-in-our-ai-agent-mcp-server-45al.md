---
title: "Why We Ditched Python for TypeScript (and Survived OAuth) in Our AI Agent MCP Server"
url: https://dev.to/jneums/why-we-ditched-python-for-typescript-and-survived-oauth-in-our-ai-agent-mcp-server-45al
author: Jesse Neumann
category: mcp-agents
---

# Why We Ditched Python for TypeScript (and Survived OAuth) in Our AI Agent MCP Server

**Author:** Jesse Neumann
**Date Published:** May 22, 2025
**Tags:** #oauth #mcp #ai #portalone

---

## Overview

Jesse Neumann shares three critical lessons learned while building a production-ready Model Context Protocol (MCP) server for Portal One, an AI Agent Command Center. The post highlights architectural decisions and implementation challenges encountered during backend development.

---

## Key Lessons

### 1. OAuth 2.0: No Shortcuts in Security

The author initially considered simpler authorization methods like API keys or JWTs but recognized the need for robust security given the complexity of permissions and multi-tenancy requirements.

**Why OAuth 2.0 was chosen:**
- Industry standard with broad support
- Enables granular permission scopes
- Provides auditability and future-proofing
- Required by the MCP Specification

**Key insight:** "Implementing OAuth correctly is hard. Expect lots of trial and error with flows, token introspection, and permission logic."

### 2. Python to TypeScript Migration

Initial prototyping used Python for its AI-friendly features, but production revealed significant limitations:

- Type safety gaps complicated refactoring
- Async/concurrency model misalignment
- Desired unified language across backend and integrations

**TypeScript benefits realized:**
- Strong typing reduced runtime bugs
- Native async/await support
- Extensive ecosystem
- Official MCP TypeScript SDK support with `authInfo` context and OAuth proxy capabilities

**Takeaway:** "Rewrites are tough, but sometimes necessary for long-term velocity. However, the second time creating something usually results in a better and more thought out implementation."

### 3. Zod for Data Validation

The unpredictable nature of agent payloads required robust validation. Zod provided:

- Declarative, type-safe schemas
- Automatic TypeScript type inference
- Developer-friendly error messages
- Integration with MCP TypeScript SDK

---

## Code Example: Authorization Handler

```typescript
export function withWorkspaceAccess<T extends z.ZodTypeAny>(
  db: Firestore,
  inputSchema: T,
  handler: (
    args: z.infer<T>,
    req: RequestHandlerExtra<ServerRequest, ServerNotification>,
    userId: string,
  ) => Promise<CallToolResult>,
) {
  return async (
    args: z.infer<T>,
    req: RequestHandlerExtra<ServerRequest, ServerNotification>,
  ) => {
    const userId = req.authInfo?.extra?.user_id as string;
    if (!userId) throw new Error('No user ID found in token.');
    const hasAccess = await checkWorkspaceAccess(db, userId, args.workspace_id);
    if (!hasAccess)
      throw new Error('You do not have access to this workspace.');
    return handler(args, req, userId);
  };
}
```

This demonstrates multi-tenancy and authorization using OAuth token context.

---

## Zod Schema Example

```typescript
import { z } from 'zod';

const AgentEvent = z.object({
  agentId: z.string().uuid(),
  tool: z.string(),
  payload: z.record(z.unknown()),
  timestamp: z.coerce.date(),
});

type AgentEvent = z.infer<typeof AgentEvent>;

const parsed = AgentEvent.parse(incomingEvent);
```

---

## Resources

- Full code examples available on [GitHub](https://github.com/portal-labs-infrastructure/mcp-server-blog)
- Extended deep dive available on the [Portal One blog](https://portal.one/blog/mcp-server-with-oauth-typescript/)
