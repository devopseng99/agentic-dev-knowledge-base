---
title: "Build a Research Assistant AI Agent with TypeScript (Part 2): Callbacks, State, and Memory"
url: https://dev.to/timonwa/build-a-research-assistant-ai-agent-with-typescript-part-2-callbacks-state-and-memory-1ed9
author: Timonwa Akintokun
category: ai-agents-typescript
---

# Build a Research Assistant AI Agent with TypeScript (Part 2): Callbacks, State, and Memory

**Author:** Timonwa Akintokun
**Date Published:** March 31, 2026
**Tags:** #ai #webdev #typescript #adkts

---

## Overview

This is Part 2 of a two-part series on building production-ready AI agents using ADK-TS (Agent Development Kit for TypeScript). The article builds upon Part 1's sequential agent pattern, adding critical features for observability, configurability, and persistence.

## Key Features Added

### 1. Agent Callbacks
Lifecycle hooks that trigger before and after agent execution. The framework provides:
- `beforeAgentCallback` - runs before agent processing
- `afterAgentCallback` - runs after agent completes

Both receive a `CallbackContext` containing agent name, session state, and invocation ID. Return values control execution flow: `undefined` allows normal execution, while a `Content` object skips the agent entirely.

### 2. Tool Callbacks
Framework-level rate limiting for individual tool calls:
- `beforeToolCallback` - fires before tool execution
- `afterToolCallback` - fires after tool completes

This prevents LLMs from ignoring instruction-based limits by blocking tool calls at the framework level rather than relying on prompts.

### 3. Session State Prefixes
State scoping through key prefixes:
- `app:` - application-wide configuration
- `user:` - per-user preferences
- `temp:` - ephemeral session data
- _(unprefixed)_ - session pipeline outputs

### 4. Memory Service
Persistent cross-session storage enabling:
- Session persistence after pipeline completion
- Keyword-based search across stored sessions
- Integration with configurable storage backends

---

## Implementation Steps

### Step 1: Callbacks File
```typescript
// src/callbacks.ts
import type { CallbackContext } from "@iqai/adk";

const STEP_LABELS: Record<string, string> = {
  researcher_agent: "Step 1/4: Researcher",
  analyst_agent: "Step 2/4: Analyst",
  recommender_agent: "Step 3/4: Recommender",
  writer_agent: "Step 4/4: Writer",
};

export const beforeAgentCallback = async (ctx: CallbackContext) => {
  const label = STEP_LABELS[ctx.agentName] ?? ctx.agentName;
  ctx.state[`temp:${ctx.agentName}_start`] = Date.now();
  console.log(`\n>>${label} - Starting...`);
  return undefined;
};

export const afterAgentCallback = async (ctx: CallbackContext) => {
  const label = STEP_LABELS[ctx.agentName] ?? ctx.agentName;
  const startTime = ctx.state[`temp:${ctx.agentName}_start`] as
    | number
    | undefined;
  const duration = startTime
    ? ((Date.now() - startTime) / 1000).toFixed(1)
    : "?";
  console.log(`<<${label} - Complete (${duration}s)`);
  return undefined;
};
```

### Step 2: Attach Callbacks to Agents
```typescript
// src/agents/analysis-report-agent/agent.ts
import { LlmAgent } from "@iqai/adk";
import { beforeAgentCallback, afterAgentCallback } from "../../callbacks";

export const getAnalysisAgent = () => {
  return new LlmAgent({
    name: "analyst_agent",
    description:
      "Analyzes raw research data to extract key insights and patterns",
    model: env.LLM_MODEL,
    outputKey: STATE_KEYS.ANALYSIS_REPORT,
    beforeAgentCallback,
    afterAgentCallback,
    disallowTransferToParent: true,
    disallowTransferToPeers: true,
    instruction: `...`,
  });
};
```

### Step 3: Tool Callbacks for Search Limits
```typescript
// src/agents/researcher-agent/agent.ts
const enforceSearchLimit = async (
  _tool: BaseTool,
  _args: Record<string, any>,
  toolContext: ToolContext
) => {
  const count = (toolContext.state["temp:search_count"] as number) || 0;

  if (count >= MAX_SEARCHES) {
    return {
      result: `Search limit reached (${MAX_SEARCHES}/${MAX_SEARCHES}).
               Compile your research data now.`,
    };
  }

  if (toolContext.state["temp:search_in_progress"]) {
    return {
      result: `Only ONE search per turn.${count}/${MAX_SEARCHES} done.
               Search again in your NEXT response.`,
    };
  }

  toolContext.state["temp:search_count"] = count + 1;
  toolContext.state["temp:search_in_progress"] = true;
  return undefined;
};

const clearSearchFlag = async (
  _tool: BaseTool,
  _args: Record<string, any>,
  toolContext: ToolContext,
  _toolResponse: Record<string, any>
) => {
  toolContext.state["temp:search_in_progress"] = false;
  return undefined;
};

export const getResearcherAgent = () => {
  return new LlmAgent({
    name: "researcher_agent",
    tools: [new WebSearchTool()],
    beforeAgentCallback,
    afterAgentCallback,
    beforeToolCallback: enforceSearchLimit,
    afterToolCallback: clearSearchFlag,
  });
};
```

### Step 4: Session State with App-Level Config
```typescript
// src/agents/agent.ts
import {
  AgentBuilder,
  MemoryService,
  InMemoryStorageProvider,
} from "@iqai/adk";

export const getRootAgent = async () => {
  const researcherAgent = getResearcherAgent();
  const analysisAgent = getAnalysisAgent();
  const recommenderAgent = getRecommenderAgent();
  const writerAgent = getWriterAgent();

  const memoryService = new MemoryService({
    storage: new InMemoryStorageProvider(),
  });

  return (
    AgentBuilder.create("research_assistant")
      .withDescription(
        "Sequential research pipeline: research -> analyze -> recommend -> write"
      )
      .asSequential([
        researcherAgent,
        analysisAgent,
        recommenderAgent,
        writerAgent,
      ])
      .withQuickSession({
        appName: "research_assistant",
        userId: process.env.USER_ID ?? "user",
        state: {
          "app:pipeline_steps": [
            "researcher",
            "analyst",
            "recommender",
            "writer",
          ],
        },
      })
      .withMemory(memoryService)
      .build()
  );
};
```

### Step 5: Memory Service Integration
```typescript
// src/index.ts
import * as dotenv from "dotenv";
import { MemoryService, InMemoryStorageProvider } from "@iqai/adk";
import { getRootAgent } from "./agents/agent";

dotenv.config();

async function main() {
  const { runner, session } = await getRootAgent();

  const memoryService = new MemoryService({
    storage: new InMemoryStorageProvider(),
  });

  console.log("==============================");
  console.log("  Research Assistant Pipeline");
  console.log("==============================\n");

  console.log("Session state (app-level config):");
  console.log(
    `  app:pipeline_steps =${JSON.stringify(session.state["app:pipeline_steps"])}`
  );
  console.log();

  const topic = "Impact of artificial intelligence on healthcare in 2025";

  console.log(`Research topic: "${topic}"\n`);
  console.log("Starting sequential pipeline...\n");

  try {
    const result = await runner.ask(topic);

    console.log("\n" + "=".repeat(50));
    console.log("  Final Report");
    console.log("=".repeat(50) + "\n");
    console.log(result);

    // Save session to memory for future recall
    await memoryService.addSessionToMemory(session);
    console.log("\nResearch session saved to memory.");

    // Search past research
    const memories = await memoryService.search({
      appName: "research_assistant",
      userId: process.env.USER_ID ?? "user",
      query: topic,
    });
    console.log(`Found ${memories.length} stored session(s).`);
  } catch (error) {
    console.error("Error running research pipeline:", error);
  }
}

main().catch(console.error);
```

---

## Advanced Patterns

### Conditionally Skip Steps
```typescript
export const skipIfDataExists = async (ctx: CallbackContext) => {
  const existingReport = ctx.state["analysis_report"];
  if (existingReport) {
    console.log(`Skipping ${ctx.agentName}, data already exists`);
    return { parts: [{ text: existingReport }] };
  }
  return undefined;
};
```

### Multi-Tenant Configuration
Use state prefixes to adapt behavior per user without code changes. An instruction containing `Write in {user:report_format} format` automatically adapts based on user preferences.

### Production Memory Persistence
Replace `InMemoryStorageProvider` with a persistent backend (PostgreSQL, MongoDB) or vector database (Pinecone, pgvector) for semantic search across stored research.

### OpenTelemetry Integration
ADK-TS provides built-in observability through OpenTelemetry for distributed tracing, metric collection, and compatibility with platforms like Jaeger, Grafana, and Datadog.

---

## Key Takeaways

- "Agent callbacks give you visibility into what's happening while the pipeline runs"
- Tool callbacks enforce hard limits that LLMs cannot circumvent through prompts
- State prefixes (`app:`, `user:`, `temp:`) separate configuration from ephemeral and pipeline data
- `.withQuickSession()` pre-loads state so agents read config via template syntax
- MemoryService persists completed sessions and enables cross-session search
- Each feature is modular and can be adopted incrementally

---

## Resources

- [ADK-TS Documentation](https://adk.iqai.com/)
- [GitHub Repository](https://github.com/IQAICOM/adk-ts)
- [ADK-TS Samples Repository](https://github.com/IQAIcom/adk-ts-samples)
- [Part 1: Sequential Agent Pattern](https://tech.timonwa.com/blog/build-research-assistant-agent-typescript-adk-ts-part-1)
- [Full Project Source Code](https://github.com/IQAIcom/research-assistant-agent)
