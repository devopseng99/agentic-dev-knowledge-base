---
title: "An AI Benchmark That Tests Real Coding Workflows"
url: "https://dev.to/jagostoni/an-ai-benchmark-that-tests-real-coding-workflows-3b8l"
author: "Jason Agostoni"
category: "ai-agent-evaluation"
---

# An AI Benchmark That Tests Real Coding Workflows

**Author:** Jason Agostoni
**Published:** April 19, 2026 (Edited April 27, 2026)
**Tags:** #ai #programming #coding

---

## Overview

The article introduces **Ship-Bench**, an open-source AI coding benchmark designed to evaluate models through realistic software development workflows rather than synthetic tasks. The project is available at [github.com/JAgostoni/ship-bench](http://github.com/JAgostoni/ship-bench).

## Core Problem

Agostoni identifies a critical gap in current AI benchmarking: "Developers face a real choice: pick a coding model or agent based on synthetic benchmarks that look great but do not predict actual project work." Traditional benchmarks fail to capture the full professional development lifecycle.

## Solution: Ship-Bench Framework

Ship-Bench evaluates AI agents through five sequential phases mirroring real SDLC cycles:

### 1. Architect Phase
Creates a Technical Architecture Spec addressing:
- Frontend and backend stack selection
- Data modeling and search strategy
- Repository structure
- Local setup and testing approach
- Scaling considerations

### 2. UX Designer Phase
Produces a UX Direction Spec including:
- Layout and navigation decisions
- Component behavior and states
- Responsive design approach
- Visual tone and interaction patterns

### 3. Planner Phase
Develops an Implementation Backlog featuring:
- Sequenced, right-sized iterations
- MVP scope definition
- Dependency mapping
- Executable work units

### 4. Developer Phase
Builds the working MVP by:
- Implementing iterations in order
- Maintaining codebase stability
- Following specified tech choices
- Providing complete test coverage

### 5. Reviewer Phase
Verifies delivery through:
- End-to-end flow testing
- Local execution verification
- Test suite review
- Spec compliance checking
- Code quality assessment

## Test Application: Knowledge Base App

Rather than a simple to-do list, Ship-Bench uses a knowledge base application with editing capabilities. This choice balances accessibility with enough complexity to reveal differences in architecture, planning, UX judgment, and code quality.

The Product Brief includes five possible features with only three required for v1, forcing agents to make prioritization decisions.

## Evaluation Approach

The framework combines human judgment with LLM assessment, evaluating both individual phase quality and how well each handoff sets up subsequent phases. Each phase has detailed scoring criteria, with emphasis on "working deliverables at every stage, not just polished descriptions."

## Key Takeaway

Ship-Bench represents "a way to show what professional workflows look like when the goal is to build something real"--complementing rather than replacing existing benchmarks by testing complete product delivery cycles.
