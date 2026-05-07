---
title: "Building Your First AI Agent in Node.js: A Deep Dive"
url: https://dev.to/eshaiju/building-your-first-ai-agent-in-nodejs-a-deep-dive-1ei9
author: Shaiju Edakulangara
category: ai-agents-nodejs
---

# Building Your First AI Agent in Node.js: A Deep Dive

**Author:** Shaiju Edakulangara
**Published:** January 20, 2026 (Updated January 22, 2026)
**Tags:** #nodellm #node #llm #agents

---

## Article Summary

This technical guide demystifies AI agents by breaking them into three core components and demonstrating practical implementation using NodeLLM.

---

## Key Concepts

### The Three Components of an AI Agent

The author identifies agents as having:

1. **Brain (LLM)**: "The reasoning engine. It decides _what_ to do next based on the current context."
2. **Hands (Tools)**: Functions that enable real-world interaction like web searches or database queries
3. **Loop (Orchestrator)**: "The code that connects the brain to the hands"

The critical insight: "An LLM cannot _actually_ do anything. It can only generate text."

### The Execution Loop

The agent operates through an iterative process:
- Send user request + tool descriptions to LLM
- LLM generates tool_calls if needed
- Orchestrator executes those tools
- Results feed back to LLM
- Process repeats until LLM provides final answer

---

## Code Examples

### Tool Definition

```typescript
import { createLLM, Tool, z } from "@node-llm/core";
import os from "node:os";
import fs from "node:fs/promises";

class SystemInfoTool extends Tool {
  name = "get_system_info";
  description = "Returns CPU and Memory usage of the current machine.";
  schema = z.object({});

  async execute() {
    const freeMem = Math.round(os.freemem() / 1024 / 1024);
    const totalMem = Math.round(os.totalmem() / 1024 / 1024);
    return {
      os: os.type(),
      architecture: os.arch(),
      memory: `${freeMem}MB free / ${totalMem}MB total`,
      cpus: os.cpus().length
    };
  }
}

class FileInspectorTool extends Tool {
  name = "list_files";
  description = "Lists files in the current directory to understand project structure.";
  schema = z.object({
    dir: z.string().default(".").describe("Directory to list")
  });

  async execute({ dir }) {
    try {
      const files = await fs.readdir(dir);
      return { directory: dir, files: files.slice(0, 10) };
    } catch (err) {
      return { error: `Could not read directory: ${err.message}` };
    }
  }
}
```

### Agent Execution

```typescript
async function main() {
  const llm = createLLM({ provider: "openai" });

  const chat = llm
    .chat("gpt-4o")
    .system("You are a system administrator agent. Help the user understand their environment.")
    .withTools([SystemInfoTool, FileInspectorTool]);

  const response = await chat.ask(
    "How much memory do I have left, and what's in my current folder?"
  );

  console.log("Agent Response:", response.content);
}

main();
```

### Safety Features

**Loop Protection:**
```typescript
const llm = createLLM({ maxToolCalls: 10 });
```

**Human-in-the-Loop:**
```typescript
chat
  .withToolExecution("confirm")
  .onConfirmToolCall(async (call) => {
    console.log(`Agent wants to call: ${call.function.name}`);
    return await askUserForApproval();
  });
```

---

## Installation

```bash
npm install @node-llm/core
```

Run the example:
```bash
export OPENAI_API_KEY='your_key_here'
npx tsx agent.ts
```

---

## When NOT to Use Agents

The author advises against agents when:
- Tasks are single-step
- External tools aren't necessary
- Determinism is required

"The best code is the code you didn't have to write. Use agents for dynamic orchestration, not static business logic."

---

## Key Takeaways

- Agents emerge from loops interpreting LLM outputs, not magic
- NodeLLM eliminates boilerplate around schema generation, loop management, and error handling
- Practical implementation requires minimal code when using proper frameworks
- Understanding the mental model matters more than implementation details
