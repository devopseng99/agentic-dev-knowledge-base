---
title: "I Mistook gpt-oss for an Image Generator. Now My Mac Runs FLUX Offline."
url: "https://dev.to/vineethnkrishnan/i-mistook-gpt-oss-for-an-image-generator-now-my-mac-runs-flux-offline-ejk"
author: "Vineeth N Krishnan"
category: "ai-image-video-generation"
---
# I Mistook gpt-oss for an Image Generator. Now My Mac Runs FLUX Offline.
**Author:** Vineeth N Krishnan  **Published:** 2026-04-25

## Overview
After discovering gpt-oss is text-only, the author set up FLUX.1-schnell running locally on a Mac via Draw Things app with an HTTP API wrapper exposing the Stable Diffusion WebUI-compatible endpoint.

## Key Concepts

### Why Draw Things Over ComfyUI
"ComfyUI on Mac means Python environments, model downloads, a queue server, custom workflow JSON." Draw Things is a free Mac App Store native application with built-in model management.

### Installation & Setup
1. Install Draw Things from Mac App Store (developer: Draw Things, Inc.)
2. Select FLUX.1 [schnell] model (4-step distilled, Apache 2.0 licensed)
3. Generate test image through GUI
4. Enable HTTP API server: Settings > Advanced > Protocol: HTTP, Port: 7860, IP: 127.0.0.1

### API Implementation
Draw Things exposes a Stable Diffusion WebUI-compatible endpoint at `/sdapi/v1/txt2img`. Response returns base64-encoded PNG data.

```bash
curl -s -X POST http://127.0.0.1:7860/sdapi/v1/txt2img \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "a red apple on a wooden table",
    "steps": 4,
    "width": 512,
    "height": 512,
    "cfg_scale": 1.0
  }'
```

```bash
# Full pipeline (prompt to file)
curl -s -X POST http://127.0.0.1:7860/sdapi/v1/txt2img \
  -H "Content-Type: application/json" \
  -d '{"prompt":"a red apple","steps":4,"width":512,"height":512,"cfg_scale":1.0}' \
  | jq -r '.images[0]' | base64 -d > /tmp/apple.png && open /tmp/apple.png
```

```bash
# Shell function wrapper
dt-gen() {
  local prompt="$1"
  local out="${2:-/tmp/dt-$(date +%s).png}"
  curl -s -X POST http://127.0.0.1:7860/sdapi/v1/txt2img \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg p "$prompt" \
      '{prompt:$p, steps:4, width:1024, height:1024, cfg_scale:1.0}')" \
    | jq -r '.images[0]' | base64 -d > "$out" && open "$out"
}

# Blog hero image variant (1200x630)
dt-hero() {
  local prompt="$1"
  local out="${2:-/tmp/hero-$(date +%s).png}"
  curl -s -X POST http://127.0.0.1:7860/sdapi/v1/txt2img \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg p "$prompt" \
      '{prompt:$p, steps:4, width:1200, height:630, cfg_scale:1.0}')" \
    | jq -r '.images[0]' | base64 -d > "$out" && open "$out"
}
```

### Performance Metrics

| Resolution | Steps | Local Mac Time | Cloud (Pollinations) |
|-----------|-------|-----------------|-------------------|
| 512×512   | 4     | ~40s            | ~6s               |
| 768×768   | 4     | ~75s            | ~7s               |
| 1024×1024 | 4     | ~110s           | ~8s               |
| 1200×630  | 4     | 90-150s         | ~8s               |

### Critical Parameters for FLUX.1-schnell
- **steps: 4** — Optimal; higher values don't improve quality
- **cfg_scale: 1.0** — Correct for schnell; higher values produce oversaturated output
- **Dimensions** — Must be multiples of 64 pixels

### Troubleshooting
- 404 on `/sdapi/v1/sd-models`: endpoint not implemented; use actual `/txt2img`
- Protocol errors: confirm Protocol is set to HTTP, not gRPC
- Image quality problems: verify `cfg_scale: 1.0` and `steps: 4`

### Key Limitations
- Draw Things must remain open; no background daemon mode
- API uses whichever model is currently loaded in GUI
- Significant latency vs. cloud (90+ seconds vs. 8 seconds)

### Philosophy
"Local does not always mean better." Local suits ad-hoc, offline, and batch scenarios; cloud remains preferable for iterative work requiring speed.
