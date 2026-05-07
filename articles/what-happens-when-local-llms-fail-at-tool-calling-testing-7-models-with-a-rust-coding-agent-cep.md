---
title: "What Happens When Local LLMs Fail at Tool Calling -- Testing 7 Models with a Rust Coding Agent"
url: "https://dev.to/kuroko1t/what-happens-when-local-llms-fail-at-tool-calling-testing-7-models-with-a-rust-coding-agent-cep"
author: "kuroko"
category: "rust-go-java-agents"
---

# What Happens When Local LLMs Fail at Tool Calling
**Author:** kuroko
**Published:** March 1, 2026

## Overview
Tests 7 local LLMs (7B-24B params) with Whet, a Rust coding agent via Ollama. Four passed, three failed with distinct patterns: refusing to act, tool format confusion (JSON as text), and retry loops. Generation matters more than parameter count -- all qwen2.5 failed, all qwen3 succeeded.

## Key Concepts

Three failure patterns and fixes:
1. **Refusing to Act** (qwen2.5:7b): asked user instead of executing. Fix: stronger system prompt
2. **Tool Format Confusion** (qwen2.5-coder:14b): output JSON as text, zero tool calls. Fix: JSON fallback parser
3. **Retry Loop** (qwen3:14b initial): repeated identical failing call 8+ times. Fix: "NEVER repeat the same failing tool call more than once"

| Metric | Before fix | After fix |
|--------|-----------|-----------|
| Tokens | ~30,000 | 8,946 |
| Tool calls | 10+ | 3 |
| Success | <20% | 100% |

Agent: https://github.com/kuroko1t/whet
