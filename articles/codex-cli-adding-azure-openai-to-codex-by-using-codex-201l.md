---
title: "Codex CLI - Adding Azure OpenAI to Codex by using Codex!"
url: "https://dev.to/frankiey/codex-cli-adding-azure-openai-to-codex-by-using-codex-201l"
author: "Frank Noorloos"
category: "cloud-agents"
---

# Codex CLI - Adding Azure OpenAI to Codex by using Codex!
**Author:** Frank Noorloos
**Published:** April 18, 2025

## Overview
Using OpenAI's open-source Codex CLI coding agent to modify itself to support Azure OpenAI endpoints. Demonstrates the agent's capabilities in full-auto mode, including reading files, drafting patches, and self-modification. Includes a roadmap for enterprise readiness.

## Key Concepts

### Codex Configuration

```yaml
model: o4-mini   # default model
```

### Running in Full-Auto Mode

```bash
codex -m o4-mini --approval-mode full-auto
```

### How Codex Works
- Core logic lives in `agent-loop.ts`
- The agent reads files, drafts patches, applies them
- Rate limits on o4-mini can cause crashes; re-running resumes operation
- Approximately 4.5 million tokens consumed during the experiment

### Enterprise Readiness Checklist
1. Wire up Azure Entra ID for SSO authentication
2. Add robust retries and back-off for rate limits
3. Drop Codex into CI pipeline for automated PR reviews
4. Spin up companion agents for docs, security, and test generation
5. Automate releases with final human approval gate
