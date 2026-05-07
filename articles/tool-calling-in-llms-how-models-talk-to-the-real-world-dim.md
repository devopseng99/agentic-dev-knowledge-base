---
title: "Tool Calling in LLMs: How Models Talk to the Real World"
url: "https://dev.to/eshaiju/tool-calling-in-llms-how-models-talk-to-the-real-world-dim"
author: "Shaiju Edakulangara"
category: "tool calling LLM"
---

# Tool Calling in LLMs: How Models Talk to the Real World

**Author:** Shaiju Edakulangara
**Published:** January 21, 2026

## Overview

Explains tool calling as the architectural mechanism bridging LLM reasoning and application capabilities. The model decides what to do; your app actually does it.

## Key Concepts

### Tool Call Response Format

```json
{
  "tool_calls": [
    {
      "id": "call_abc123",
      "type": "function",
      "function": {
        "name": "document_search",
        "arguments": "{\"query\": \"refund policy\"}"
      }
    }
  ]
}
```

### The Tool Calling Loop

1. User submits a question
2. Application sends conversation history plus tool definitions
3. Model responds with text or tool calls
4. Application executes tools
5. Results return to the model
6. Model continues reasoning, potentially triggering additional calls

### NodeLLM Implementation

```typescript
import { Tool, z, NodeLLM } from "@node-llm/core";

class DocumentSearch extends Tool {
  name = "document_search";
  description = "Searches knowledge base for relevant information";
  schema = z.object({ query: z.string() });

  async handler({ query }) {
    const docs = await db.documents.search(query).limit(3);
    return docs.map(doc => `${doc.title}: ${doc.content}`).join("\n\n");
  }
}

class SlackNotification extends Tool {
  name = "send_slack";
  description = "Sends a message to a Slack channel";
  schema = z.object({ message: z.string(), channel: z.string() });

  async handler({ message, channel }) {
    await slack.send(channel, message);
    return "Notification sent successfully";
  }
}

const chat = NodeLLM.chat("gpt-4o")
  .withTools([DocumentSearch, SlackNotification])
  .withInstructions("Search for context. If you find a security issue, notify Slack.");

const response = await chat.ask("What is our security policy?");
```

### Tool Description Quality

| Quality | Description | Result |
|---------|-------------|--------|
| Bad | "Get data" | Model guesses or ignores |
| Good | "Retrieves recent order history including status and delivery date" | Model applies correctly |

### Common Failure Modes

- **Looping:** Models repeatedly invoke tools; solve with `maxSteps` or recursion limits
- **Vague descriptions:** Primary cause of poor behavior
- **Logic in prompts:** Business logic should inhabit handlers, not descriptions
- **Stateless assumptions:** Models only know what's in current context window

### Tool Calling vs Agents

Tool calling is the underlying mechanism; agents are patterns built atop it. An agent implements a reasoning loop. Tool calling enables agents, but agents are not required to use tool calling.
