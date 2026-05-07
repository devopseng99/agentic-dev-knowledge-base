---
title: "DeerFlow - ByteDance's SuperAgent Execution Engine"
url: "https://dev.to/wonderlab/one-open-source-project-a-day-no33-deerflow-bytedances-superagent-execution-engine-83o"
author: "WonderLab"
category: "agent-sandbox"
---

# DeerFlow - ByteDance's SuperAgent Execution Engine

**Author:** WonderLab
**Published:** April 8, 2026

## Overview
DeerFlow is ByteDance's open-source SuperAgent execution engine (59K+ GitHub stars, MIT license). Unlike frameworks that generate code without executing it, DeerFlow runs code in sandboxed Docker containers, orchestrates parallel sub-agents, and produces actual deliverables. V2.0 is a complete rewrite from the v1.x research tool.

## Key Concepts

### Architecture
Lead Agent decomposes tasks and orchestrates parallel sub-agents:
- Researcher (search/crawl)
- Coder (code generation + sandbox execution)
- Reporter (synthesis)

### Skills-as-Markdown
Non-engineers extend functionality using Markdown files instead of Python classes.

## Code Examples

### Quick Start

```bash
git clone https://github.com/bytedance/deer-flow.git
cd deer-flow
make config
vim config.yaml
make docker-init
make docker-start
# Access web UI at http://localhost:2026
```

### Sandbox Execution

```python
async def execute_in_sandbox(code: str, language: str = "python") -> ExecutionResult:
    container = await docker_client.containers.create(
        image="deerflow-sandbox:latest",
        command=["python", "-c", code],
        volumes={
            "/mnt/user-data/workspace": {"bind": "/workspace", "mode": "rw"},
            "/mnt/user-data/outputs": {"bind": "/outputs", "mode": "rw"},
        },
        network_mode="bridge",
        mem_limit="2g",
        cpu_period=100000,
        cpu_quota=50000,
    )
    result = await container.start()
    stdout, stderr = await container.logs()
    return ExecutionResult(stdout=stdout.decode(), stderr=stderr.decode(), exit_code=result["StatusCode"])
```

### Skill Definition (Markdown)

```markdown
# Deep Research Skill

## Trigger Conditions
Activate when user needs deep research on a topic.

## Execution Steps
1. Break into 3-5 key questions
2. Multi-round searches per question (minimum 3 rounds)
3. Crawl high-quality sources
4. Synthesize findings
5. Generate structured report

## Output Format
- Executive summary (< 200 words)
- Deep-dive sections (500-1000 words each)
- Source reference list
```

### LangGraph Workflow

```python
from langgraph.graph import StateGraph, END
from typing import TypedDict

class ResearchState(TypedDict):
    query: str
    sub_tasks: list[str]
    search_results: dict
    code_outputs: dict
    final_report: str

workflow = StateGraph(ResearchState)
workflow.add_node("planner", lead_agent_plan)
workflow.add_node("researcher", researcher_agent)
workflow.add_node("coder", coder_agent)
workflow.add_node("reporter", reporter_agent)
workflow.set_entry_point("planner")
workflow.add_edge("planner", "researcher")
workflow.add_edge("planner", "coder")       # Parallel execution
workflow.add_edge("researcher", "reporter")
workflow.add_edge("coder", "reporter")
workflow.add_edge("reporter", END)
app = workflow.compile()
```

### Model Configuration

```yaml
llm:
  provider: openai_compatible
  base_url: "https://api.deepseek.com"
  api_key: "${DEEPSEEK_API_KEY}"
  model: "deepseek-v3"
```
