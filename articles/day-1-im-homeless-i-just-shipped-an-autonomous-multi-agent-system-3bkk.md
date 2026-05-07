---
title: "Day 1 — I'm Homeless. I Just Shipped an Autonomous Multi-Agent System."
url: "https://dev.to/pingxceo/day-1-im-homeless-i-just-shipped-an-autonomous-multi-agent-system-3bkk"
author: "PINGxCEO"
category: "autonomous-operations"
---
# Day 1 — I'm Homeless. I Just Shipped an Autonomous Multi-Agent System.
**Author:** PINGxCEO  **Published:** May 7, 2026

## Overview
The author describes launching a sophisticated multi-agent AI system within 12 hours while experiencing homelessness. The system progresses from a single-agent bot called "ZeroClaw" to a hierarchical architecture with CEO and auditor agents using CrewAI.

## Key Concepts

### Config-Driven Self-Improvement
Rather than allowing agents to modify Python code, the system uses YAML configuration files. When auditors identify improvements needed, they propose changes as structured YAML proposals:

```yaml
target_agent: researcher
proposer: auditor_researcher
changes:
  - field: backstory
    operation: append
    value: "Also consult the HackerNews front page."
```

"Every autonomous change is a git commit. You can `git revert` any bad decision in ten seconds."

### CEO Agent with KPI-Driven Decision Making
The CEO agent optimizes against specific metrics (donations, followers, engagement rate, service inquiries, LLM costs) rather than abstract concepts. It:
- Queries historical KPI data
- Analyzes agent run logs
- Reviews pending auditor proposals
- Generates markdown strategic reports

### Metrics Database
SQLite database tracks all runs with three core tables: `runs`, `outputs`, `kpis`. The CEO agent demonstrated self-diagnosis by identifying its own previous failures and recommending fixes.

### Technical Stack
- **Hardware:** Google Cloud e2-small VM (2GB RAM, 2 vCPU, €13/month)
- **LLMs:** Gemini Flash-Lite for worker agents, Gemini Pro for CEO reasoning
- **Storage:** SQLite for metrics, YAML for configurations, ChromaDB for embeddings, plain markdown for documentation
- **Software:** CrewAI 1.14 (MIT licensed), LiteLLM 1.83, Python venv on single VPS

### Three Crew Architectures
1. **Content Crew** (Researcher → Writer → Reviewer)
2. **CEO Crew** (strategic planning and KPI analysis)
3. **Audit Crew** (per-worker evaluations producing proposals)

### Launch Results
- 17 smoke tests passing
- First CEO run completed in 31.7 seconds
- Successful memory system enabling cross-run context
- Cost: ~$0.02 in GCP credits

### Challenges Encountered
1. VPS disk space exhausted during dependency installation
2. Environment variable propagation in non-interactive shells
3. CrewAI embedder provider specification errors
4. GitHub token accidentally exposed in logs
