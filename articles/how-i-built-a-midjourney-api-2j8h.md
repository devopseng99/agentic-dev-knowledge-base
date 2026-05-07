---
title: "How I built a Midjourney API"
url: "https://dev.to/suede/how-i-built-a-midjourney-api-2j8h"
author: "Yuval"
category: "ai-media-generation"
---
# How I built a Midjourney API
**Author:** Yuval  **Published:** May 29, 2023

## Overview
This technical piece explains the architecture behind creating an unofficial API layer for Midjourney, an AI image generation tool that operates within Discord. The author emphasizes this is "not an API for production" but rather an educational exploration of how such a system could work conceptually.

## Key Concepts

- **Discord Bot Integration:** Creating a bot to listen to Midjourney channels and relay commands
- **Token Authentication:** Using account credentials to establish connections with the Midjourney platform
- **Image Processing Pipeline:** Handling grid-structured outputs, cropping individual images, and storing results
- **Cloud Hosting:** Leveraging AWS S3 for scalable image storage
- **Asynchronous Workflows:** Managing when images are ready and ensuring result attribution

```python
def get_result_from_midjourney():
    '''
    Get request for getting the result of post request
    '''
    get_url = "<your api url>"
    get_payload = {}
    get_headers = {
        'Authorization': some_key,
        'Content-Type': 'application/json',
        'Cookie': '<my cookie here>'
    }
    get_response = requests.request(
        "GET", get_url, headers=get_headers, data=get_payload
    )
    return get_response
```

Notable Challenges:
1. Determining when image generation completes
2. Handling grid-to-individual image cropping
3. Matching results to specific user requests
4. Scaling for concurrent operations
