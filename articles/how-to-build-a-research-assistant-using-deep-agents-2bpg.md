---
title: "How to Build a Research Assistant Using Deep Agents"
url: "https://dev.to/copilotkit/how-to-build-a-research-assistant-using-deep-agents-2bpg"
author: "Anmol Baranwal"
category: "deep-agents"
---

# How to Build a Research Assistant Using Deep Agents

**Author:** Anmol Baranwal
**Published:** February 20, 2026

## Overview

This comprehensive guide demonstrates building a research assistant powered by LangChain's Deep Agents framework, integrated with a Next.js frontend using CopilotKit for real-time UI synchronization.

## Key Topics Covered

1. What are Deep Agents?
2. Core Components and Architecture
3. Project Overview
4. Frontend Implementation
5. Backend Setup (FastAPI + Deep Agents)
6. Data Flow Between UI and Agent

## What Are Deep Agents?

Deep Agents represent an evolution beyond simple "LLM in a loop" patterns. Rather than basic tool-calling, they implement structured multi-step reasoning with explicit planning, context management, and task delegation.

Popular implementations like Claude Code and OpenAI's Deep Research follow a common pattern: plan first, externalize working context via files, and delegate isolated work to sub-agents.

### Mental Model

```
User goal -> Deep Agent (LangGraph StateGraph)
|- Plan: write_todos -> updates state
|- Delegate: task(...) -> runs subagent
|- Context: filesystem operations
|
Final answer
```

The framework handles planning, file management, and subagent spawning built-in through middleware rather than requiring custom orchestration.

## Core Components

### 1. Planning Tools
Built-in capability for agents to break workflows into explicit steps without custom planning tools.

### 2. Subagents
Isolated execution loops with independent prompts, tools, and context allowing delegation of focused tasks.

### 3. Tools
Functions enabling agent actions, including a `finalize()` tool signaling completion.

### Middleware Implementation

Deep Agents inject capabilities through three middleware components:

- **To-do List Middleware**: Adds `write_todos` tool and planning instructions
- **Filesystem Middleware**: Provides file operations (`ls`, `read_file`, `write_file`, `edit_file`)
- **Subagent Middleware**: Adds `task` tool for delegating to sub-agents

## Project Architecture

### Directory Structure

```
src/ (Next.js frontend)
    app/
        page.tsx
        layout.tsx (CopilotKit provider)
        api/copilotkit/route.ts
    components/
        FileViewerModal.tsx
        WorkSpace.tsx
        ToolCard.tsx
    lib/types.ts
```

### Request Flow

```
User asks research question
  |
Next.js Frontend (CopilotChat + Workspace)
  |
CopilotKit Runtime -> LangGraphHttpAgent
  |
FastAPI Backend + Deep Agent
  |- write_todos (planning)
  |- write_file (filesystem)
  |- read_file (filesystem)
  |- research(query)
      |- internet_search (Tavily)
```

## Frontend Implementation

### Step 1: CopilotKit Setup

Install required packages:

```bash
npm install @copilotkit/react-core @copilotkit/react-ui @copilotkit/runtime
```

**Package purposes:**
- `react-core`: Provides hooks and context connecting UI to agent backend
- `react-ui`: Ready-made components like `<CopilotChat />`
- `runtime`: Server-side bridge to AG-UI compatible backends

### Step 2: Layout with Provider

```typescript
import { CopilotKit } from "@copilotkit/react-core";
import "@copilotkit/react-ui/styles.css";

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        <CopilotKit
          runtimeUrl="/api/copilotkit"
          agent="research_assistant"
        >
          {children}
        </CopilotKit>
      </body>
    </html>
  );
}
```

### Step 3: API Route (Next.js Proxy)

The `/api/copilotkit` route bridges frontend requests to the Deep Agents backend:

```typescript
import {
  CopilotRuntime,
  ExperimentalEmptyAdapter,
  copilotRuntimeNextJSAppRouterEndpoint,
} from "@copilotkit/runtime";
import { LangGraphHttpAgent } from "@copilotkit/runtime/langgraph";

const runtime = new CopilotRuntime({
  agents: {
    research_assistant: new LangGraphHttpAgent({
      url: process.env.LANGGRAPH_DEPLOYMENT_URL || "http://localhost:8123",
    }),
  },
});

export const POST = async (req) => {
  const { handleRequest } = copilotRuntimeNextJSAppRouterEndpoint({
    runtime,
    serviceAdapter: new ExperimentalEmptyAdapter(),
    endpoint: "/api/copilotkit",
  });
  return handleRequest(req);
};
```

### Step 4: State Types

Define shared contracts between agent tools and React state:

```typescript
export interface Todo {
  id: string;
  content: string;
  status: "pending" | "in_progress" | "completed";
}

export interface ResearchFile {
  path: string;
  content: string;
  createdAt: string;
}

export interface Source {
  url: string;
  title: string;
  content?: string;
  status: "found" | "scraped" | "failed";
}

export interface ResearchState {
  todos: Todo[];
  files: ResearchFile[];
  sources: Source[];
}
```

Rather than embedding raw tool JSON in chat, results route into dedicated state slots -- `write_todos` updates the todos array, `write_file` appends to files, etc.

### Step 5: Tool Card Component

Specialized components render known tools with icons and status indicators:

```typescript
"use client";

import { useState } from "react";
import {
  Pencil, ClipboardList, Search, Save, BookOpen, Check, ChevronDown
} from "lucide-react";

const TOOL_CONFIG = {
  write_todos: {
    icon: Pencil,
    getDisplayText: () => "Updating research plan...",
    getResultSummary: (result, args) => {
      const todos = (args as { todos?: unknown[] })?.todos;
      if (Array.isArray(todos)) {
        return `${todos.length} todo${todos.length !== 1 ? "s" : ""} updated`;
      }
      return null;
    },
  },
  research: {
    icon: Search,
    getDisplayText: (args) => `Researching: ${
      ((args.query as string) || "...").slice(0, 50)
    }${(args.query as string)?.length > 50 ? "..." : ""}`,
    getResultSummary: (result) => {
      if (result && typeof result === "object" && "sources" in result) {
        const { sources } = result as { sources: unknown[] };
        return `Found ${sources.length} source${sources.length !== 1 ? "s" : ""}`;
      }
      return "Research complete";
    },
  },
  write_file: {
    icon: Save,
    getDisplayText: (args) => {
      const path = args.path as string | undefined;
      const filename = path?.split("/").pop() || (args.filename as string | undefined);
      return `Writing: ${filename || "file"}`;
    },
    getResultSummary: (_result, args) => {
      const content = args.content as string | undefined;
      if (content) {
        const firstLine = content.split("\n")[0].slice(0, 50);
        return firstLine + (content.length > 50 ? "..." : "");
      }
      return "File written";
    },
  },
};

export function ToolCard({ name, status, args, result }) {
  const config = TOOL_CONFIG[name];
  if (config) {
    return (
      <SpecializedToolCard
        name={name}
        status={status}
        args={args}
        result={result}
        config={config}
      />
    );
  }
  return (
    <DefaultToolCard name={name} status={status} args={args} result={result} />
  );
}
```

## Backend (Python/FastAPI)

The backend runs Deep Agents via FastAPI, exposing an AG-UI compatible endpoint. Key elements include:

- **Research Agent**: Main orchestrator using `create_deep_agent()`
- **Subagents**: Isolated research tasks with Tavily internet search
- **Middleware**: Planning, filesystem, and subagent capabilities
- **CopilotKitMiddleware**: Streams state changes to frontend in real-time

```python
agent = create_deep_agent(
    model="openai:gpt-4o",
    tools=[internet_search],
    middleware=[CopilotKitMiddleware()],
    system_prompt="You are a helpful research assistant."
)
```

## Integration Pattern

CopilotKit's `CopilotKitMiddleware` keeps UI state synchronized with agent execution by:

1. Streaming agent events and state updates in real-time
2. Using AG-UI protocol under the hood
3. Exposing explicit state (todos, files, messages) for frontend synchronization

## Key Patterns

**State Externalization**: Large tool results offload to filesystem; summarization occurs only near token limits.

**Explicit Planning**: Agents break complex tasks into steps before execution.

**Tool Specialization**: Known tools render with custom UI; unknown tools fallback to expandable JSON.

**Middleware Composition**: Features stack via middleware rather than monolithic agent implementation.

## Resources

- **GitHub Repository**: [deep-agents-demo](https://github.com/CopilotKit/deep-agents-demo)
- **Deployed Demo**: Available for exploration
- **Official Docs**: CopilotKit Deep Agents integration guide
- **LangChain Docs**: Deep Agents overview and middleware details

## Takeaways

This implementation demonstrates practical patterns for building production-grade research assistants:

1. Deep Agents provide structured multi-step execution without custom runtimes
2. Explicit state management enables real-time UI synchronization
3. Middleware composition decouples concerns (planning, files, delegation)
4. Frontend-agent communication via streaming AG-UI protocol enables responsive interfaces
5. Typescript/Python bridges via HTTP agents provide clean separation of concerns
