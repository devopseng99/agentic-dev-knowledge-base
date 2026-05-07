---
title: "CLI Agent Orchestrator: When One AI Agent Isn't Enough"
url: "https://dev.to/pinishv/cli-agent-orchestrator-when-one-ai-agent-isnt-enough-dc9"
author: "Pini Shvartsman"
category: "aws-agents"
---

# CLI Agent Orchestrator: When One AI Agent Isn't Enough
**Author:** Pini Shvartsman
**Published:** November 5, 2025

## Overview
AWS CLI Agent Orchestrator (CAO) implements hierarchical multi-agent architecture where a supervisor agent coordinates specialized workers (architecture, security, performance, testing). Each agent runs in separate tmux sessions to prevent context pollution. Uses MCP servers for inter-session communication and Amazon Bedrock action groups for delegation patterns.

## Key Concepts

### Core Architecture
- **Supervisor Agent:** Manages delegation and coordination
- **Worker Agents:** Domain-focused (architecture, security, performance, testing)
- **Isolation:** Separate tmux sessions prevent context pollution

### Communication
- MCP servers handle inter-session communication
- All local execution, no data leakage
- Architectural history cannot contaminate security reviews

### Delegation Patterns
1. **Handoff (Synchronous):** Supervisor waits for worker completion
2. **Assign (Asynchronous):** Supervisor delegates then continues independently
3. **Send Message:** Non-blocking status checks
- Implemented through Amazon Bedrock action groups

### Infrastructure Requirements
- AWS account with Amazon Bedrock access
- Claude model permissions within Bedrock
- Amazon Q Developer CLI or Claude Code integration
- tmux terminal multiplexer
- Git

### Use Case: Mainframe Modernization
Supervisor receives COBOL modernization request -> architecture agent designs structure -> security agent reviews -> performance and test agents work in parallel -> supervisor synthesizes unified plan

### Limitations
- Vendor lock-in: supervisor requires Bedrock
- Only supports Amazon Q Developer CLI and Claude Code
- Multiple agents increase API calls, token usage, latency
- tmux learning curve
- Early-stage, not production-polished

## Code Examples

### Repository Setup
```bash
git clone https://github.com/awslabs/cli-agent-orchestrator
```

### tmux Installation
```bash
brew install tmux
```
