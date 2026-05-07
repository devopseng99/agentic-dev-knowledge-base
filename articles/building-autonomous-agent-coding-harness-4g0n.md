---
title: "Building Autonomous Agent Coding Harness"
url: "https://dev.to/stormhub/building-autonomous-agent-coding-harness-4g0n"
author: "Johnny Z"
category: "autonomous coding agent"
---

# Building Autonomous Agent Coding Harness

**Author:** Johnny Z
**Published:** April 16, 2026

## Overview

Documents a personal experiment building a full-stack weather chat application using the Claude Agent SDK, testing whether coding agents can work with unfamiliar, cutting-edge libraries. Intentionally introduces architectural complexity across .NET API with Microsoft Agent Framework, AG-UI protocol, and schema-driven UI rendering.

## Key Concepts

### Round 1 Results (Feature Spec Only)

- Generated .NET 8 instead of .NET 10
- Built plain ASP.NET Core MVC instead of Microsoft Agent Framework
- Used standard JSON REST instead of AG-UI SSE streaming
- Omitted LLM integration entirely (used regex instead)
- Implemented hardcoded React components instead of schema-driven rendering

Finding: "Given only a feature spec, coding agents gravitate toward familiar patterns from training data."

### Round 2 Results (Enhanced Requirements + Custom Skills)

- Correct .NET version achieved
- Packages installed but unused
- Agents created a "cargo cult" architecture: right file names and structure, but no actual wiring

### Conclusions

Acknowledging architectural requirements superficially differs from implementing them. Agents need highly detailed, step-by-step plans with concrete wiring instructions that leave minimal room for substitution.

### Recommended Approach

1. Interactive upfront planning with detailed, step-by-step implementation plans
2. Step-by-step execution with verification of each output before proceeding
