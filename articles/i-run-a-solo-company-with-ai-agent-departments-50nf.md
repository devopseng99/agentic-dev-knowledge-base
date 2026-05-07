---
title: "I Run a Solo Company with AI Agent Departments"
url: "https://dev.to/setas/i-run-a-solo-company-with-ai-agent-departments-50nf"
author: "João Pedro Silva Setas"
category: "autonomous-business"
---
# I Run a Solo Company with AI Agent Departments
**Author:** João Pedro Silva Setas  **Published:** March 3, 2026

## Overview
A solo founder running five SaaS products orchestrates operations through eight AI agent "departments" using GitHub Copilot. The system features autonomous agents that share persistent memory, consult each other, and self-improve through an "Improver" meta-agent.

## Key Concepts

**Agent Architecture**
- Eight specialized agents: CEO, CFO, COO, Marketing, Accountant, Lawyer, CTO, Improver
- Each implemented as markdown files in `.github/agents/`
- Domain-specific instructions with access to MCP servers

**Knowledge Graph System**
- Persistent knowledge graph via a Model Context Protocol (MCP) memory server
- JSONL-based storage with typed entities (product, decision, deadline, lesson)
- Retention rules: standups pruned after 7 days; decisions permanent

**Inter-Agent Communication**
- Consultation protocol with call-chain tracking and max depth of 3
- Prevents infinite loops through "no-callback" rules
- Multi-level review gates for financial/legal decisions

```markdown
# Marketing Agent
## Core Responsibilities
- Content strategy and calendar
- Social media posting
- Community engagement
```

**Infrastructure Details**
- Stack: Elixir, Phoenix, LiveView
- Deployment: Fly.io (~€50/month for five products)
- GitHub Copilot for agent interaction

**Results (Month 2)**
- Revenue: €6.09
- Content output: 84+ tweets, 5 dev.to articles
- Marketing time: <1 hour weekly
- System cost: €0 (40 hours total build time over 2 months)
