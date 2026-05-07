---
title: "How to Build an AI-Powered Code Review Bot with GitHub Action, Slack, and LLMs"
url: "https://dev.to/cuongnp/how-to-build-an-ai-powered-code-review-bot-with-github-action-slack-and-llms-3iik"
author: "cuongnp"
category: "code-review"
---

# How to Build an AI-Powered Code Review Bot with GitHub Action, Slack, and LLMs

**Author:** cuongnp
**Date Published:** September 23, 2025
**Tags:** #ai #openai #devops #productivity

---

## Overview

The article addresses a common challenge: teams struggle with code reviews due to time constraints and inconsistent feedback. The solution is an automated AI-powered bot that leverages GitHub Actions, Slack integration, and Large Language Models to streamline the review process.

## Key Learning Objectives

- Automating code reviews on pull requests using GitHub Actions
- Integrating Slack notifications with interactive approval buttons
- Connecting GitHub, Slack, and backend systems seamlessly
- Utilizing LLMs like OpenAI for intelligent code analysis

## Technical Architecture

The system follows this workflow:

1. **GitHub Actions** triggers on PR events
2. **LLM service** analyzes code changes
3. **Slack bot** posts review summaries with action buttons
4. **Express backend** handles interactive responses
5. **GitHub API** updates PR status based on user actions

## Tech Stack

- GitHub Actions for CI/CD automation
- Node.js (v18+) with Express backend
- Next.js example codebase
- Slack App for notifications
- Cloudflare Tunnel for local development tunneling
- OpenAI/LLM providers for code intelligence

## Project Structure

```
code-review-llm/
├── .github/workflows/code-review.yml
├── src/services/
│   ├── reviewRunner.js
│   ├── llmService.js
│   └── reviewService.js
├── slack-backend/
│   ├── index.js
│   └── package.json
└── public/
```

## Implementation Steps

### 1. GitHub Actions Workflow Setup

The workflow triggers on pull request events (opened, synchronize, reopened). Key configuration includes:

- Repository secrets for `OPENAI_API_KEY` and `SLACK_BOT_TOKEN`
- Fetching PR diffs with context
- Running the review analysis
- Posting results to Slack

**Workflow features:**
- Checks out code with full history
- Sets up Node.js 18 with npm caching
- Generates unified diffs with context
- Executes LLM analysis via `reviewRunner.js`
- Sends summaries and interactive messages to Slack

### 2. Slack Integration

The bot posts structured messages with:

```json
{
  "type": "section",
  "text": {
    "type": "mrkdwn",
    "text": "*Code Review Request*..."
  }
}
```

Interactive action blocks provide buttons for:
- Approve
- Request Changes

### 3. Backend for Interactivity

Express server handles Slack interactive payloads:

```javascript
app.post('/slack/interactive', async (req, res) => {
  const payload = JSON.parse(req.body.payload);
  const { actions, user } = payload;
  // Process approve/comment actions
});
```

### 4. Local Development Tunneling

Use Cloudflare Tunnel or ngrok to expose localhost:

```bash
npm install -g cloudflared
cloudflared tunnel --url http://localhost:3000
```

Configure Slack app's Request URL with the tunnel endpoint.

## Prerequisites

- GitHub account with personal access token (repo, pull_requests scopes)
- Slack workspace with bot creation capabilities
- Node.js v18 or later
- OpenAI API credentials (or alternative LLM provider)
- Optional: Cloudflare/ngrok for local testing

## Expected Output

When a PR is opened:

1. GitHub Actions runs the analysis
2. LLM generates a code review summary
3. Slack channel receives:
   - Summary message with findings
   - Interactive buttons for approval/changes
4. Clicking buttons updates PR status in GitHub

## Next Steps for Enhancement

- Extend Slack actions (custom comments, assignee management)
- Multi-platform support (Discord, Microsoft Teams)
- Custom review criteria configuration
- Cost optimization for high-volume reviews

## Resources

**GitHub Repository:** [code-review-llm](https://github.com/mrdaiking/code-review-llm)
**Original Publication:** TechCodex

---

## Key Takeaway

This automation pattern reduces review bottlenecks by combining CI/CD workflows with AI intelligence and team collaboration tools, enabling faster feedback cycles without sacrificing code quality.
