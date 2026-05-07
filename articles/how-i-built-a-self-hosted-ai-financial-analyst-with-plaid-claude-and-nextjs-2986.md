---
title: "How I built a self-hosted AI financial analyst with Plaid, Claude, and Next.js"
url: "https://dev.to/mkash25/how-i-built-a-self-hosted-ai-financial-analyst-with-plaid-claude-and-nextjs-2986"
author: "mkash25"
category: "domain-agents"
---

# How I built a self-hosted AI financial analyst with Plaid, Claude, and Next.js
**Author:** mkash25
**Published:** March 9, 2026

## Overview
A self-hosted investment analysis system that fetches holdings via Plaid's investment API, enriches positions with technical indicators (RSI, MACD, Bollinger Bands) and fundamentals using yfinance, then submits enriched data to Claude for structured buy/sell/hold recommendations. Runs automatically three times weekly at $5/month.

## Key Concepts
The architecture comprises a Python backend pipeline and Next.js dashboard synced through Supabase. Token encryption uses PBKDF2+Fernet with separated salt storage. Scheduling employs macOS launchd for reliability across reboots. RLS controls database access between pipeline and authenticated dashboard users.

```python
# Plaid client initialization and holdings normalization
# Technical analysis via pandas_ta
# Structured JSON schema enforcement for Claude responses
```
