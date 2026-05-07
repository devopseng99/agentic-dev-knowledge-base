---
title: "Multi-Agent Orchestration: Three Patterns for Complex AI Workflows in NodeJS"
url: "https://dev.to/arslan_mecom/multi-agent-orchestration-three-patterns-for-complex-ai-workflows-355l"
author: "Muhammad Arslan"
category: "supervisor-agent-pattern"
---

# Multi-Agent Orchestration: Three Patterns for Complex AI Workflows in NodeJS

**Author:** Muhammad Arslan
**Published:** March 20, 2026

## Overview

Explores three orchestration patterns using HazelJS Agent Runtime in TypeScript: @Delegate (peer-to-peer), AgentGraph (DAG workflows), and SupervisorAgent (LLM-driven routing).

## Key Concepts

### Pattern 1: @Delegate (Peer-to-Peer)

Best for 2-5 agents with clear hierarchies.

```typescript
import { Agent, Delegate, tool } from "hazeljs";

@Agent({
  name: "ResearchAgent",
  model: "gpt-4o",
  systemPrompt: "You are a research specialist."
})
class ResearchAgent {
  @tool({ description: "Search academic papers" })
  async searchPapers(query: string): Promise<string> {
    // Search implementation
    return `Found papers about ${query}`;
  }
}

@Agent({
  name: "WriterAgent",
  model: "gpt-4o",
  systemPrompt: "You write clear technical content."
})
class WriterAgent {
  @tool({ description: "Write article from research" })
  async writeArticle(research: string): Promise<string> {
    return `Article based on: ${research}`;
  }
}

@Agent({
  name: "ContentOrchestrator",
  model: "gpt-4o",
  systemPrompt: "Coordinate research and writing tasks."
})
class ContentOrchestratorAgent {
  @Delegate({ to: ResearchAgent })
  async research(query: string): Promise<string> { return ""; }

  @Delegate({ to: WriterAgent })
  async write(research: string): Promise<string> { return ""; }
}
```

### Pattern 2: AgentGraph (DAG Workflows)

Supports sequential, conditional, and parallel execution.

```typescript
import { AgentGraph } from "hazeljs";

const graph = new AgentGraph()
  .addNode("classify", classifyAgent)
  .addNode("billing", billingAgent)
  .addNode("support", supportAgent)
  .addConditionalEdge("classify", (result) => {
    if (result.category === "billing") return "billing";
    return "support";
  })
  .compile();

// Parallel fan-out
const parallelGraph = new AgentGraph()
  .addNode("research", researchAgent)
  .addNode("analyze", analyzeAgent)
  .addParallelEdges("start", ["research", "analyze"])
  .addNode("merge", mergeAgent)
  .addEdge(["research", "analyze"], "merge")
  .compile();
```

### Pattern 3: SupervisorAgent (LLM-Driven Routing)

Best for complex, unknown workflows with 6+ agents.

```typescript
import { SupervisorAgent } from "hazeljs";

const supervisor = new SupervisorAgent({
  model: "gpt-4o",
  workers: [researchAgent, writerAgent, codeAgent, reviewAgent],
  maxIterations: 10,
  systemPrompt: "Decompose complex tasks and route to appropriate workers."
});

const result = await supervisor.run(
  "Research AI agents, write a tutorial, include code examples, and review it."
);
```

### Production Considerations

- State persistence for long-running workflows
- Approval workflows for sensitive operations
- Parallel execution optimization
- Cost management with model routing
