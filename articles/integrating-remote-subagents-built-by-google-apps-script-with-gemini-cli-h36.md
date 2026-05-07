---
title: "Integrating Remote Subagents Built by Google Apps Script with Gemini CLI"
url: "https://dev.to/gde/integrating-remote-subagents-built-by-google-apps-script-with-gemini-cli-h36"
author: "Tanaike"
category: "cloud-agents"
---

# Integrating Remote Subagents Built by Google Apps Script with Gemini CLI
**Author:** Tanaike
**Published:** April 13, 2026

## Overview
Deep technical guide on connecting remote subagents created with Google Apps Script to Gemini CLI using the A2A protocol. Demonstrates bypassing authentication via local agent cards, building A2A servers with GAS, orchestrating 160+ Google Workspace skills, and overcoming Tool Space Interference (TSI).

## Key Concepts

### A2A Server in Google Apps Script

```javascript
const object = {
  apiKey: "{apiKey}",
  model: "models/gemini-3-flash-preview",
  accessKey: "sample",
};

const doGet = (e) => main(e);
const doPost = (e) => main(e);

function main(e) {
  const context = createServerContext_();
  const m = MCPA2Aserver;
  m.a2a = true;
  m.apiKey = object.apiKey;
  m.model = object.model;
  if (object.accessKey) m.accessKey = object.accessKey;
  const res = m.main(e, context);
  return res;
}
```

### Agent Card Definition

```javascript
const agentCard = {
  name: "API Manager",
  description: "Provide management for using various APIs.",
  provider: { organization: "Tanaike", url: "https://github.com/tanaikech" },
  version: "1.0.0",
  url: "https://script.google.com/macros/s/{deploymentId}/exec?accessKey=sample",
  capabilities: { streaming: false, pushNotifications: false },
  skills: [
    {
      id: "get_exchange_rate",
      name: "Currency Exchange Rates Tool",
      description: "Helps with exchange values between various currencies",
    },
    {
      id: "get_current_weather",
      name: "Get current weather",
      description: "Return weather information by location, date, and time.",
    }
  ]
};
```

### Local Agent Card for Gemini CLI

```markdown
---
kind: remote
name: sample-gas-agent
agent_card_json: |
  {
    "name": "API Manager",
    "url": "https://script.google.com/macros/s/{deploymentId}/exec?accessKey=sample",
    "skills": [...]
  }
---
```

### Tool Space Interference (TSI) Solution
When 160+ skills are loaded into a single MCP server, TSI degrades reasoning accuracy. The A2A subagent architecture delegates the vast tool execution space to the remote agent, preserving the main CLI agent's reasoning capacity. Industry soft limit is ~20 functions per agent; this approach handles 160+ reliably.

### Google Workspace Orchestrator
The advanced subagent integrates Gmail, Drive, Calendar, Classroom, Analytics, Docs, Sheets, Slides, RAG via File Search, image generation, YouTube summarization, and Google Maps -- all 160 skills accessible through Gemini CLI.
