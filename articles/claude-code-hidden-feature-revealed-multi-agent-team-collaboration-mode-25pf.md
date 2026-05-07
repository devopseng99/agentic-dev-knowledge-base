---
title: "Claude Code Hidden Feature Revealed: Multi-Agent Team Collaboration Mode"
url: "https://dev.to/stklen/claude-code-hidden-feature-revealed-multi-agent-team-collaboration-mode-25pf"
author: "TK Lin"
category: "agent-team-coordination"
---
# Claude Code Hidden Feature Revealed: Multi-Agent Team Collaboration Mode
**Author:** TK Lin  **Published:** January 25, 2026

## Overview
Discovery of hidden TeammateTool feature in Claude Code v2.1.19, enabling AI agents to form collaborative teams rather than operating as solo assistants.

## Key Concepts

### TeammateTool Operations
```
spawnTeam      → Spawn a new agent team
discoverTeams  → Discover available teams
requestJoin    → Request to join a team
assignTask     → Assign tasks
broadcastMessage → Broadcast messages to all members
voteOnDecision → Vote on decisions
```

### Five Interaction Modes
| Mode | Description | Use Case |
|------|-------------|----------|
| Leader Pattern | One leader directing multiple subordinates | Project management |
| Swarm Pattern | Swarm-style parallel processing | Large volumes of similar tasks |
| Pipeline Pattern | Pipeline relay | Multi-stage processing flows |
| Council Pattern | Council-based decision making | Multi-perspective review |
| Watchdog Pattern | Monitoring sentinel | Quality control, anomaly detection |

### Real-World Example: Animal Identification System
```
Boss (Claude Code CLI)
├── Assistant A: Search Petnow technical analysis
├── Assistant B: Research ArcFace loss functions
└── Assistant C: Investigate public datasets
```
Result: "nine research reports in a single afternoon"

### Advanced Scenarios
```python
# Training Optimization Swarm — 5 agents testing different hyperparameters:
# Agent A: learning_rate=0.001, batch_size=32
# Agent B: learning_rate=0.0001, batch_size=64
# Agent C: learning_rate=0.001, batch_size=64
# Council votes to select best configuration
```
