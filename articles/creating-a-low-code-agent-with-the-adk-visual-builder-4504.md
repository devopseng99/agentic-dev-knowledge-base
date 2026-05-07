---
title: "Creating a Low-code Agent with the ADK Visual Builder"
url: "https://dev.to/gde/creating-a-low-code-agent-with-the-adk-visual-builder-4504"
author: "xbill (Google Developer Experts)"
category: "ai-agents"
---

# Creating a Low-code Agent with the ADK Visual Builder

**Author:** xbill (Google Developer Experts)
**Published:** February 21, 2026
**Updated:** February 21, 2026

## Overview

This article demonstrates building AI agents using Google's Agent Development Kit (ADK) with Python, leveraging the Gemini LLM and deploying to Google Cloud Run.

## Key Sections

### Python Version Management
The author recommends using **pyenv** for consistent Python version deployment across platforms. The article references Python 3.13 as the current mainstream version.

### Gemini CLI Setup
Installation requires:
```bash
npm install -g @google/gemini-cli
```

### Node Version Management
The **nvm** (Node Version Manager) tool helps maintain consistent Node.js environments needed for Gemini CLI operations.

### Agent Development Kit (ADK)
ADK is described as "an open-source, Python-based framework designed to streamline the creation, deployment, and orchestration of sophisticated, multi-agent AI systems."

### Environment Setup
Clone the repository and initialize:
```bash
cd ~
git clone https://github.com/xbill9/adkui
source init.sh
pip install -r requirements.txt
```

### Running Locally
```bash
adk web
```
Accessible at `http://127.0.0.1:8000`

### Cloud Deployment
Deploy to Google Cloud Run:
```bash
python3 deploycloudrun.py
```

## Key Takeaway
The workflow demonstrates an incremental approach to agent development: environment setup -> visual agent creation with integrated tools -> local testing -> secure cloud deployment and validation using Gemini CLI code review.
