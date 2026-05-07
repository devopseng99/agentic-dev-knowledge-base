---
title: "Building a Multi-Agent Deep Research Tool with Google ADK, A2A, & Cloud Run"
url: "https://dev.to/googleai/building-a-multi-agent-deep-research-tool-with-google-adk-a2a-cloud-run-2ldj"
author: "Amit Maraj"
category: "a2a-protocols"
---

# Building a Multi-Agent Deep Research Tool with Google ADK, A2A, & Cloud Run
**Author:** Amit Maraj
**Published:** December 30, 2025

## Overview
A parallel research squad with three specialized agents running simultaneously, coordinated by a central orchestrator using Google ADK, A2A Protocol, and Cloud Run.

## Key Concepts

### Parallel Execution with ADK

```python
from google.adk.agents import ParallelAgent

research_squad = ParallelAgent(
    name="research_squad",
    description="Runs the researcher, academic scholar, and asset gatherer in parallel.",
    sub_agents=[researcher, academic_scholar, asset_gatherer],
)
```

Reduced total processing time by 60%.

### Remote A2A Agent

```python
from google.adk.agents.remote_a2a_agent import RemoteA2aAgent

academic_scholar = RemoteA2aAgent(
    name="academic_scholar",
    agent_card="http://scholar-service:8000/.well-known/agent.json",
    description="Searches for academic papers."
)
```

### Design Patterns
1. **Orchestrator Pattern**: Central coordinator assigns tasks to specialized agents
2. **Parallelization**: Independent tasks execute simultaneously
3. **Evaluator-Optimizer**: Judge agent returns Pass/Fail with feedback, failed outputs trigger optimization loops

### Cloud Run Scaling
Zero instances when unused (no cost). 50 requests spawn 50 instances instantly. Cold starts occur after idle periods.
