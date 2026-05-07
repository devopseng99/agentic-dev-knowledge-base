---
title: "Complete Beginner's Guide to use Midjourney API to Create AI Images with Python"
url: "https://dev.to/imaginepro/complete-beginners-guide-to-use-midjourney-api-to-create-ai-images-with-python-346l"
author: "ImaginePro"
category: "ai-media-generation"
---
# Complete Beginner's Guide to use Midjourney API to Create AI Images with Python
**Author:** ImaginePro  **Published:** August 8, 2025

## Overview
This guide teaches Python beginners how to generate AI images using ImaginePro's unofficial API for Midjourney, covering installation, core features, and practical workflows.

## Key Concepts

- **Midjourney**: Powerful AI image generation platform
- **ImaginePro SDK**: Unofficial Python bridge to Midjourney capabilities
- **Polling mechanism**: Automatic status checking until image generation completes
- **Core operations**: Image generation, upscaling, variants, regeneration, and inpainting
- **Webhook integration**: Real-time notifications for production applications

```python
pip install imaginepro
```

```python
from imaginepro import ImagineProSDK, ImagineProSDKOptions

sdk = ImagineProSDK(ImagineProSDKOptions(
    api_key="your-api-key-here",
    base_url="https://api.imaginepro.ai",
    default_timeout=300,
    fetch_interval=2,
))

result = sdk.imagine({
    "prompt": "a cute cat playing with a ball of yarn in a sunny garden --ar 16:9 --v 6"
})

final_result = sdk.fetch_message(result["messageId"])
```

```python
while True:
    status = sdk.fetch_message_once(message_id)
    print(f"Status: {status['status']}, Progress: {status['progress']}%")
    if status['status'] == 'DONE':
        break
    time.sleep(2)
```

```python
upscale_result = sdk.upscale({
    "message_id": "your-message-id",
    "index": 1
})
```

- GitHub: https://github.com/imaginpro/imaginepro-python-sdk
