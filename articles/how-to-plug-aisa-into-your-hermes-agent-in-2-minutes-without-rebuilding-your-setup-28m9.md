---
title: "How to Plug AIsa into your Hermes Agent in 2 Minutes (Without Rebuilding Your Setup)"
url: "https://dev.to/0xfemyn/how-to-plug-aisa-into-your-hermes-agent-in-2-minutes-without-rebuilding-your-setup-28m9"
author: "Femi Raphael"
category: "a2a-protocols"
---

# How to Plug AIsa into your Hermes Agent in 2 Minutes
**Author:** Femi Raphael
**Published:** April 9, 2026

## Overview
How to integrate AIsa, an OpenAI-compatible API layer, with Hermes agents to simplify model switching without restructuring your setup.

## Key Concepts

AIsa provides a single OpenAI-compatible base URL that gives unified access to multiple AI models.

### Config File Approach

Edit `~/.hermes/config.yaml`:
```yaml
model:
  provider: custom
  base_url: https://api.aisa.one/v1
  api_key: YOUR_AISA_API_KEY
  default: YOUR_MODEL_NAME
```

### CLI Approach
1. Run `hermes model` in terminal
2. Select "Custom endpoint"
3. Enter base URL and credentials
4. Choose desired model

Caution: Avoid using Hermes' fallback provider chains due to reported bugs on the API server path.
