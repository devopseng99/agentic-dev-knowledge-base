---
title: "Why Claude's Custom Connector Failed on Cloudflare (and How I Fixed It)"
url: "https://dev.to/kiyoe/why-claudes-custom-connector-failed-on-cloudflare-and-how-i-fixed-it-k62"
author: "kiyo-e"
category: "a2a-protocols"
---

# Why Claude's Custom Connector Failed on Cloudflare
**Author:** kiyo-e
**Published:** December 18, 2025

## Overview
Debugging a custom connector API on Cloudflare Workers that worked with ChatGPT but failed with Claude due to Cloudflare's "Block AI Bots" security feature.

## Key Concepts

### Root Cause
Cloudflare's "Block AI Bots" in Security > Bots was blocking Claude while allowing ChatGPT.

### Solution
Disable bot-blocking: Security > Bots > "Block AI Bots" from "Block on all pages" to "Off."

### Debugging Insight
Testing with Cloudflare's default `*.workers.dev` URL succeeded, indicating domain-specific bot blocking rather than application error.

### Key Takeaway
Different AI services are treated distinctly by Cloudflare bot detection. This can interfere with legitimate API integrations designed for AI tools.
