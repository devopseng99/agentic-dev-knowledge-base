---
title: "I Built an AI Agent That Monitors the Internet for Buying Signals and Sends Personalized Emails"
url: "https://dev.to/srija_vuppala_295/i-built-an-ai-agent-that-monitors-the-internet-for-buying-signals-and-sends-personalized-emails--30dm"
author: "Srija Vuppala"
category: "ai-agent-email-automation"
---

# I Built an AI Agent That Monitors the Internet for Buying Signals and Sends Personalized Emails

**Author:** Srija Vuppala
**Published:** March 29, 2026

## Overview

An automated AI agent that identifies potential customers through internet signals and manages personalized outreach campaigns across six stages, controlled via a Discord bot.

## Key Concepts

### Six-Stage Pipeline

1. **Signal Monitoring** -- RSS feeds from Google News, PropTech publications, real estate sites
2. **Intent Classification** -- LLM analysis using Groq (Llama 3.3 70B) with batched processing
3. **Contact Discovery** -- Website identification and LinkedIn contact finding via DuckDuckGo
4. **Email Discovery** -- Three-step fallback: direct search (~15%), website scraping (~20%), pattern generation (~50%)
5. **Email Generation** -- AI-generated 4-email sequences personalized to buying signals
6. **Campaign Management** -- Discord bot with slash commands

### Project Structure

```
AI_AGENT/
├── main.py
├── scheduler.py
├── agents/
│   ├── signal_monitor.py
│   ├── intent_classifier.py
│   ├── contact_finder.py
│   ├── email_discovery.py
│   ├── email_generator.py
│   ├── email_sender.py
│   ├── excel_writer.py
│   ├── sheets_writer.py
│   ├── discord_alerts.py
│   └── discord_bot.py
└── utils/
    ├── database.py
    ├── ai_router.py
    └── rate_limiter.py
```

### Discord Bot Commands

- `/send` -- Send emails with enforced followup ordering
- `/leads` -- List all leads with email status
- `/status` -- Campaign dashboard with metrics
- `/preview` -- View email sequences
- `/check_replies` -- Scan Gmail for responses

### Key Optimization

"Batching LLM calls matters more than you think. Going from one API call per article to one call per 10 articles cut costs and latency dramatically."

### Performance Metrics

| Metric | Result |
|--------|--------|
| Signal relevance | ~70% |
| Contact discovery | ~65% |
| Email discovery | ~85% |
| Email generation | ~85% |
| Deduplication | 100% |
