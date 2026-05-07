---
title: "Long Context Windows in LLMs are Deceptive (Lost in the Middle problem)"
url: "https://dev.to/llmware/why-long-context-windows-for-llms-can-be-deceptive-lost-in-the-middle-problem-oj2"
author: "Namee"
category: "llm-agent-context-window"
---

# Long Context Windows in LLMs are Deceptive (Lost in the Middle problem)

**Author:** Namee (LLMWare)
**Published:** March 20, 2024

## Overview
Extended context windows create misleading assumptions about eliminating RAG. Research shows about 2/3 of models fail to find specific information even within 2K tokens, demonstrating the "Lost in the Middle" problem.

## Key Concepts

### Models That Passed 2K Test
- ChatGPT Turbo
- Open Hermes 2.5 - Mistral 7B
- Yi 34B Chat

### Models That Failed
- Claude 2.0, GPT-4 Turbo, Gemini, Zephyr 7B Beta, Llama 2 - 70B chat, Mixtral 8x7B

### RAG Solution
Even the smallest 1B parameter model (LLMWare BLING Tiny Llama 1.1B) with RAG can outperform GPT-4 Turbo for fact-based searches without RAG.
