---
title: "Most Multi-Agent Frameworks Are Just Multiple Prompts Wearing a Trenchcoat"
url: "https://dev.to/diego_falciola_02ab709202/most-multi-agent-frameworks-are-just-multiple-prompts-wearing-a-trenchcoat-21lb"
author: "Diego Falciola"
category: "multi-agent-frameworks"
---

# Most "Multi-Agent" Frameworks Are Just Multiple Prompts Wearing a Trenchcoat

**Author:** Diego Falciola
**Published:** March 3, 2026
**Tags:** #ai #programming #opensource #typescript

---

## Article Summary

Diego Falciola argues that popular multi-agent frameworks like CrewAI, AutoGen, and LangGraph don't deliver genuine autonomous agent collaboration. Instead, they operate as single programs with multiple personas sharing identical context and memory.

## Core Critique

Falciola describes the typical multi-agent framework pattern:

1. Define multiple agents with different system prompts
2. Each agent includes tool definitions
3. A coordinator runs them sequentially
4. Agents share memory, context, and process
5. Everything resets after task completion

He contends this represents "one program with three personas" rather than authentic multi-agent systems, lacking independent existence, separate memory formation, or the capacity for genuine disagreement.

## Genuine Independence Requirements

According to Falciola's AIBot Framework approach, real agent independence demands:

- **Persistent individual memory** - Each agent maintains separate searchable long-term memory, structured core memory with importance scores, and distinct conversation histories
- **Autonomous personality** - "Soul files" define goals, motivations, behavioral patterns beyond mere tone
- **Independent operation** - Agents execute on schedules without human invocation
- **Genuine lifecycle** - Agents are created, accumulate knowledge over time, and evolve rather than being spawned and discarded per task

## Two Collaboration Modes

**Visible collaboration:** Bots communicate in observable channels, enabling transparent decision-making and multi-perspective analysis.

**Internal collaboration:** Behind-the-scenes queries between agents for context-gathering without cluttering user-facing interfaces.

## Economic Arguments

Falciola emphasizes that multi-agent value compounds nonlinearly. Specialized bots with divergent experience create insights individual agents cannot generate. This supports premium pricing through natural lock-in--accumulated bot knowledge becomes migration-resistant without artificial barriers.

## Limitations Acknowledged

- **Coordination overhead** - More inter-agent messaging increases LLM costs
- **Conflict resolution** - Human mediation required when agents disagree
- **Cold start problem** - New agents require experience accumulation before providing value

## Pricing Model

- **Free tier:** Single bot, local LLM via Ollama
- **Pro tier:** $79/month (founding members: $49/month for 12 months)
- **Features:** Multi-bot capability, cloud LLM access, autonomous loops, peer-to-peer delegation

---

## Key Takeaway

Real multi-agent systems require architectural independence--separate memories, distinct personalities, and autonomous execution--not merely different prompts within shared contexts.
