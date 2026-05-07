---
title: "How to use Midjourney API by Python"
url: "https://dev.to/ttapi/how-to-use-midjourney-api-by-python-1i3a"
author: "Luke"
category: "ai-media-generation"
---
# How to use Midjourney API by Python
**Author:** Luke  **Published:** May 31, 2024

## Overview
The article explains how to integrate Midjourney's AI image generation capabilities into applications using the TTAPI platform, since Midjourney does not provide direct API services. TTAPI serves as an intermediary solution offering access to Midjourney features through Python.

## Key Concepts
- TTAPI platform as alternative to direct Midjourney API access
- Imagine, U, V, zoom, pan, vary, blend, and describe functionalities
- Command support (--v, --cref, --ar parameters)
- Webhook callbacks and status querying
- Free quota: 30 credits for 10 imagine requests

```python
import requests

endpoint = "https://api.ttapi.io/midjourney/v1/imagine"
headers = {"TT-API-KEY": your_key}
data = {"prompt": "a cute cat", "mode": "fast", "hookUrl": "", "timeout": 300}
response = requests.post(endpoint, headers=headers, json=data)
print(response.status_code)
print(response.json())
```

```python
import requests
endpoint = "https://api.ttapi.io/midjourney/v1/fetch"
headers = {"TT-API-KEY": your_key}
data = {"jobId": "afa774a3-1aee-5aba-4510-14818d6875e4"}
response = requests.post(endpoint, headers=headers, json=data)
print(response.status_code)
print(response.json())
```
