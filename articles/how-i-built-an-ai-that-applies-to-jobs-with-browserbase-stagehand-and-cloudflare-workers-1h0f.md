---
title: "How I Built an AI That Applies to Jobs with Browserbase, Stagehand, and Cloudflare Workers"
url: "https://dev.to/whateverneveranywhere/how-i-built-an-ai-that-applies-to-jobs-with-browserbase-stagehand-and-cloudflare-workers-1h0f"
author: "Ava Bagherzadeh"
category: "ai-agent-cloudflare-workers"
---

# How I Built an AI That Applies to Jobs with Browserbase, Stagehand, and Cloudflare Workers

**Author:** Ava Bagherzadeh
**Published:** April 20, 2026

## Overview
AI Applyd automates job applications using Cloudflare Workers, Browserbase + Stagehand for browser automation, and LLMs for resume tailoring. Analyzes job descriptions, scores resumes with cosine similarity, rewrites bullets with missing keywords, then submits via real headless browser sessions. Cost: ~$25 per 1,000 applications.

## Key Concepts

### Architecture
- Runtime: Cloudflare Workers
- Database: Cloudflare D1 with Drizzle ORM
- Storage: Cloudflare R2
- Browser: Browserbase + Stagehand (LLM-driven, not DOM-based)
- AI: Gemini 2.5 Flash Lite for analysis, Anthropic Claude for browser operations
- Frontend: TanStack Start + Tailwind + shadcn/ui

### Three Core Functions
1. **Job Description Analysis:** Extracts required skills, tech keywords, soft skills
2. **Resume Scoring:** Cosine similarity on embedded skill graphs + exact-match for must-haves
3. **Tailoring and Application:** Rewrites resume bullets, submits via browser sessions

### Operational Details
- Token reservations use atomic batch operations via D1
- Failed submissions receive refunds with 3 retry attempts
- Job scraping uses Cloudflare Queues with 12-hour refresh cycles
- Login-required platforms use stored user credentials
