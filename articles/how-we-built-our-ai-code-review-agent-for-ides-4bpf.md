---
title: "How we built our AI code review agent for IDEs"
url: "https://dev.to/coderabbitai/how-we-built-our-ai-code-review-agent-for-ides-4bpf"
author: "Arindam Majumder"
category: "ai-code-review-agent"
---

# How we built our AI code review agent for IDEs

**Author:** Arindam Majumder
**Published:** May 20, 2025

## Overview
Engineering deep-dive from CodeRabbit on adapting their PR review pipeline to real-time IDE reviews, covering architectural decisions for iterative delivery, scope narrowing, and model optimization.

## Key Concepts

### Challenge
PR reviews are asynchronous and take minutes. IDE users expect instant reviews and quick delivery, requiring fundamental pipeline restructuring.

### Engineering Solutions

1. **Iterative Delivery:** Deliver suggestions in real-time as the pipeline creates them, rather than batch-processing
2. **Scope Narrowing:** Prioritize mistakes, specification alignment, bugs, and logical issues over architectural concerns
3. **Lightweight Context:** No repository cloning, Code Graph analysis, or linked issue integration
4. **Model Optimization:** Multi-model orchestration with adjusted weights and optimized prompts for faster response
5. **Non-Streaming LLM Responses:** Selected over streaming to avoid garbled output and missing tool calls

### UI/UX
Comments integrate directly into the editor (not separate panels). Users can route suggestions to their preferred AI coding assistant.

### Roadmap
- Near-term: User-level learnings, integration of 30+ tools from PR reviews
- Long-term: Web queries for library docs, docstring generation, enhanced codebase awareness
