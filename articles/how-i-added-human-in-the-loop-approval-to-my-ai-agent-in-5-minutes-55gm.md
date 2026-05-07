---
title: "How I Added Human-in-the-Loop Approval to My AI Agent in 5 Minutes"
url: "https://dev.to/jxrdancrane/how-i-added-human-in-the-loop-approval-to-my-ai-agent-in-5-minutes-55gm"
author: "jxrdancrane"
category: "human-in-the-loop"
---

# How I Added Human-in-the-Loop Approval to My AI Agent in 5 Minutes

**Author:** jxrdancrane
**Published:** February 28, 2026
**Tags:** #ai #agents #devtools

---

## Overview

The article describes a solution called Queuelo, an approval layer that enables developers to add human oversight to AI agent actions before they execute real-world operations like sending emails, creating tickets, or deploying code.

## The Problem

The author identified a critical gap in autonomous AI agents: they execute actions without understanding consequences. As stated: "The agent doesn't know the difference between a test environment and production" or that a command might trigger thousands of unintended actions.

## How Queuelo Works

### Submission Process

Agents POST requests to Queuelo's API instead of acting directly:

```bash
curl -X POST https://queuelo.com/api/actions \
-H "Authorization: Bearer YOUR_API_KEY" \
-H "Content-Type: application/json" \
-d '{
  "action_type": "send_email",
  "summary": "Send follow-up to 3,000 leads",
  "risk_level": "high",
  "payload": { "template": "follow_up_v2", "count": 3000 },
  "callback_url": "https://your-agent.com/webhook"
}'
```

### Status Check

```bash
curl https://queuelo.com/api/actions/abc123 \
-H "Authorization: Bearer YOUR_API_KEY"
```

## Key Features

- Instant email notifications with full payload details
- Risk level categorization (low/medium/high/critical)
- Complete audit trails with immutable records
- Webhook callbacks with exponential backoff retries
- Team collaboration with role-based approval assignments

## Key Takeaway

The author emphasizes: "Low risk, reversible actions? Auto-approve them. High risk, irreversible actions? Human in the loop, every time." This approach enables developers to maintain control over critical operations while the service handles integration overhead automatically.

**Availability:** Free to start at queuelo.com
