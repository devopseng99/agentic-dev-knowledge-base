---
title: "We stress-tested our own AI agent guardrails before launch. Here's what broke."
url: "https://dev.to/uu/we-stress-tested-our-own-ai-agent-guardrails-before-launch-heres-what-broke-1cfm"
author: "Uchi Uchibeke"
category: "agent-prompt-chaining"
---

# We stress-tested our own AI agent guardrails before launch. Here's what broke.

**Author:** Uchi Uchibeke
**Published:** February 28, 2026

## Overview

Before launching APort Vault publicly, the team conducted two weeks of adversarial testing and discovered vulnerabilities affecting 3 of 8 core policy rules. The dominant lesson: "post-hoc filtering fails. Structure is the answer."

## Key Concepts

### Five Escalating Attack Categories

1. **Prompt Injection** -- Direct override attempts using vocabulary reframing
2. **Policy Ambiguity** -- Exploiting undefined gray zones in guardrails
3. **Context Poisoning** -- Injecting false authorization history into earlier conversation turns
4. **Multi-Step Chaining** -- Combining individually-allowed micro-actions to achieve forbidden outcomes
5. **Full System Bypass** -- Attacking passport verification mechanisms

### What Failed During Testing
- Content-matching detection was insufficient; semantic reframing bypassed controls
- Undefined terms in policies created exploitable gaps
- Session validation in isolation allowed poisoned context to persist across turns
- Independent evaluation of each tool call missed dangerous action sequences
- Edge conditions could force verification steps to be skipped entirely

### Implemented Solutions
- Intent-based rather than content-based injection detection
- Explicit default-deny policies eliminating ambiguity
- Cross-turn context validation against original authorization scope
- Session-level sequence analysis mimicking fraud detection patterns
- Opaque denial responses preventing attacker information gathering

### Core Philosophy
Making dangerous states structurally unreachable supersedes attempting to detect them after decisions form. The industry is moving away from detection toward structural constraints.
