---
title: "How agents call agents"
url: "https://dev.to/crabtalk/how-agents-call-agents-1f48"
author: "clearloop"
category: "hierarchical-agent"
---
# How agents call agents
**Author:** clearloop  **Published:** March 11, 2026

## Overview
Comprehensive analysis of how eight major agent frameworks handle inter-agent communication patterns across three directional axes: downward (parent-to-child), upward (child-to-parent), and lateral (peer-to-peer).

## Key Concepts

### Three Communication Directions
- **Downward delegation**: Leaders assign work to team members (universally supported)
- **Upward escalation**: Team members report back to leaders (framework-dependent)
- **Lateral coordination**: Peers communicate without hierarchical intermediation (rarely implemented)

### Framework Comparison

**Claude Code**: Most restrictive — single-level spawning only. Task tool explicitly not available to subagents. Strictly one-way.

**OpenClaw**: Configurable nesting depth (1-5 levels) with `maxSpawnDepth`. Sub-agents announce final results only.

**CrewAI**: Delegation via `allow_delegation=True`. Hierarchical delegation chains static configuration, ~2-3 levels max.

**AutoGen**: GroupChat patterns with broadcast-based communication. "Recursive group chats" explicitly supported, no depth limits.

**LangGraph**: Three patterns — supervisor (central routing), swarm (decentralized), hierarchical (supervisors managing supervisors). Recursion defaults to ~25 supersteps.

**OpenAI Agents SDK**: Bidirectional handoffs as a core primitive, enabling circular flows: A → B → A.

**Semantic Kernel**: Five orchestration patterns (sequential, concurrent, handoff, group chat, magentic) through unified API.

**Google ADK**: Strict tree structures. Sibling communication via shared session state. Agent instance can only be added as sub-agent once.

### Critical Findings
- The Agent-as-Tool Pattern dominates: wraps agents as callable tools, collapses sub-agent workflows into single tool calls
- MAST taxonomy identified 14 failure modes from 1,600+ traces across seven frameworks
- Production failure rates range from 41-87% across multi-agent systems
- Two-level hierarchies significantly outperform both flat and deep (3+) architectures
- Circular message relay documented persisting for 9+ days, consuming 60,000+ tokens
- DyLAN research shows dynamic team formation outperforms static teams

### Key Open Questions
- Whether agent-as-tool pattern justifies elimination of mid-execution monitoring
- Optimal nesting depth relative to information degradation ("telephone game effect")
- Whether shared-state coordination outperforms explicit message passing
