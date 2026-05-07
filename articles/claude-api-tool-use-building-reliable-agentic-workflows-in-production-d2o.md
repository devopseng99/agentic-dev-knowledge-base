---
title: "Claude API Tool Use: Building Reliable Agentic Workflows in Production"
url: https://dev.to/whoffagents/claude-api-tool-use-building-reliable-agentic-workflows-in-production-d2o
author: Atlas Whoff
category: anthropic-claude
---

# Claude API Tool Use: Building Reliable Agentic Workflows in Production

**Author:** Atlas Whoff
**Published:** April 15, 2026
**Modified:** April 18, 2026

---

## Overview

This article explores practical patterns for implementing Claude's tool use (function calling) API in production systems. The author emphasizes that robust tool implementation separates functional chatbots from reliable autonomous agents.

---

## How Tool Use Works

Developers define tools as JSON schemas. Claude decides when to invoke them and with what parameters. The application executes the function and returns results, which Claude incorporates into subsequent reasoning.

**Code Example:**
```typescript
import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic();
const tools: Anthropic.Tool[] = [
  {
    name: 'get_user',
    description: 'Retrieve a user by their ID or email address',
    input_schema: {
      type: 'object' as const,
      properties: {
        identifier: {
          type: 'string',
          description: 'User ID (uuid) or email address',
        },
        identifier_type: {
          type: 'string',
          enum: ['id', 'email'],
          description: 'Whether the identifier is an ID or email',
        },
      },
      required: ['identifier', 'identifier_type'],
    },
  },
];
```

## The Complete Agentic Loop

Tool use requires a looping pattern rather than single API calls. The agent continues until Claude returns `stop_reason: 'end_turn'`, handling tool invocations in between.

**Core Loop Pattern:**
```typescript
async function runAgent(userMessage: string): Promise<string> {
  const messages: Anthropic.MessageParam[] = [
    { role: 'user', content: userMessage },
  ];

  while (true) {
    const response = await client.messages.create({
      model: 'claude-opus-4-6',
      max_tokens: 4096,
      tools,
      messages,
    });

    messages.push({ role: 'assistant', content: response.content });

    if (response.stop_reason === 'end_turn') {
      const textBlock = response.content.find(
        (b) => b.type === 'text'
      );
      return textBlock?.text ?? '';
    }

    if (response.stop_reason === 'tool_use') {
      const toolResults: Anthropic.ToolResultBlockParam[] = [];

      for (const block of response.content) {
        if (block.type !== 'tool_use') continue;

        const result = await executeTool(block.name, block.input);

        toolResults.push({
          type: 'tool_result',
          tool_use_id: block.id,
          content: JSON.stringify(result),
        });
      }

      messages.push({ role: 'user', content: toolResults });
    }
  }
}
```

## Executing Tools Safely

Implementation must include error handling and type validation at the execution layer.

**Safe Execution Pattern:**
```typescript
async function executeTool(
  name: string,
  input: Record<string, unknown>
): Promise<unknown> {
  console.log(`[tool] ${name}`, input);

  switch (name) {
    case 'get_user':
      return getUser(input as {
        identifier: string;
        identifier_type: 'id' | 'email';
      });
    case 'update_subscription':
      return updateSubscription(input as UpdateSubscriptionInput);
    case 'send_email':
      return sendEmail(input as SendEmailInput);
    default:
      return { error: `Unknown tool: ${name}` };
  }
}

async function getUser({
  identifier,
  identifier_type,
}: {
  identifier: string;
  identifier_type: 'id' | 'email';
}) {
  const user =
    identifier_type === 'email'
      ? await db.query.users.findFirst({
          where: eq(users.email, identifier),
        })
      : await db.query.users.findFirst({
          where: eq(users.id, identifier),
        });

  if (!user) return { error: 'User not found' };

  const { passwordHash, ...safeUser } = user;
  return safeUser;
}
```

## Parallel Tool Calls

Claude can request multiple tool invocations in a single response. Use `Promise.allSettled()` rather than `Promise.all()` to prevent one failure from cascading.

**Parallel Execution:**
```typescript
if (response.stop_reason === 'tool_use') {
  const toolUseBlocks = response.content.filter(
    (b): b is Anthropic.ToolUseBlock => b.type === 'tool_use'
  );

  const results = await Promise.allSettled(
    toolUseBlocks.map((block) =>
      executeTool(block.name, block.input)
    )
  );

  const toolResults: Anthropic.ToolResultBlockParam[] =
    toolUseBlocks.map((block, i) => {
      const result = results[i];
      return {
        type: 'tool_result' as const,
        tool_use_id: block.id,
        content:
          result.status === 'fulfilled'
            ? JSON.stringify(result.value)
            : JSON.stringify({
                error:
                  result.reason?.message ?? 'Tool failed',
              }),
        is_error: result.status === 'rejected',
      };
    });

  messages.push({ role: 'user', content: toolResults });
}
```

## Tool Definitions That Actually Work

Precise descriptions significantly impact Claude's accuracy. Include context about when *not* to use a tool and provide examples in field descriptions.

**Vague approach:**
```typescript
{
  name: 'update_user',
  description: 'Update a user',
  input_schema: {
    type: 'object',
    properties: {
      data: { type: 'object' },
    },
  },
}
```

**Effective approach:**
```typescript
{
  name: 'update_user_subscription',
  description:
    "Update a user's subscription plan. Use when the user needs to " +
    'upgrade, downgrade, or cancel. Do NOT use for payment method ' +
    'changes — use update_payment_method instead.',
  input_schema: {
    type: 'object',
    properties: {
      user_id: {
        type: 'string',
        description: 'UUID of the user to update',
      },
      plan: {
        type: 'string',
        enum: ['free', 'pro', 'enterprise'],
        description: 'New plan to switch the user to',
      },
      reason: {
        type: 'string',
        description:
          'Why the plan is being changed (for audit log). ' +
          'Example: "User requested downgrade via support ticket #1234"',
      },
    },
    required: ['user_id', 'plan', 'reason'],
  },
}
```

**Best Practices:**
- Name describes the *action*, not the object
- Descriptions explain what the tool should *not* be used for
- Field descriptions include examples
- Use `enum` when valid options are known

## Limiting Runaway Agents

Implement guards to prevent infinite loops and excessive token consumption.

**Safeguard Pattern:**
```typescript
async function runAgent(
  userMessage: string,
  options: { maxTurns?: number; maxTokens?: number } = {}
): Promise<string> {
  const { maxTurns = 10, maxTokens = 50_000 } = options;

  const messages: Anthropic.MessageParam[] = [
    { role: 'user', content: userMessage },
  ];

  let totalInputTokens = 0;
  let totalOutputTokens = 0;
  let turns = 0;

  while (turns < maxTurns) {
    turns++;

    const response = await client.messages.create({
      model: 'claude-opus-4-6',
      max_tokens: 4096,
      tools,
      messages,
    });

    totalInputTokens += response.usage.input_tokens;
    totalOutputTokens += response.usage.output_tokens;

    console.log(
      `[agent] Turn ${turns} | Tokens: ${totalInputTokens}in ${totalOutputTokens}out`
    );

    if (totalInputTokens + totalOutputTokens > maxTokens) {
      return 'Agent stopped: token budget exceeded. Please narrow your request.';
    }

    messages.push({
      role: 'assistant',
      content: response.content,
    });

    if (response.stop_reason === 'end_turn') {
      const textBlock = response.content.find(
        (b) => b.type === 'text'
      );
      return textBlock?.text ?? '';
    }

    // ... handle tool_use
  }

  return `Agent stopped after ${maxTurns} turns. Task may be too complex for a single run.`;
}
```

## Tool Results That Help Claude Reason Better

Return contextual results with inferred facts rather than raw database rows.

**Raw data:**
```typescript
return user; // { id: '...', email: '...', created_at: Date, ... }
```

**Contextual results:**
```typescript
return {
  user: {
    id: user.id,
    email: user.email,
    plan: user.plan,
    accountAge: `${daysSince(user.createdAt)} days`,
  },
  context: {
    isActive: user.status === 'active',
    hasPaymentMethod: !!user.stripeCustomerId,
    recentActivity: `Last login ${daysSince(
      user.lastLoginAt
    )} days ago`,
  },
};
```

## Error Handling That Doesn't Crash the Agent

Return errors as tool results rather than throwing exceptions. This allows Claude to see failures and route around them intelligently.

**Safe Error Handling:**
```typescript
async function executeToolSafe(
  name: string,
  input: Record<string, unknown>
): Promise<{
  result?: unknown;
  error?: string;
}> {
  try {
    const result = await executeTool(name, input);
    return { result };
  } catch (error) {
    const message =
      error instanceof Error
        ? error.message
        : String(error);
    console.error(`[tool error] ${name}:`, message);
    return {
      error: `Tool ${name} failed: ${message}`,
    };
  }
}
```

---

## Key Takeaways

1. **Separate tool execution errors from exceptions** -- Claude can reason about failures when they're visible as results
2. **Parallelize intelligently** -- Use `Promise.allSettled()` for independent tool calls
3. **Define tools precisely** -- Include negative cases and examples in descriptions
4. **Return contextual data** -- Preprocess results so Claude has the facts it needs to decide next steps
5. **Guard against runaway loops** -- Implement per-turn and cumulative token limits
6. **Tool definitions matter** -- Name describes the action; descriptions should clarify what NOT to use the tool for
