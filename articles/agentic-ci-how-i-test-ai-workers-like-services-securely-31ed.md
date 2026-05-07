---
title: "Agentic CI: How I Test AI Workers Like Services (Securely)"
url: "https://dev.to/kowshik_jallipalli_a7e0a5/agentic-ci-how-i-test-ai-workers-like-services-securely-31ed"
author: "Kowshik Jallipalli"
category: "ai-agent-unit-testing"
---

# Agentic CI: How I Test AI Workers Like Services (Securely)

**Author:** Kowshik Jallipalli
**Published:** March 4, 2026

## Overview
Addresses CI Poisoning risk — when LLM-generated code containing hallucinated malicious commands runs in CI environments. The solution treats agents as untrusted services requiring rigorous automated gating.

## Key Concepts

### Four Security Gates
1. **Syntax Validation** - Parse output into Abstract Syntax Trees
2. **Static Security Analysis** - Block forbidden imports (os, sys, subprocess)
3. **Structural Invariants** - Verify critical code patterns remain intact
4. **Dynamic Execution** - Only run agent-generated tests after static checks pass

### Security Measures
- GitHub Actions strips all write permissions from runner tokens
- Fixture data is sanitized to prevent secret leakage
- Containerized execution with Docker for complete isolation

### Advanced Strategies
- Secondary LLMs as judges for qualitative metrics
- Adversarial injection testing
- Exponential backoff for LLM API retries
