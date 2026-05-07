---
title: "How to Add Human Approval to AI Agent Actions"
url: "https://dev.to/nebulagg/how-to-add-human-approval-to-ai-agent-actions-keg"
author: "The Daily Agent"
category: "human-in-the-loop"
---

# How to Add Human Approval to AI Agent Actions

**Author:** The Daily Agent
**Published:** March 12, 2026
**Series:** AI Agent Quick Tips (Part 4 of 16)

## Overview

This tutorial addresses a critical safety concern: preventing AI agents from executing dangerous actions without human oversight. The article presents a Python-based approval gate system that can be integrated into any agent workflow.

## Problem Statement

The author opens with a cautionary scenario: "Your AI agent just deleted a production database table." Without approval mechanisms, agents can execute destructive operations autonomously, creating significant risks for systems that handle emails, files, and APIs.

## Core Solution

The implementation uses three risk classification tiers:

1. **READ** - Search and list operations auto-approve silently
2. **WRITE** - Email and file creation operations auto-approve but log activity
3. **DESTRUCTIVE** - Database deletions, deployments, and raw SQL require human confirmation

### Key Code Components

```python
from enum import Enum
from datetime import datetime

class Risk(Enum):
    READ = "read"
    WRITE = "write"
    DESTRUCTIVE = "destructive"

TOOL_RISK = {
    "search_docs": Risk.READ,
    "send_email": Risk.WRITE,
    "delete_file": Risk.DESTRUCTIVE,
}

def approve(tool_name: str, args: dict) -> bool:
    risk = TOOL_RISK.get(tool_name, Risk.DESTRUCTIVE)

    if risk == Risk.READ:
        return True

    if risk == Risk.WRITE:
        print(f"[LOG] {datetime.now():%H:%M:%S} | {tool_name}({args})")
        return True

    print(f"APPROVAL REQUIRED: {tool_name}")
    print(f"Arguments: {args}")
    response = input("Execute this action? (y/n): ").strip().lower()
    return response == "y"

def safe_tool_call(tool_name: str, args: dict, tool_fn):
    if not approve(tool_name, args):
        return {"status": "blocked", "reason": "Human denied execution"}
    return tool_fn(**args)
```

## Implementation Details

**Safety by Default:** Unknown tool names default to destructive classification, ensuring that hallucinated or unmapped tools receive maximum restriction.

**Decoupled Architecture:** The approval gate operates independently from tool logic, allowing integration without modifying existing functions.

**Agent Loop Integration:**
```python
for step in agent.run(task):
    tool_fn = TOOLS[step.tool_name]
    result = safe_tool_call(step.tool_name, step.args, tool_fn)
    agent.receive(result)
```

## Production Considerations

The author suggests replacing terminal `input()` with webhook-based or notification systems (Slack, email) for deployed agents that require asynchronous approval workflows.

## Key Takeaway

Implementing tiered approval gates ensures agents maintain autonomy for low-risk operations while enforcing human oversight on actions that could impact systems or data integrity.
