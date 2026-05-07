---
title: "I Built a GitHub Action That Uses AI to Explain Why Your CI Failed"
url: "https://dev.to/filip_galic_ea8cda420d800/i-built-a-github-action-that-uses-ai-to-explain-why-your-ci-failed-1ln"
author: "Filip Galic"
category: "ai-agent-github-actions-ci"
---

# I Built a GitHub Action That Uses AI to Explain Why Your CI Failed

**Author:** Filip Galic
**Published:** January 9, 2026

## Overview
CI Failure Summarizer uses Claude AI to analyze failed CI pipeline logs and deliver summaries via Slack with root cause, error messages, and suggested fixes. Cost: ~$0.01 per failure (~$1/month for 100 failures).

## Key Concepts

### How It Works
1. Retrieves logs from failed jobs
2. Sends them to Claude for analysis
3. Posts Slack summaries with root cause and suggested fixes

### Direct Notifications
Identifies committers via GitHub email and sends direct Slack messages rather than channel posts.

### Development
Built entirely using Claude Code in approximately one hour, handling GitHub Actions setup, Slack API integration, log parsing, and documentation.

**Repository:** https://github.com/galion96/ci-failure-sumarizer
