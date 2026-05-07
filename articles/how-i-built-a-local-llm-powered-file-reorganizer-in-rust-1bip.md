---
title: "How I Built a Local LLM-Powered File Reorganizer with Rust"
url: "https://dev.to/evgeniiperminov/how-i-built-a-local-llm-powered-file-reorganizer-in-rust-1bip"
author: "Evgenii Perminov"
category: "immutable-arch-rust-flink"
---
# How I Built a Local LLM-Powered File Reorganizer with Rust
**Author:** Evgenii Perminov  **Published:** February 19, 2025

## Overview
`messy-folder-reorganizer-ai`: a Rust CLI tool that queries a local LLM to propose organizational structures for chaotic file systems. Built to learn Rust while solving a real problem. Uses Ollama with deepseek-r1 for better instruction-following than llama3.2:1b.

## Key Concepts
- Local LLM via Ollama (privacy-preserving, no cloud)
- Rust CLI with configurable model endpoints and customizable prompts
- Confirmation prompts before executing file reorganization
- Context limitation challenge: beyond 100 files, model begins forgetting prompt beginning

Challenge with large directories:
- Model loses instruction compliance beyond ~100 files
- Increasing `num_ctx` provides only partial improvement
- Performance degrades significantly at scale

Proposed solutions:
- Batching requests into smaller chunks
- Per-chunk category assignment then merge

**Source:** https://github.com/PerminovEugene/messy-folder-reorganizer-ai
