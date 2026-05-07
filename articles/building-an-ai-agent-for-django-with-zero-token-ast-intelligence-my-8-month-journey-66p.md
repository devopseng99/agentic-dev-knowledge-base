---
title: "Building an AI Agent for Django with Zero-Token AST Intelligence: My 8-Month Journey"
url: "https://dev.to/vebgen/building-an-ai-agent-for-django-with-zero-token-ast-intelligence-my-8-month-journey-66p"
author: "VebGen Official (Ramesh)"
category: "ai-agent-django"
---

# Building an AI Agent for Django with Zero-Token AST Intelligence: My 8-Month Journey

**Author:** VebGen Official (Ramesh)
**Published:** October 20, 2025

## Overview
Documents the creation of VebGen, an AI agent designed for Django development that operates on free-tier APIs. Uses Python's AST (Abstract Syntax Tree) module for local code analysis consuming zero API tokens, then intelligently identifies relevant files before sending them to the LLM.

## Key Concepts

### Core Innovation
Rather than sending entire codebases to language models, VebGen uses Python's AST module to understand Django code locally without consuming any API tokens. The system intelligently identifies relevant files before sending them to the LLM, dramatically reducing token usage.

### Dual-Agent Architecture
- **TARS:** Handles planning and feature decomposition
- **CASE:** Manages code implementation and self-healing capabilities

### Features
- Multi-tier patching with three fallback methods
- Comprehensive security measures
- Rolling backups
- Django code review functionality

### Statistics
- 500KB of Python code
- 319 tests with 99.7% pass rate
- 95+ Django constructs supported
- Development cost: $0

## Installation
```bash
git clone https://github.com/vebgenofficial/vebgen.git
cd vebgen
pip install -e .
vebgen
```

Requirements: Python 3.10+ and a free API key.
