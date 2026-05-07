---
title: "Using Cloudflare AI Gateway Proxy"
url: "https://dev.to/uetuluk/using-cloudflare-ai-gateway-proxy-4n1k"
author: "Utku Ege Tuluk"
category: "cloudflare-ai-gateway"
---

# Using Cloudflare AI Gateway Proxy
**Author:** Utku Ege Tuluk
**Published:** November 11, 2024

## Overview
Plug-and-play approach to leveraging Cloudflare's AI Gateway proxy for improved usage insights with minimal code changes.

## Key Concepts

```python
import os
account_id = os.getenv('ACCOUNT_ID')
gateway_id = os.getenv('GATEWAY_ID')
base_url = f"https://gateway.ai.cloudflare.com/v1/{account_id}/{gateway_id}/openai"

from openai import OpenAI
client = OpenAI(base_url=base_url)
```

Simply create an AI Gateway in the Cloudflare Dashboard, set environment variables for account and gateway IDs, and point the OpenAI client to the gateway URL.
