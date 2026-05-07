---
title: "Building Your First AI Agent: A GitHub Repo Analyzer"
url: "https://dev.to/voltagent/building-your-first-ai-agent-a-github-repo-analyzer-52fd"
author: "Necati Ozmen"
category: "full-code-examples"
---

# Building Your First AI Agent: A GitHub Repo Analyzer
**Author:** Necati Ozmen (VoltAgent)
**Published:** April 22, 2025

## Overview
Tutorial building a GitHub repository analyzer using VoltAgent, an open-source TypeScript framework. Uses supervisor-worker pattern with four specialized agents.

## Key Concepts

### GitHub Repository
- https://github.com/voltagent/voltagent
- https://github.com/voltagent/voltagent/tree/main/examples/github-repo-analyzer

### Setup

```shell
npm create voltagent-app@latest github-repo-analyzer
cd github-repo-analyzer
```

### Full Implementation

```typescript
import { VoltAgent, Agent } from "@voltagent/core";
import { VercelAIProvider } from "@voltagent/vercel-ai";
import { openai } from "@ai-sdk/openai";

const mockFetchRepoStarsTool = {
  name: "fetchRepoStars",
  description: "Fetches the star count for a given GitHub repository.",
  parameters: {
    type: "object",
    properties: {
      repo: { type: "string", description: 'Repository name (e.g., "voltagent/core")' },
    },
    required: ["repo"],
  },
  execute: async ({ repo }: { repo: string }) => ({ stars: Math.floor(Math.random() * 5000) }),
};

const mockFetchRepoContributorsTool = {
  name: "fetchRepoContributors",
  description: "Fetches the contributors for a given GitHub repository.",
  parameters: {
    type: "object",
    properties: {
      repo: { type: "string", description: 'Repository name (e.g., "voltagent/core")' },
    },
    required: ["repo"],
  },
  execute: async ({ repo }: { repo: string }) => ({ contributors: ["UserA", "UserB", "UserC"] }),
};

const starsFetcherAgent = new Agent({
  name: "StarsFetcher",
  description: "Fetches the number of stars for a GitHub repository using a tool.",
  llm: new VercelAIProvider(),
  model: openai("gpt-4o-mini"),
  tools: [mockFetchRepoStarsTool],
});

const contributorsFetcherAgent = new Agent({
  name: "ContributorsFetcher",
  description: "Fetches the list of contributors for a GitHub repository using a tool.",
  llm: new VercelAIProvider(),
  model: openai("gpt-4o-mini"),
  tools: [mockFetchRepoContributorsTool],
});

const analyzerAgent = new Agent({
  name: "RepoAnalyzer",
  description: "Analyzes repository statistics and provides insights.",
  llm: new VercelAIProvider(),
  model: openai("gpt-4o-mini"),
});

const supervisorAgent = new Agent({
  name: "Supervisor",
  description: `You are a GitHub repository analyzer. When given a GitHub repository URL or owner/repo format, you will:
    1. Extract the owner/repo name.
    2. Use the StarsFetcher agent to get the star count.
    3. Use the ContributorsFetcher agent to get contributors.
    4. Pass collected data to the RepoAnalyzer agent.
    5. Return the analysis.`,
  llm: new VercelAIProvider(),
  model: openai("gpt-4o-mini"),
  subAgents: [starsFetcherAgent, contributorsFetcherAgent, analyzerAgent],
});

new VoltAgent({
  agents: {
    supervisor: supervisorAgent,
  },
});
```

### Running

```shell
npm run dev
```

Access console at https://console.voltagent.dev
