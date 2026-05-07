---
title: "Day 4: ReAct - Reasoning + Acting upon (Prompting Technique)"
url: https://dev.to/suraj_bera/day-4-react-reasoning-acting-uponprompting-technique-3c2j
author: Suraj Bera
category: react-pattern
---

# Day 4: ReAct - Reasoning + Acting upon (Prompting Technique)

**Author:** Suraj Bera
**Published:** May 4, 2026 | Edited May 6, 2026
**Tags:** #agents #ai #llm #tutorial

## Overview

The article introduces ReAct, a prompting technique that forces AI systems to demonstrate their reasoning process step-by-step before reaching conclusions. As the author explains, "AI doesn't just answer immediately, it goes through stages."

## Core Concept

**ReAct** combines reasoning with action in five distinct phases:
1. Think
2. Plan
3. Action
4. Observe
5. Output

## Key Mental Model

The technique follows this workflow:
- Examine current state and user question
- Reason about the situation
- Determine if additional action is needed
- If yes: select a tool/perform action, then observe results (loop back to reasoning)
- If no: return final answer

## ReAct vs. Chain of Thought

The article distinguishes between two prompting approaches:

- **Chain of Thought (CoT):** The model generates intermediate reasoning steps as output without taking external actions
- **ReAct:** Combines thinking with actionable steps -- "CoT only thinks, ReAct thinks and does stuffs"

## Additional Resources

- [Code implementation](https://gist.github.com/surajbera/9dbea0b77413f5d213791591b7297727)
- Links to Day 3 and Day 2 in the series
