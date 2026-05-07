---
title: "AX: A Design Discipline for the AI Agent Era"
url: "https://dev.to/attebury/ax-a-design-discipline-for-the-ai-agent-era-266e"
author: "John Attebury"
category: "agent-ui-frameworks"
---

# AX: A Design Discipline for the AI Agent Era
**Author:** John Attebury
**Published:** March 15, 2026

## Overview
Introduces Agent Experience (AX) as a formal design discipline for optimizing how AI agents interact with tool definitions and APIs, with four design pressures and six AX concerns.

## Key Concepts

### Four Design Pressures
1. Context budget: every tool definition consumes tokens
2. Probabilistic selection: AI uses semantic matching, not explicit calls
3. Zero-state learning: agents lack memory across interactions
4. Emergent composition: agents decide runtime orchestration

### Six AX Concerns
- Orchestration Design
- Tool Contract Design
- Context Economics
- Domain Legibility
- Safety & Trust Design
- Error & Recovery Design

### Core Principles
- Single Responsibility: focused tools prevent combinatorial reasoning problems
- Ubiquitous Language: tool names match operator vocabulary
- Composition over monoliths: atomic steps enable partial workflows
- Safety boundaries: distinguish read-safe from side-effect tools
