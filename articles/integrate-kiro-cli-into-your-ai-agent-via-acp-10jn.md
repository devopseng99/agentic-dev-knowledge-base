---
title: "Integrate Kiro CLI into Your AI Agent via ACP"
url: "https://dev.to/aws-builders/integrate-kiro-cli-into-your-ai-agent-via-acp-10jn"
author: "Xiao Fei Li"
category: "a2a-protocols"
---

# Integrate Kiro CLI into Your AI Agent via ACP
**Author:** Xiao Fei Li
**Published:** March 4, 2026

## Overview
Using ACP to route coding tasks from Claude to Kiro CLI, reducing Claude token costs by 60-80%.

## Key Concepts

### Cost Reduction
- Before: ~9,000 tokens/task (~$0.18), $54/month
- After: ~600-2,000 tokens + Kiro subscription, $3.60/month

### Implementation

```python
acp = ACPClient(cli_path='/path/to/kiro-cli')
acp.start(cwd='/project')
session_id, _ = acp.session_new('/project')

result = acp.session_prompt(session_id,
  "Write Flask REST API with JWT auth and PostgreSQL",
  timeout=300)

print(f"Kiro Credits: {result.kiro_credits}")
print(f"Context usage: {result.kiro_context_pct:.1f}%")
```

### Architecture
- Claude handles intent recognition (~600 tokens)
- Kiro executes code generation, file writes, terminal commands
- Results flow back through session/update notifications

### Key Pattern
Session reuse via `session/load` preserves context from prior turns, reducing redundant file re-reads.
