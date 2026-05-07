---
title: "How I Built an Autonomous AI Startup System with 37 Agents Using Claude Code"
url: "https://dev.to/asklokesh/how-i-built-an-autonomous-ai-startup-system-with-37-agents-using-claude-code-2p79"
author: "Lokesh Mure"
category: "autonomous coding agent"
---

# How I Built an Autonomous AI Startup System with 37 Agents Using Claude Code

**Author:** Lokesh Mure
**Published:** December 26, 2025

## Overview

An open-source Claude Code skill ("Loki Mode") orchestrating 37 specialized AI agents to autonomously transform product requirements into deployed products. Organizes agents into specialized swarms: Engineering (8), Operations (8), Business (8), Data (3), Product (3), Growth (4), Review (3).

## Key Concepts

### Parallel Code Review Pattern

```
IMPLEMENT -> REVIEW (3 parallel) -> AGGREGATE -> FIX -> RE-REVIEW -> COMPLETE
                |-- code-reviewer
                |-- business-logic-reviewer
                |-- security-reviewer
```

### Reviewer Response Structure

```json
{
  "strengths": ["Well-structured modules", "Good test coverage"],
  "issues": [
    {
      "severity": "High",
      "description": "Missing input validation on user endpoint",
      "location": "src/api/users.js:45",
      "suggestion": "Add schema validation before processing"
    }
  ],
  "assessment": "FAIL"
}
```

### Circuit Breaker Pattern

```
CLOSED -> failures++ -> OPEN (blocking) -> cooldown -> HALF-OPEN (testing)
```

Failed agent types stop receiving work. After cooldown, one test request determines if normal operations resume or circuit remains open.

### Anti-Hallucination Protocol

| Category | Verification |
|----------|--------------|
| Technical capabilities | Web search official documentation |
| API usage | Read docs + test with real calls |
| Packages/dependencies | Verify on registry |
| Syntax | Execute code, don't assume |
| Performance claims | Benchmark with real data |

### Installation

```bash
git clone https://github.com/asklokesh/claudeskill-loki-mode.git ~/.claude/skills/loki-mode
claude --dangerously-skip-permissions
```

### Activation

```
> Loki Mode with PRD at ./docs/requirements.md
```

Repository: https://github.com/asklokesh/claudeskill-loki-mode
