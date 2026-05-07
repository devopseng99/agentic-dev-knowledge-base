---
title: "How I designed a multi-agent AI support copilot"
url: "https://dev.to/eelcolos/how-i-designed-a-multi-agent-ai-support-copilot-4fpj"
author: "Eelco Los"
category: "building-ai-copilot"
---

# How I designed a multi-agent AI support copilot

**Author:** Eelco Los
**Published:** March 27, 2026

## Overview
Detailed architecture design for a multi-agent AI support copilot that gathers context from 5 systems in parallel (APM, CRM, SCIM, B2C, ALM) and presents evidence alongside tickets for human agents to reason faster. Uses an Orchestrator-Worker pattern with IncidentContext as shared blackboard.

## Key Concepts

### Design Requirements
1. Parallel evidence gathering across all domains simultaneously
2. Structured JSON outputs from every agent (not prose)
3. Human-in-the-loop for every action

### Confidence Arbitration Formula

```
FinalConf = sigmoid(Support - Conflict) x AgreementMultiplier
```

### Two-Layer Repo Structure

```
support-agent-research/
├── .agentic/              # domain knowledge layer
│   ├── CLAUDE.md          - persona, session bootstrap
│   ├── memory/            - architecture decisions
│   ├── plans/             - living design docs
│   ├── expertise/         - per-domain YAML mental models
│   └── specs/             - per-incident state files
│
└── .claude/               # execution layer
    ├── agents/            - agent definitions
    ├── skills/            - evidence skill implementations
    └── settings.json      - hook wiring
```

### Orchestrator-Worker Architecture

```
         Support ticket
               |
        Management Agent
      /   |    |    |   \
     APM CRM SCIM  B2C  ALM
      \   |    |    |   /
        IncidentContext
               |
        Synthesis Agent
               |
        Policy/Quality Gate (<0.65 re-evidence)
               |
        Reviewer Agent + Customer Draft
```

### Core Design Decisions
- **Orchestrator-Worker over Decentralised:** Agents never pass control to each other (prevents circular reasoning)
- **IncidentContext as Blackboard:** Shared knowledge base all agents write to
- **CLI-first auth:** Every skill uses vendor CLI (az, gh, acli) for authentication
- **No LLM both concludes and acts:** Reasoning and execution are separate; Policy Gate is deterministic code
