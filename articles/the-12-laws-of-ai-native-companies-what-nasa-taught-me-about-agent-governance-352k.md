---
title: "The 12 Laws of AI-Native Companies — What NASA Taught Me About Agent Governance"
url: "https://dev.to/klement_gunndu/the-12-laws-of-ai-native-companies-what-nasa-taught-me-about-agent-governance-352k"
author: "klement Gunndu"
category: "erp-business-law"
---
# The 12 Laws of AI-Native Companies — What NASA Taught Me About Agent Governance
**Author:** klement Gunndu  **Published:** February 25, 2026

## Overview
Author describes building a fully autonomous AI-agent company and identifying governance failures that caused multi-agent system collapses. Draws inspiration from NASA's JPL Power of 10 rules to present 12 architectural laws.

## Key Concepts

**The 12 Laws**

1. **Every Output Has a Reviewer** — Worker-reviewer pairs eliminate single points of failure
2. **Every Failure Becomes a Rule** — Past mistakes become permanent system checks
3. **Everything Is Bounded** — No infinite loops, unlimited retries, or unbounded recursion
4. **Git Is the Spine** — Every agent works on branches; approvals are merges
5. **Isolation Is the Default** — Agents don't share state except through explicit handoffs
6. **Single-Threaded Ownership** — One agent owns one task; no shared responsibility
7. **Memory Compounds** — Agents read accumulated learning (session, team, company levels)
8. **The Backbone Is Deterministic** — Process logic remains code; LLMs handle content generation
9. **Bounded Autonomy with Clear Escalation** — Agents operate within defined limits, escalating beyond
10. **Verify Before Claiming** — Facts and APIs must be verified against official documentation
11. **One Concern Per File** — Each file addresses exactly one purpose
12. **Quality Has No Deadline** — Quality gates cannot be bypassed for speed

**Core Principles**
- Multi-agent governance prevents hallucinations, unauthorized API spending, credential exposure
- Deterministic control: code controls workflow; LLMs generate content only
- Humans handle uncertainty and edge cases
- Git provides complete rollback and ownership tracking

**Code Patterns**
Worker-reviewer pattern, bounded execution with retry limits, isolated worktrees, task queue claiming, memory loading, fact verification, and quality gate pipelines.
