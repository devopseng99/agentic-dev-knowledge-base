---
title: "What is an Agent Harness? A Hands-On Guide With AgentCore harness"
url: "https://dev.to/aws/what-is-an-agent-harness-a-hands-on-guide-with-agentcore-harness-1h33"
author: "Morgan Willis"
category: "aws-agents"
---

# What is an Agent Harness? A Hands-On Guide With AgentCore harness
**Author:** Morgan Willis
**Published:** April 30, 2026

## Overview
Explains the agent harness concept (Agent = Model + Harness) and demonstrates AgentCore harness as a declarative "agent factory" that compiles config into running Strands Agents instances with isolated microVMs.

## Key Concepts

### Configuration Example

```json
{
  "name": "TrendsAgentHarness",
  "model": {
    "provider": "bedrock",
    "modelId": "global.anthropic.claude-sonnet-4-6"
  },
  "tools": [
    {"type": "agentcore_browser", "name": "browser"},
    {"type": "agentcore_code_interpreter", "name": "code-interpreter"}
  ],
  "skills": [],
  "authorizerType": "AWS_IAM"
}
```

### Deployment

```shell
npm install -g @aws/agentcore@preview
agentcore create
agentcore deploy
agentcore invoke --harness TrendsAgentHarness \
  --session-id "$(uuidgen)" \
  "What's trending in AI today?"
```

### Capabilities
| Capability | Benefit |
|---|---|
| Isolated microVM per session | No cross-session data leakage |
| Shell access | Direct command execution |
| Model-agnostic | Bedrock, OpenAI, Gemini; switch mid-session |
| Tool connectivity | MCP servers, APIs, browser, interpreter |
| Skills | Package domain knowledge as markdown + scripts |

### Escape Hatch
When outgrowing configuration: export harness to Strands Agents code for custom orchestration while remaining on the same platform.
