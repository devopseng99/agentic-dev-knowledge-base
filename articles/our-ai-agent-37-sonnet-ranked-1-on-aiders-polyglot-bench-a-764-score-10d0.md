---
title: "Our AI Agent + 3.7 Sonnet ranked #1 on Aider's polyglot bench -- a 76.4% score"
url: "https://dev.to/refact/our-ai-agent-37-sonnet-ranked-1-on-aiders-polyglot-bench-a-764-score-10d0"
author: "Oleg Klimov (Refact AI)"
category: "agentic-coding"
---

# Our AI Agent + 3.7 Sonnet ranked #1 on Aider's polyglot bench -- a 76.4% score

**Author:** Oleg Klimov (Refact AI)
**Date Published:** March 18, 2025

## Article Summary

Refact.ai announced that its open-source AI Agent combined with Claude 3.7 Sonnet achieved the top ranking on Aider's Polyglot Benchmark with a 76.4% score. This surpassed Aider's own 60.4% performance using the same model, as well as competitors including DeepSeek Chat V3, GPT-4.5 Preview, and ChatGPT-4o.

The benchmark evaluates autonomous problem-solving across 225 challenging coding exercises spanning C++, Go, Java, JavaScript, Python, and Rust.

## Key Technical Approach

Rather than relying on single-attempt code generation, Refact.ai employs an iterative feedback loop:

- **Code Generation:** The agent creates code based on task requirements
- **Error Detection:** Automated validation identifies issues
- **Iteration & Refinement:** The agent corrects bugs and retests until successful completion
- **Delivery:** Results are produced with high reliability

This methodology prioritizes actual problem-solving over benchmark optimization.

## Why Polyglot Benchmark Matters More Than SWE Bench

The article argues that "Polyglot is much more representative and realistic" than SWE Bench because it:

- Tests multiple programming languages
- Uses 225 diverse exercises
- Reflects real-world development workflows
- Avoids model contamination from pre-training on benchmark repositories

SWE Bench, by contrast, tests only Python across 12 repositories with simplified human-AI interaction patterns.

## Refact.ai Features

- Autonomous task execution
- Deep contextual understanding
- Developer tool integration (GitHub, Docker, PostgreSQL, MCP Servers)
- Memory and continuous learning capabilities
- Human-AI collaboration
- Open-source availability

Available on VS Code and JetBrains IDEs.

## Key Takeaway

Superior benchmark performance stems from implementing genuine iterative problem-solving rather than optimizing for single-pass code generation accuracy.
