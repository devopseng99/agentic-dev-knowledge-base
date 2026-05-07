---
title: "Pixelmuse CLI Guide: AI Image Generation From Your Terminal"
url: "https://dev.to/starmorph/pixelmuse-cli-guide-ai-image-generation-from-your-terminal-3dn2"
author: "starmorph"
category: "ai-image-video-generation"
---
# Pixelmuse CLI Guide: AI Image Generation From Your Terminal
**Author:** starmorph  **Published:** 2026-03-20

## Overview
Guide to using Pixelmuse CLI tool for AI image generation directly from the terminal, enabling developers to integrate image generation into shell scripts, CI/CD pipelines, and automated workflows.

## Key Concepts

### Why Terminal-Based Image Generation
- Scriptable: integrate into existing shell workflows
- No browser required: perfect for server environments
- Batch processing: generate many images with loop scripts
- CI/CD integration: auto-generate assets during build pipelines

### Installation

```bash
npm install -g pixelmuse-cli
# or
pip install pixelmuse
```

### Basic Usage

```bash
# Simple text-to-image
pixelmuse generate "a red fox running through a snowy forest" --output fox.png

# Specify model and size
pixelmuse generate "professional product photo" \
  --model flux-1.1-pro \
  --size 1024x1024 \
  --quality high \
  --output product.png

# With negative prompt
pixelmuse generate "mountain landscape at sunset" \
  --negative "blurry, low quality, cartoon" \
  --output landscape.png
```

### Batch Generation

```bash
#!/bin/bash
# Generate product images for catalog
products=("wireless headphones" "smart watch" "laptop stand" "mechanical keyboard")

for product in "${products[@]}"; do
  slug=$(echo "$product" | tr ' ' '-')
  pixelmuse generate "professional product photo of $product, white background" \
    --output "catalog/${slug}.png" \
    --model sdxl
  echo "Generated: $slug"
done
```

### Pipeline Integration

```bash
# Generate blog hero image as part of build
generate_hero() {
  local title="$1"
  pixelmuse generate "tech blog hero image about: $title, modern, abstract, dark theme" \
    --size 1200x630 \
    --output "public/images/hero.png"
}

# In CI/CD
generate_hero "$(cat _posts/latest.md | head -1 | sed 's/# //')"
```

### API Key Configuration

```bash
export PIXELMUSE_API_KEY="your-key-here"
# or store in ~/.pixelmuserc
pixelmuse config set api_key YOUR_KEY
```

### Key Features
- Multiple model support (Flux, SDXL, DALL-E, Stable Diffusion)
- Batch processing with JSON input files
- Progress indicators for long-running generations
- Output format control (PNG, JPEG, WebP)
- Resolution and aspect ratio presets for common platforms (social, web, print)
