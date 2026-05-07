---
title: "We stress-tested our own AI agent guardrails before launch. Here's what broke."
url: "https://dev.to/uu/we-stress-tested-our-own-ai-agent-guardrails-before-launch-heres-what-broke-1cfm"
author: "Uchi Uchibeke"
category: "agent-guardrails"
---

# We stress-tested our own AI agent guardrails before launch. Here's what broke.

**Author:** Uchi Uchibeke
**Published:** February 28, 2026

## Overview
Documents internal security testing conducted before launching APort Vault, revealing vulnerabilities in three of eight core policy rules.

## Key Concepts

### Five Attack Classes Tested
1. **Prompt Injection:** Vocabulary reframing shifted LLM evaluation
2. **Policy Ambiguity:** Exploiting undefined terms
3. **Context Poisoning:** Injecting false historical context
4. **Multi-Step Reasoning Manipulation:** Chaining individually-allowed actions toward forbidden outcomes
5. **Full System Bypass:** Combined attacks targeting verification mechanisms

### Critical Vulnerabilities
- Semantic reframing bypassed content-matching detection
- Per-turn session validation enabled context manipulation
- Independent tool call evaluation missed dangerous sequences

### Solutions
- Intent-based authorization instead of content matching
- Default-deny policies for undefined gaps
- Cross-turn session memory validation
- Opaque denial messages preventing information leakage

### Core Philosophy
"Post-hoc filtering fails. Make dangerous states structurally unreachable."
