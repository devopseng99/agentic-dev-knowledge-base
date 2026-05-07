---
title: "Starter Guide: Browser Agents"
url: "https://dev.to/emilanker/browser-agent-starter-guide-434h"
author: "Emil Anker"
category: "full-code-examples"
---

# Starter Guide: Browser Agents
**Author:** Emil Anker
**Published:** January 30, 2025

## Overview
Guide to building browser agents that receive instructions and perform browser actions (click, type, navigate, scrape) on a remote or headless browser using Next.js, Vercel AI SDK, and LLMs.

## Key Concepts

### Technologies
- Next.js 13+ framework
- Vercel AI SDK for LLM integration
- LLM Options: Anthropic, OpenAI, or Llama-2-7b-chat on Replicate
- Browser Automation: Browser Use (Open) or Multi-On Cookbook
- Deployment: Vercel

### Implementation Steps (1.5 hours total)
1. **Project Setup (15 min):** Create Next.js app, install @vercel/ai
2. **API Route (30 min):** Build POST endpoint at `app/api/agent/route.js`
3. **Frontend UI (15 min):** Create input form with text field and toggle for Replicate
4. **Deployment (15 min):** Push to Vercel with environment variables

### Code Structure
- LLM prompt engineering to generate JSON instructions
- Browser launch and navigation logic
- Action handlers for scraping, clicking, and form-filling
- Error handling and response formatting

### Use Case Example
Scraping the latest headline from Hacker News: "Go to https://news.ycombinator.com and scrapeText at '.titleline a'"

### Additional Use Cases
- Auto-form filling for login flows
- Price comparison across e-commerce sites
- Content extraction from multiple websites
- Webmail navigation and email parsing
- Automated testing scenarios
