---
title: "The Prompt Injection Problem: A Guide to Defense-in-Depth for AI Agents"
url: "https://dev.to/manveer_chawla_64a7283d5a/the-prompt-injection-problem-a-guide-to-defense-in-depth-for-ai-agents-3p1"
author: "Manveer Chawla"
category: "agent-security"
---

# The Prompt Injection Problem: A Guide to Defense-in-Depth for AI Agents

**Author:** Manveer Chawla
**Published:** February 25, 2026

## Summary

Manveer Chawla argues that prompt injection represents an architectural vulnerability rather than a model performance problem. The article presents evidence from Anthropic's Claude Sonnet 4.6 system card showing an 8% one-shot attack success rate in computer use scenarios, yet 0% in coded environments -- demonstrating that environmental design, not model capability, determines security outcomes.

## Key Arguments

### The Architectural Problem
Chawla contends that "instructions and data share the same context window" in LLMs, creating an in-band signaling vulnerability analogous to SQL injection. Training models to resist attacks proves insufficient because attackers maintain unbounded surface area for new injection techniques. The author notes that moving from 50% to 8% success rates represents progress, but achieving zero may be architecturally impossible.

### The Lethal Trifecta Framework
Risk concentrates when three conditions coincide:
- Agent access to tools (sending emails, executing code)
- Processing of untrusted input (web pages, external documents)
- Access to sensitive data or capabilities

The author emphasizes that nearly all desired use cases involve all three elements, making defensive architecture essential rather than optional.

### Five-Layer Defense Model

**Layer 1: Permission Boundaries**
Implement just-in-time (JIT) access with short-lived credentials (15-minute TTL recommended). Task-scoped permissions prevent broad session-wide access. Cloud providers now offer infrastructure supporting this pattern through distinct non-human identities.

**Layer 2: Action Classification and Gating**
Categorize tools by risk tier -- read-only actions proceed autonomously, reversible writes log with rollback capability, irreversible actions require human confirmation or second-model review.

**Layer 3: Input Sanitization**
Strip HTML comments, remove metadata, convert rich text to plaintext, and flag injection pattern matches before content reaches the model's context window.

**Layer 4: Output Monitoring**
Detect anomalies in real-time: unexpected tool calls, out-of-scope resource access, data exfiltration patterns, behavioral discontinuities. Kill switches must halt agents on high-confidence detection.

**Layer 5: Blast Radius Containment**
Employ network segmentation (VPC Service Controls, PrivateLink), credential isolation through scoped tokens, session isolation preventing lateral movement, and comprehensive audit logging.

## Practical Application: Email Agent Blueprint

The article illustrates defense-in-depth through an email processing agent -- a use case hitting the full lethal trifecta:

- Read inbox access, draft-only writing
- No calendar/storage access
- HTML-to-plaintext conversion
- Kill switches for unauthorized URL access
- Sandboxed execution with restricted egress
- OAuth token limiting scope to read + draft creation

This architecture bounds damage to draft creation and inbox reading -- the legitimately scoped permissions -- even if injection succeeds.

## Implications for AI Labor Displacement

Chawla challenges the "replace all workers" narrative by noting that defense-in-depth architectures necessarily constrain autonomy. Agents requiring human oversight for irreversible actions augment rather than replace workers. The most successful implementations redesign workflows so humans review only high-stakes decisions while agents handle high-volume, lower-risk tasks.

Adoption barriers validate this perspective: PwC reports 34% of executives cite cybersecurity as their top adoption barrier, while 42% of companies abandoned AI initiatives entirely due to security risks.

## Core Thesis

The author concludes that treating the model as a security boundary proves futile. Instead, organizations should "assume every layer can fail" and design systems ensuring "no single failure is catastrophic." The 8% success rate shouldn't discourage agentic AI deployment -- rather, it should motivate architectural thinking that makes failure manageable rather than catastrophic.
