---
title: "I Built pytest for AI Agents — Here's What I Learned"
url: "https://dev.to/tomer97/i-built-pytest-for-ai-agents-heres-what-i-learned-1ld3"
author: "tomer"
category: "ai-agent-unit-testing"
---

# I Built pytest for AI Agents — Here's What I Learned

**Author:** tomer
**Published:** April 2, 2026

## Overview
AgentProbe is an open-source testing framework modeled after pytest but designed for LLM-powered agents, with 35+ assertions, fuzzing with 55 built-in prompt injection attacks, and cost analysis.

## Key Concepts

### Installation & Usage

```
pip install agentprobe
agentprobe record my_agent.py
agentprobe test
agentprobe roast my_agent.py --level savage
```

### Features
- **Agent Roast:** Humorous diagnostic analysis with cost grades
- **X-Ray Mode:** Visualizes agent decision-making with per-step cost breakdowns
- **Cost Calculator:** Reveals actual monthly costs
- **Health Check:** 0-100 scores across reliability, speed, cost, security, quality
- **Injection Playground:** Tests defenses against 55 pre-built prompt injection attacks

### Key Learnings
1. AI agents are black boxes by default with minimal built-in logging
2. Some agents cost $5 per query due to redundant LLM calls
3. ~60% of tested agents succumb to basic prompt injection attacks
4. Agent testing requires statistical assertions rather than deterministic equality checks

**Repository:** github.com/tomerhakak/agentprobe (MIT License)
