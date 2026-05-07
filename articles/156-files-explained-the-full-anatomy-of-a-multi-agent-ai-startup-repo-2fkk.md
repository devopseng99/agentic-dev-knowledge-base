---
title: "156 Files Explained: The Full Anatomy of a Multi-Agent AI Startup Repo"
url: "https://dev.to/whoffagents/156-files-explained-the-full-anatomy-of-a-multi-agent-ai-startup-repo-2fkk"
author: "Atlas Whoff"
category: "full-code-examples"
---

# 156 Files Explained: The Full Anatomy of a Multi-Agent AI Startup Repo
**Author:** Atlas Whoff
**Published:** April 16, 2026

## Overview
Deep dive into the structure of a multi-agent AI startup repository with 156 files, covering Flask dashboard, Remotion video pipeline, 111+ production scripts, and agent configuration.

## Key Concepts

### GitHub Repository
https://github.com/Wh0FF24/whoff-agents

### Top-Level Layout

```
whoff-automation/
├── atlas-ops/          # Flask dashboard + API orchestrator
├── atlas-reel-composer/# Remotion video pipeline
├── content/            # Drafts, specs, production log
├── scripts/            # 111+ production scripts
├── whoff-agents/       # Core agent config + .env
└── CLAUDE.md           # Global agent instructions
```

### The Scripts Directory (111 files)

**Publishing:**
- `post_to_linkedin.py` -- LinkedIn API publisher
- `upload_to_youtube.py` -- YouTube Data API with OAuth
- `devto_publish.py` -- dev.to two-step draft-to-publish pattern

**Content generation:**
- `generate_sleep_story.py` -- Claude API to 8-min story with timed SFX
- `generate_hook_card.py` -- 1.5s animated Remotion hook opener
- `create_short.py` -- Voxtral TTS to Pillow frames to ffmpeg pipeline

**Agent infrastructure:**
- `research_scout.py` -- HN/Reddit/GitHub trending intel
- `higgsfield_client.py` -- cinematic video generation API
- `muapi_client.py` -- music API for sleep story BGM
- `heygen_client.py` -- avatar video generation

**Revenue:**
- `stripe_webhook_handler.py` -- checkout to digital delivery in 30s
- `send_delivery_email.py` -- Resend API with download link

### The content Directory (Structured Memory)

```
content/
├── drafts/YYYY-MM-DD/   # Article drafts by date
├── specs/YYYY-MM-DD/    # Content specs (JSON)
└── production-log.md    # Daily ship log
```

Every content piece begins as a JSON specification defining format, platform, hook, CTA, and linked assets. Scripts consume specs and generate output.

### The CLAUDE.md (Global Agent Brain)

Injected into every Claude Code session, contains vault location, agent roster and model assignments, hard rules, and skill trigger map. Reduces per-session context from 2,000 to 200 tokens.

### Architecture Pattern
Data flow not file type: Specs (intent) -> Scripts (execution) -> Content (output). Agents write to vault; dashboard reads via SSE for live rendering.
