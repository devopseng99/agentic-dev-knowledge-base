---
title: "I Built an Autonomous Dev Team with 3 AI Agents"
url: "https://dev.to/zvone187/i-built-an-autonomous-dev-team-with-3-ai-agents-that-takes-a-linear-ticket-all-the-way-to-a-pull-291g"
author: "zvone187"
category: "ai-agents-autonomous-dev"
---

# I Built an Autonomous Dev Team with 3 AI Agents

**Author:** zvone187
**Date Published:** April 14, 2026
**Tags:** #ai #agents #agentskills #programming

## Overview

The author describes a system where three specialized AI agents coordinate to take Linear tickets through a complete development workflow—from planning to pull request—using Slack as their communication hub.

## Key System Components

### 1. Tech Lead Agent (Coordinator)
- Sets up isolated development environments
- Creates git worktrees for parallel ticket processing
- Assigns different ports to each ticket for independent testing
- Orchestrates handoffs between agents
- Tracks overall status and ensures nothing falls through

### 2. QA Agent (Testing)
- Creates testing plans *before* any code is written
- Tests from user perspective rather than implementation details
- Interacts with running applications via browser automation
- Generates detailed HTML test reports
- Iterates with developers on failures

### 3. Developer Agent (Implementation)
- Receives multi-perspective implementation plans
- Writes and tests code
- Creates pull requests
- Engages in code review cycles
- Addresses QA findings and makes iterations

## Workflow Stages

**Planning Phase:**
- Dual planning: Two agents independently create implementation plans
- Cross-review: Each agent reviews the other's approach with fresh context
- Synthesis: Final agent synthesizes both perspectives into optimal plan

**Implementation Phase:**
- Code development with Playwright and Figma MCP access
- Automated testing and iteration
- Pull request generation
- Code review with separate agent (fresh context)

**Testing & Review Phase:**
- QA browser-based testing against pre-written plan
- Developer-QA iteration loops
- Human manual verification via isolated port links

## Key Insights

**"The biggest problem with LLMs in coding is that once they go down a path, they get stuck."** The author identifies that single-agent systems struggle with course-correction due to conversation context constraints.

**Why Multiple Agents Excel:**
- Fresh context prevents anchoring bias
- Each agent approaches tasks independently
- Similar to human code review processes
- Specialized roles improve quality

## Critical Design Decisions

1. **Testing Plans Before Code** — Prevents biasing tests toward implementation rather than user needs

2. **Parallel Environments** — Isolated worktrees prevent port conflicts when handling multiple tickets simultaneously

3. **Slack Integration** — Provides natural communication interface, observability, and ability for humans to intervene mid-workflow

4. **Human Checkpoints** — System handles routine work; humans focus on architectural decisions and complex edge cases

## Lessons Learned

- Detailed ticket descriptions dramatically improve results
- Acceptance criteria and clear requirements are essential
- The system's speed makes communication quality the bottleneck
- Humans remain essential for business logic and strategy decisions

## Resources

- [Open Source Skills Repository](https://github.com/Pythagora-io/agent-templates)
- Works with both OpenClaw and Pazi platforms
- Ready-to-import templates available
