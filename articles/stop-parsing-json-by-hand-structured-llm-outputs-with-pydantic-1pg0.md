---
title: "Stop Parsing JSON by Hand: Structured LLM Outputs With Pydantic"
url: "https://dev.to/klement_gunndu/stop-parsing-json-by-hand-structured-llm-outputs-with-pydantic-1pg0"
author: "klement Gunndu"
category: "llm-structured-output"
---

# Stop Parsing JSON by Hand: Structured LLM Outputs With Pydantic

**Author:** klement Gunndu
**Published:** February 28, 2026

## Overview
Argues that making every LLM call return a Pydantic model instead of raw text eliminated the most bugs in production. Covers four approaches across major providers plus Instructor library.

## Key Concepts

### Four Approaches
1. **OpenAI SDK:** `client.chat.completions.parse()` with `response_format=CalendarEvent`
2. **Anthropic SDK:** `client.messages.parse()` with `output_format` parameter
3. **Instructor Library:** Provider-agnostic wrapper with automatic retries
4. **LangChain:** `with_structured_output()` with fallback to tool-calling

### Pydantic Best Practices
- Use `Field(description=...)` extensively
- Leverage `Literal` types for constrained choices
- Use nested models for complex structures
- Make appropriate fields optional to avoid hallucinations

### Production Insight
The team runs 80+ AI agents in production where every LLM call uses Pydantic models for input/output schemas, eliminating regex parsing entirely.
