---
title: "Give Your AI Agent a Browser: Web Automation via API with IteraTools"
url: "https://dev.to/fredpsantos33/give-your-ai-agent-a-browser-web-automation-via-api-with-iteratools-4che"
author: "Fred Santos"
category: "browser-automation-ai-agent"
---

# Give Your AI Agent a Browser: Web Automation via API with IteraTools

**Author:** Fred Santos
**Published:** March 6, 2026

## Overview
Introduces IteraTools' `/browser/act` endpoint enabling AI agents to automate web interactions without managing local browser infrastructure, using a server-side Chromium instance.

## Key Concepts

### Supported Actions
- `navigate` - URL navigation
- `click` - Element selection and clicking
- `type` - Text input
- `press` - Keyboard commands
- `wait` / `waitForSelector` - Timing controls
- `extract` - Content retrieval
- `screenshot` - PNG capture
- `evaluate` - JavaScript execution
- `select` - Dropdown selection

Limits: 20 actions per request, 10 seconds per action.

### Python Example - Price Monitoring

```python
import requests

ITERATOOLS_KEY = "it-XXXX-XXXX-XXXX"

def check_price(product_url, price_selector):
    resp = requests.post(
        "https://api.iteratools.com/browser/act",
        headers={"Authorization": f"Bearer {ITERATOOLS_KEY}"},
        json={
            "actions": [
                {"type": "navigate", "url": product_url},
                {"type": "waitForSelector", "selector": price_selector},
                {"type": "extract", "selector": price_selector}
            ]
        }
    )
    data = resp.json()
    results = data.get("results", [])
    if results:
        return results[-1].get("text", "N/A")
    return None

price = check_price("https://amazon.com/dp/B09XYZ", ".a-price-whole")
print(f"Current price: ${price}")
```

### Curl Example

```bash
curl -X POST https://api.iteratools.com/browser/act \
  -H "Authorization: Bearer YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "actions": [
      { "type": "navigate", "url": "https://news.ycombinator.com" },
      { "type": "waitForSelector", "selector": ".titleline" },
      { "type": "evaluate",
        "script": "Array.from(document.querySelectorAll(\".titleline a\")).slice(0,5).map(a=>({title: a.textContent,url:a.href}))"
      }
    ]
  }'
```

### Pricing
$0.005 per session. Price monitoring running hourly costs approximately $3.60/month.
