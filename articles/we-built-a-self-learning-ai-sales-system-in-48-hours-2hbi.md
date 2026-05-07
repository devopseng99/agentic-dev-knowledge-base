---
title: "We Built a Self-Learning AI Sales System in 48 Hours"
url: "https://dev.to/ppcvote/we-built-a-self-learning-ai-sales-system-in-48-hours-2hbi"
author: "ppcvote"
category: "autonomous-operations"
---
# We Built a Self-Learning AI Sales System in 48 Hours
**Author:** ppcvote  **Published:** May 4, 2026

## Overview
An autonomous AI-driven sales prospecting system featuring four specialized agents that conduct outreach, personalize communications, and continuously optimize based on performance metrics — all at zero cost.

## Key Concepts

### Five-Stage Pipeline
1. **Discover** — Agents search for SMB prospects using Brave Search keywords, running 3x daily
2. **Qualify** — Scoring system evaluates prospects based on contact information, industry match, and learned success patterns
3. **Scan** — Products provide actual audit results as sales material
4. **Outreach** — Gemini 2.5 Flash generates personalized cold emails with three A/B variants (grade-based, problem-focused, competitive)
5. **Nurture** — Automated follow-ups triggered by engagement signals

### Self-Learning Engine
Six core learning modules enable autonomous optimization:
- **A/B Weight Auto-Adjustment** — Variants with higher open rates receive 3x selection probability; underperformers reduced to 0.1x
- **Smart Send Time** — System identifies optimal hours based on opens per hour data
- **Industry Success Calibration** — Qualify scores adjust dynamically (±20 points) based on conversion rates by vertical
- **Scoring Recalibration** — Flags when actual performance contradicts scoring predictions
- **Bounce Pattern Detection** — Auto-blacklists recurring problem domains
- **Lookalike Discovery** — Suggests new keywords targeting high-converting industries

### Four Specialized Agents
| Agent | Daily Capacity |
|-------|---|
| Probe | 40 emails |
| MindThread | 25 emails |
| Advisor | 20 emails |
| Main | 15 emails |

### Tech Stack
- **Engine:** Node.js (776 lines)
- **AI Models:** Gemini 2.5 Flash (personalization), Ollama 7B (reply classification)
- **Database:** Firebase Firestore
- **Notifications:** Telegram Bot API, Resend webhooks
- **Deployment:** Vercel, WSL2 systemd timers

### Cost Structure
Zero monthly expense: Resend (free 100/day), Gemini (free 200/day), Brave Search (free), Firestore (within free quota), Vercel Hobby plan.

### Core Innovation
"Every run, it learns a little more about what works and what doesn't. No one needs to tell it what to change — it reads the data and adjusts its own parameters."
