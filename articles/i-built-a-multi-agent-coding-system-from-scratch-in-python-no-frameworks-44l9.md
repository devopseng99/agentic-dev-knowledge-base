---
title: "I Built a Multi-Agent Coding System From Scratch in Python (No Frameworks)"
url: "https://dev.to/codewithbg/i-built-a-multi-agent-coding-system-from-scratch-in-python-no-frameworks-44l9"
author: "Dr. B"
category: "multi-agent-from-scratch"
---

# I Built a Multi-Agent Coding System From Scratch in Python (No Frameworks)

**Author:** Dr. B
**Published:** May 6, 2026
**Tags:** #ai #programming #machinelearning #python

---

## Overview

The article describes building a multi-agent AI system from scratch using pure Python, without relying on frameworks like LangChain, AutoGen, or CrewAI. The system enables specialized AI agents to collaborate on converting plain English requests into working, tested Python code.

## Core Architecture

The system centers on a **Planner** that receives the complete current state as JSON and decides which agent executes next:

```json
{
  "next_agent": "Engineer",
  "message": "Implement the file structure from the Architect's plan",
  "reason": "Architecture is complete, time to write code"
}
```

### The Five Agents

- **Architect:** Creates detailed blueprints including file structure and module breakdown
- **Engineer:** Writes actual Python code based on architectural plans
- **Critic:** Reviews generated code for correctness and consistency
- **TestRunner:** Executes pytest and reports results
- **Refactorer:** Optimizes code quality after tests pass

## Key Technical Insights

**Memory Management:**
The system tracks agent memory, loop memory, and project memory. This enables the Planner to reason across iterations because "it knows the Critic flagged a bug last round."

**Why Build From Scratch:**
The author emphasizes that frameworks obscure orchestration logic. Building custom means "every line is intentional" and debugging remains transparent.

## Key Learnings

1. The Planner proved most challenging, requiring reliable JSON returns and state reasoning
2. Shared memory is powerful but requires careful management to avoid token limit issues
3. The Engineer -> Critic -> Engineer loop drives quality emergence
4. Real test execution grounds the system and ensures reliability

## Resources

**Code Repository:** [github.com/zosob/multi-agent-coder](https://github.com/zosob/multi-agent-coder)

The system intentionally minimizes complexity to remain transparent and extensible for learning purposes.
