---
title: "I Built My Own AI Agent using n8n - And You Can Too"
url: https://dev.to/debs_obrien/i-built-my-own-ai-agent-and-you-can-too-56l1
author: Debbie O'Brien
category: n8n-agents
---

# I Built My Own AI Agent using n8n — And You Can Too

**Author:** Debbie O'Brien
**Date Published:** November 6, 2025
**Tags:** #n8n #agents #ai #webdev

---

## Overview

O'Brien describes building a personal AI agent using n8n, a visual workflow automation platform. The agent demonstrates how to combine multiple data sources and let an AI model reason across them without extensive coding.

---

## Agent Capabilities

The chat-based agent performs several functions:

- Weather queries for specific cities
- YouTube subscriber count retrieval
- Strava running statistics access
- Email summaries of conversations
- Integration with multiple APIs simultaneously

---

## What is n8n?

"A visual workflow automation tool. It allows you to drag and drop nodes to create automation steps, including AI reasoning steps."

The platform enables non-developers to build complex integrations through a graphical interface.

---

## Quick Start Guide: Seven Steps

### Step 1: Account Creation
Visit https://n8n.io and register free (no payment required initially).

### Step 2: Workflow Setup
Create a new workflow or use the template: https://n8n.io/workflows/6270-build-your-first-ai-agent/

### Step 3: Chat Trigger
Add an "AI Chat Trigger" node to generate a public chat interface URL.

### Step 4: AI Model Selection
Choose Google Gemini or OpenAI Chat Model. Requires respective API keys:
- Google Cloud: https://console.cloud.google.com/
- OpenAI credentials

**System Prompt Example:**
```
You are a personal assistant that can answer questions and use tools when needed.
```

### Step 5: Conversation Memory
Connect a Memory node to enable context retention across multiple messages.

### Step 6: First Tool Integration
Add an HTTP Request node pointing to a weather API:
```
GET https://api.open-meteo.com/v1/forecast
```

### Step 7: Activation
Save the workflow and toggle it active. Copy the generated chat URL.

**Test Query:**
```
What is the weather right now in Palma?
```

---

## Expanding Your Agent

Add tools incrementally:

1. YouTube Data API (subscriber metrics)
2. Strava API (fitness tracking)
3. GitHub API (issue management)
4. Gmail (automated notifications)

Strategy: "Connect it as a tool to the AI model. Test each step individually before chaining them."

---

## Key Takeaway

"Building an AI agent today does not require advanced development skills. The hardest part is usually obtaining and configuring API credentials."

The author encourages experimentation and organic growth as needs emerge, inviting readers to share their implementation experiences.
