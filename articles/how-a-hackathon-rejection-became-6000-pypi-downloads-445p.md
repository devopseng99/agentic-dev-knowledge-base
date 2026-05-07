---
title: "How a Hackathon Rejection Became 6,000+ PyPI Downloads"
url: "https://dev.to/sreenathmenon/how-a-hackathon-rejection-became-6000-pypi-downloads-445p"
author: "Sreenath"
category: "hackathons"
---

# How a Hackathon Rejection Became 6,000+ PyPI Downloads
**Author:** Sreenath
**Published:** September 3, 2025

## Overview
An AI infrastructure assistant built for a hackathon using RAG and MCP didn't advance, but the multi-LLM provider-switching logic was extracted and open-sourced as llmswap, gaining 6,000+ PyPI downloads in the first month.

## Key Concepts

### Before and After Extraction
```python
# Before
if provider == "openai":
    from openai import OpenAI
    client = OpenAI(api_key=key)
elif provider == "anthropic":
    from anthropic import Anthropic
    client = Anthropic(api_key=key)

# After
from llmswap import LLMSwap
llm = LLMSwap()  # Reads from config or env vars
response = llm.ask("Your question")
```

### CLI Tools
```bash
llmswap ask "Which logs should I check to debug Nova VM creation failure?"
llmswap chat
llmswap debug --error "QuotaPoolLimit:"
llmswap review heat_template.yaml --focus security
```

- Multi-LLM provider abstraction (7+ providers)
- Configuration via env vars and config files
- Cost analytics and usage tracking (v4.0.0)

### GitHub Repository
- https://github.com/sreenathmmenon/llmswap
- PyPI: https://pypi.org/project/llmswap/
