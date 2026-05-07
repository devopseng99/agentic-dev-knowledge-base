---
title: "Outpaint — extend any image beyond its borders"
url: "https://dev.to/om_prakash_3311f8a4576605/outpaint-extend-any-image-beyond-its-borders-4e52"
author: "Om Prakash"
category: "ai-image-video-generation"
---
# Outpaint — extend any image beyond its borders
**Author:** Om Prakash  **Published:** 2026-05-04

## Overview
Introduces an `outpaint` API endpoint that extends the canvas in any direction without cropping the subject, without watermarks, by adding pixels around image borders while preserving original content exactly.

## Key Concepts

### Technical Specifications

**Request Parameters:**
- `image_url`: Public image source (required)
- `direction`: One of `all`, `left`, `right`, `top`, `bottom` (defaults to `all`)
- `extend_pixels`: Integer 64-512 per side (defaults 256)
- `prompt`: Optional text guidance, max 500 characters

**Key Features:**
- Synchronous processing (response in same HTTP call, no job queues)
- No watermarks
- Preserves original pixels exactly
- Self-hosted infrastructure with flat pricing

### Pricing
19 credits per call — ₹0.013 per call / $0.00015 per call. 1,000 calls ≈ ₹13 or $0.15.

### Use Cases
1. Converting portrait product shots to landscape banners without cropping
2. Adding room context around furniture cutouts for marketplace listings
3. Re-framing square photos to 16:9 format for YouTube thumbnails

```bash
curl -X POST https://api.pixelapi.dev/v1/image/outpaint \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"image_url": "https://example.com/source.jpg", "direction": "all", "extend_pixels": 256}'
```

```python
import requests

resp = requests.post(
    "https://api.pixelapi.dev/v1/image/outpaint",
    headers={
        "Authorization": "Bearer YOUR_API_KEY",
        "Content-Type": "application/json",
    },
    json={
        "image_url": "https://example.com/source.jpg",
        "direction": "all",
        "extend_pixels": 256,
    },
    timeout=60,
)

resp.raise_for_status()
result = resp.json()
print(result)
```

### References
- Dashboard: https://pixelapi.dev/dashboard
- Documentation: https://pixelapi.dev/docs
- Original publication: https://pixelapi.dev/blog/outpaint-launch.html
