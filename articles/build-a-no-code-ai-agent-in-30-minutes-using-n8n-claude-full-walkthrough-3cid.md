---
title: "Build a No-Code AI Agent in 30 Minutes Using n8n + Claude"
url: https://dev.to/dextralabs/build-a-no-code-ai-agent-in-30-minutes-using-n8n-claude-full-walkthrough-3cid
author: Dextra Labs
category: n8n-agents
---

# Build a No-Code AI Agent in 30 Minutes Using n8n + Claude

**Author:** Dextra Labs
**Published:** April 21, 2026

## Overview

This tutorial demonstrates creating an automated Slack digest agent without coding. The workflow monitors a Slack channel, identifies meaningful conversation threads, summarizes them using Claude AI, and posts daily digests at 5pm.

## Prerequisites

- n8n (cloud or self-hosted via Docker)
- Anthropic API key
- Slack workspace with appropriate permissions
- 30 minutes

## Workflow Steps

### Step 1: Launch n8n
Self-hosted users run Docker; cloud users access n8n.io directly.

### Step 2-3: Create Workflow & Schedule Trigger
Set up a daily trigger at 5pm using the Schedule Trigger node configured for:
- Interval: Days
- Frequency: 1 day
- Time: 17:00

### Step 4: Slack Message Retrieval
Add a Slack "Get Many Messages" node with OAuth2 credentials and configure:
- Limit: 100 messages
- Oldest: `{{ $now.startOf('day').toISO() }}` (retrieves today's messages only)

### Step 5: Thread Filtering
An IF node filters threads by reply count: `reply_count > 2` captures substantive conversations while eliminating noise.

### Step 6: Fetch Complete Threads
A Slack "Get Replies" node retrieves full thread content using: `{{ $json.ts }}`

### Step 7: Format Data
JavaScript code node structures threads for Claude processing:

```javascript
const threadText = messages.map(message => {
  const data = message.json;
  const user = data.user || 'Unknown';
  const text = data.text || '';
  const timestamp = new Date(data.ts * 1000)
    .toLocaleTimeString('en-US', {
      hour: '2-digit',
      minute: '2-digit'
    });
  return `[${timestamp}] ${user}: ${text}`;
}).join('\n');
```

### Step 8: Claude Summarization
HTTP Request node calls Anthropic API with:
- Endpoint: `https://api.anthropic.com/v1/messages`
- Model: claude-sonnet-4-5
- Max tokens: 500
- Prompt: "Summarise this Slack thread in 3-5 bullet points. Focus on decisions made, questions raised and action items. Be concise."

### Step 9: Extract Response
JavaScript extracts Claude's summary from the API response object.

### Step 10-11: Aggregate & Post
A Merge node combines all summaries; final formatting code creates the digest message posted back to Slack.

## Key Customizations

- **Adjust filtering:** Modify `reply_count` threshold based on channel volume
- **Add classification:** Route summaries through Claude again for Decision/Question/FYI labels
- **Multi-channel support:** Duplicate the fetch-and-filter steps for multiple channels
- **On-demand triggering:** Replace schedule with webhook for slash command activation

## Architecture Summary

Schedule -> Slack Fetch -> Filter Threads -> Get Replies -> Format -> Claude API -> Extract -> Merge -> Format Digest -> Slack Post

**Ten nodes total. No custom code required (except minor formatting helpers).**
