---
title: "Building Smarter AI Agents with Schema-Guided Reasoning"
url: "https://dev.to/bigdata5911/building-smarter-ai-agents-with-schema-guided-reasoning-m3n"
author: "Joshua"
category: "ai-agents"
---

# Building Smarter AI Agents with Schema-Guided Reasoning

**Author:** Joshua
**Date Published:** November 7, 2025
**Tags:** #systemdesign #agents #ai #opensource

---

## Overview

This article introduces Schema-Guided Reasoning (SGR), a demonstration project showing how AI agents can reason, plan, and execute actions using structured logic and validated schemas rather than free-form text responses.

**Repository:** [bigdata5911/schema-guided-reasoning](https://github.com/bigdata5911/schema-guided-reasoning)

---

## What is Schema-Guided Reasoning?

SGR constrains AI outputs through a schema blueprint, enabling agents to plan steps, select tools, and execute actions safely. The demo operates within an in-memory CRM system where agents can:

- Look up customers and products
- Issue or void invoices
- Send emails
- Apply business rules

---

## Two Implementation Options

### 1. OpenAI API Version (schema-guided-reasoning.py)

Uses `gpt-4o` with cloud-based processing.

**Installation:**
```bash
pip install pydantic annotated-types rich openai requests
```

**Setup:**
```bash
$env:OPENAI_API_KEY = "YOUR_API_KEY"
python schema-guided-reasoning.py
```

### 2. Local llama.cpp Version (sgr_assistant.py)

Runs offline using Qwen3-4B model via HTTP server.

**Server startup:**
```bash
./llama-server \
  -m /path/to/Qwen3-4B-Instruct-2507-Q8_0.gguf \
  -ngl 999 \
  --port 12345 \
  --threads -1 \
  --ctx-size 20000
```

**Execute:**
```bash
python sgr_assistant.py
```

---

## Core Architecture

Both versions share:

- **In-memory database** with mock customer, product, and invoice data
- **Pydantic schema definitions** for tools (SendEmail, IssueInvoice, GetCustomerData)
- **Dispatcher** simulating tool execution
- **Task list** processed sequentially

---

## Key Advantages

Traditional AI agents often lack predictability; formatting issues cascade into failures. SGR enforces strict JSON schema validation before execution, resulting in:

- Fewer hallucinations
- Transparent reasoning steps
- Deterministic execution
- Easier debugging and inspection

---

## Customization Options

Users can modify:
- Task lists for new functionalities
- Tool definitions using Pydantic models
- System prompts for different rules or products

---

## Practical Tips

- Verify all dependencies: `pip install pydantic annotated-types rich openai requests`
- Confirm API key validity for cloud version
- Ensure llama.cpp server accessibility for local version
- Adjust temperature or cleanup logic if JSON validation fails

---

## Key Takeaway

"Instead of 'guessing' what the next step is, the model is guided by schemas, validated by code" — representing a shift toward structured, dependable AI agents rather than conversational assistants.
