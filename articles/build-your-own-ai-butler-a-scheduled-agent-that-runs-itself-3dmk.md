---
title: "Build Your Own AI Butler - A Scheduled Agent That Runs Itself!"
url: "https://dev.to/aws/build-your-own-ai-butler-a-scheduled-agent-that-runs-itself-3dmk"
author: "Erik Hanchett"
category: "aws-agents"
---

# Build Your Own AI Butler - A Scheduled Agent That Runs Itself!
**Author:** Erik Hanchett
**Published:** May 6, 2026

## Overview
Autonomous AI agent "The Pulse" that monitors Hacker News and Reddit for tech news, delivering daily digests via Telegram. Uses EventBridge Scheduler + Lambda + AgentCore harness with managed browser and persistent storage.

## Key Concepts

### Architecture
- EventBridge Scheduler triggers Lambda hourly
- Lambda invokes AgentCore harness with stable session IDs
- Agent uses managed Chrome browser for web scraping
- Persistent `/mnt/data` storage accumulates hourly snapshots
- Every 6th run generates markdown digests
- Telegram integration delivers summaries

### Why AgentCore Over Lambda Alone
- Managed browser capabilities
- Persistent filesystem across invocations
- Extended timeout windows (vs Lambda 15-min max)
- Built-in memory services for conversational context

### Scheduling Logic
Hourly collection runs vs 6-hourly summary digest generation through modulo arithmetic on UTC hour. Lambda determines run type and adjusts prompt accordingly.
