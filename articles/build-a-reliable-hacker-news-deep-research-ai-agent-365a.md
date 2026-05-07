---
title: "Build a Reliable Hacker News Deep Research AI Agent"
url: "https://dev.to/dbos/build-a-reliable-hacker-news-deep-research-ai-agent-365a"
author: "Qian Li"
category: "multi-cloud-durable"
---

# Build a Reliable Hacker News Deep Research AI Agent
**Author:** Qian Li
**Published:** July 17, 2025

## Overview
Demonstrates building an autonomous research agent using DBOS durable execution that searches Hacker News, iteratively explores related queries, makes decisions about when to continue, and synthesizes findings into reports. The agent can recover from any failure and continue research from where it left off.

## Key Concepts

Main agentic research workflow:

```python
@DBOS.workflow()
def agentic_research_workflow(topic: str, max_iterations: int) -> Dict[str, Any]:
    all_findings = []
    research_history = []
    current_iteration = 0
    current_query = topic

    while current_iteration < max_iterations:
        current_iteration += 1
        iteration_result = research_query(topic, current_query, current_iteration)
        research_history.append(iteration_result)
        all_findings.append(iteration_result["evaluation"])

        stories_found = iteration_result["stories_found"]
        if stories_found == 0:
            alternative_query = generate_follow_ups_step(topic, all_findings, current_iteration)
            if alternative_query:
                current_query = alternative_query
                continue

        should_continue = should_continue_step(topic, all_findings, current_iteration, max_iterations)
        if not should_continue:
            break

        if current_iteration < max_iterations:
            follow_up_query = generate_follow_ups_step(topic, all_findings, current_iteration)
            if follow_up_query:
                current_query = follow_up_query

    final_report = synthesize_findings_step(topic, all_findings)
    return {"topic": topic, "total_iterations": current_iteration, "final_report": final_report}
```

Adding DBOS to make the agent reliable and observable required changing fewer than 20 lines of code. Just annotate workflows and steps with `@DBOS.workflow()` and `@DBOS.step()`.
