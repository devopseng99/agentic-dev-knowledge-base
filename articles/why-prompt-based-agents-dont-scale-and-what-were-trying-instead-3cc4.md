---
title: "Why Prompt-Based Agents Don't Scale (and What We're Trying Instead)"
url: "https://dev.to/gfernandf/why-prompt-based-agents-dont-scale-and-what-were-trying-instead-3cc4"
author: "Guillermo Fernandez"
category: "agent-prompt-chaining"
---

# Why Prompt-Based Agents Don't Scale (and What We're Trying Instead)

**Author:** Guillermo Fernandez
**Published:** April 8, 2026

## Overview

Argues that contemporary agent systems rely on "prompt pipelines" that bundle decision-making, tool selection, action execution, and result interpretation into a single layer, creating scalability problems. Proposes ORCA as an alternative cognitive runtime.

## Key Concepts

### Problems with Prompt Pipelines
- **Low observability** -- difficulty understanding agent behavior
- **Poor composability** -- limited workflow reusability
- **Fragility** -- susceptibility to prompt modification
- **Implicit execution** -- logic hidden within text

### Proposed Solution: ORCA

A "cognitive runtime layer" separating concerns:

1. **Capabilities** -- Atomic cognitive operations (retrieve, transform, evaluate)
2. **Skills** -- Composable workflows built from capabilities
3. **Execution Model** -- Explicit, structured execution enabling tracing, validation, step control
4. **Agent Orchestration** -- Agents delegate execution to the runtime layer

### Key Hypothesis
Separating cognition, execution, and orchestration improves composability, observability, and execution control -- shifting from "prompt-driven behavior" to "structured cognitive execution."

### Open Questions
- Optimal capability granularity before overhead increases
- Viability of declarative models replacing prompt pipelines
- Real-world failure scenarios

### Resources
- GitHub: https://github.com/gfernandf/agent-skills
- Paper: https://doi.org/10.5281/zenodo.19438943
