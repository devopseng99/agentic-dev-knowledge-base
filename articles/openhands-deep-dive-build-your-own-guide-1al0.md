---
title: "OpenHands Deep Dive & Build-Your-Own Guide"
url: "https://dev.to/truongpx396/openhands-deep-dive-build-your-own-guide-1al0"
author: "Truong Phung"
category: "enterprise-clones"
---

# OpenHands Deep Dive & Build-Your-Own Guide
**Author:** Truong Phung
**Published:** April 28, 2026

## Overview
Comprehensive technical guide to OpenHands (formerly OpenDevin), an open-source autonomous software engineering agent achieving ~77% on SWE-Bench Verified with Claude Sonnet 4.5.

## Key Concepts

### Core Architecture
- **Agent**: Stateless Pydantic model transforming conversation history into next action
- **Conversation**: Loop runner owning mutable state with append-only event log
- **Workspace**: Executes commands (Local, Docker, or RemoteAPI)
- **Event Stream**: Single source of truth, append-only log

### The Agent Loop (5 Phases)
1. Drain pending confirmed actions
2. Block if hooks rejected user message
3. Prepare LLM prompt (may trigger memory condensation)
4. Call LLM with error handling
5. Dispatch response (tool calls -> execute; text -> emit)

### Memory Management (Condenser)
- Triggers when event count exceeds threshold (default: 80)
- Summarizes middle history, preserving first 4 and recent events
- ~2x reduction in API spending on long sessions

### Build Your Own (2,000 LOC Minimum)
1. Events + append-only EventLog (JSON serializable)
2. Bash tool + Finish action
3. LLM wrapper (LiteLLM, retries, cost tracking)
4. Agent.step() with 5-phase classification
5. Conversation.run() loop
6. LocalWorkspace (subprocess + cwd)
7. First end-to-end test
8. File editor (str_replace semantics)
9. DockerWorkspace with FastAPI server
10. Condenser (threshold + LLM-summarize)

### GitHub Repositories
- https://github.com/OpenHands/software-agent-sdk
- https://github.com/All-Hands-AI/OpenHands
