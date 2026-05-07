---
title: "Building Scalable AI Agent Systems: Three Evolutions"
url: "https://dev.to/web3nomad/building-scalable-ai-agent-systems-three-evolutions-3ahe"
author: "web3nomad.eth"
category: "immutable-arch-rust-flink"
---
# Building Scalable AI Agent Systems: Three Evolutions
**Author:** web3nomad.eth  **Published:** January 11, 2026

## Overview
How atypica.AI evolved through three iterations: message-driven architecture (conversation as source of truth), unified execution with intent clarification, and persistent markdown memory. Deleted 1,211 lines of duplicated code, cut development time from 2-3 days to 2-3 hours, reduced repetitive questions with ~$0.007/conversation overhead.

## Key Concepts

**Evolution 1: Message-Driven Architecture (v2.2.0)**
Messages are the single source of truth. Removed five specialized save tools. Unified tool output format:
```typescript
interface ResearchToolResult {
  plainText: string;  // Human-readable summary
  [key: string]: any; // Optional structured data
}
```

**Evolution 2: Intent Clarification + Unified Execution (v2.3.0)**
Single baseAgentRequest executor through configuration:
```typescript
interface AgentRequestConfig<TOOLS extends ToolSet> {
  model: LLMModelName;
  systemPrompt: string;
  tools: TOOLS;
  specialHandlers?: {
    customPrepareStep?: (options) => ({ messages, activeTools? });
    customOnStepFinish?: (step, context) => Promise<void>;
  };
}
```

**Evolution 3: Persistent Memory (v2.3.0)**
Two-tier memory — Core Memory (Markdown) + Working Memory (JSON):
```typescript
model Memory {
  userId  Int?
  version Int
  core    String @db.Text    // Markdown format
  working Json                // JSON array of new info
}
```

Memory injection at session start:
```typescript
const memory = await loadUserMemory(userId);
if (memory?.core) {
  modelMessages = [
    {
      role: 'user',
      content: `<UserMemory>\n${memory.core}\n</UserMemory>`
    },
    ...modelMessages
  ];
}
```

Why Markdown over Vector DB: Context windows large enough (200K tokens), simple and transparent, avoids embedding inconsistencies.

Design Principles: Messages as Source of Truth, Configuration over Code, AI as State Manager, Simple+Transparent+Controllable.
