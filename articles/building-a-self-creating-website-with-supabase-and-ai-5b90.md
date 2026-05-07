---
title: "Building a self-creating website with Supabase and AI"
url: "https://dev.to/laznic/building-a-self-creating-website-with-supabase-and-ai-5b90"
author: "Niklas Lepisto"
category: "ai-agent-supabase"
---

# Building a self-creating website with Supabase and AI

**Author:** Niklas Lepisto
**Published:** April 23, 2024

## Overview

A hackathon project called "Echoes of Creation" that automatically generates and regenerates website content hourly using AI. The site tells the story of an artist navigating a world influenced by artificial intelligence.

## Key Concepts

### Tech Stack

- **Supabase** (Edge Functions, Storage, Webhooks, Database Triggers, pg_cron)
- **Astro** (framework)
- **Unreal Speech** (text-to-speech)
- **Stable Diffusion** (image generation via Replicate)
- **Metropolitan Museum of Art API** (artwork sourcing)

### Architecture

Three database tables:
- `thoughts` -- narrative segments representing the creative process
- `artwork` -- generated and curated images
- `thought_texts` -- story text with associated audio files

A scheduled job triggers hourly, inserting new records that activate Webhooks calling Edge Functions to generate assets.

### Artwork Generation Process

1. Fetch European paintings from Met Museum's public collection (department ID 11)
2. Validate images exist
3. Use LLaVa vision model to describe the main painting
4. Feed description as prompt to Stable Diffusion 3's image-to-image mode
5. Create eight variants with randomized strength parameters (0.4-0.7)

### Implementation

Two primary Supabase Edge Functions handle generation:
1. **generate** -- Creates artwork and variants
2. **create-speech** -- Produces narrative text and audio

The implementation leverages Deno runtime with TypeScript, managing asynchronous operations across multiple AI services and file storage operations.
