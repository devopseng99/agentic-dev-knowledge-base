---
title: "Make the OpenAI Function Calling Work Better and Cheaper with a Two-Step Function Call"
url: https://dev.to/maurerkrisztian/make-the-openai-function-calling-work-better-and-cheaper-with-a-two-step-function-call-1p96
author: Krisztian Maurer
category: function-calling
---

# Make the OpenAI Function Calling Work Better and Cheaper with a Two-Step Function Call

**Author:** Krisztian Maurer
**Published:** March 10, 2024
**Tags:** #llm #openai #ai #javascript

---

## Overview

This article presents an optimization strategy for OpenAI's function calling feature that reduces costs and improves performance when working with systems containing numerous available functions.

## Key Problem

When implementing function calling with many available functions, developers face two challenges:

1. **Cost increase:** Sending detailed JSON schemas for all functions counts toward input tokens, significantly raising API costs
2. **Performance degradation:** Excessive function details overwhelm the model, reducing accuracy and speed

## Proposed Solution: Two-Step Function Call

Instead of providing all function definitions upfront, use a selective approach:

**Step 1:** Send a request with a "tool descriptor" that lists only brief descriptions of all available functions

**Step 2:** The model identifies which specific functions it needs, then receive detailed schemas only for those selected functions

### Efficiency Gains

The author demonstrates this with an example: "Imagine we have 100 tools available, but the AI only needs 2 to answer a question. Instead of sending all 100 tool descriptions upfront, we initially send just the 'tool descriptor' request."

## Process Flow

1. Begin with single "tool descriptor" containing `neededTools` parameter
2. Model requests specific tools from the available list
3. Provide detailed JSON schemas for requested tools only
4. Model executes tasks with provided tools
5. If additional tools are needed, repeat the process

## Additional Optimization Strategy

The author mentions embeddings as an alternative approach: comparing prompt content with tool descriptions to identify optimal matches, though this method remains untested in their implementation.

## Implementation Reference

Code example available at: https://github.com/MaurerKrisztian/two-step-llm-tool-call

## Notable Considerations

The author notes potential challenges requiring careful system prompting to prevent the model from attempting to call tools before their detailed schemas are provided.
