---
title: "I Built an Open-Source LLM Harness - AI Agents Interview, Plan, Build & Deploy Entire Apps From One Prompt"
url: "https://dev.to/herakles-dev/i-built-an-open-source-llm-harness-ai-agents-interview-plan-build-deploy-entire-apps-from-58m5"
author: "Michael Piscitelli"
category: "hackathons"
---

# I Built an Open-Source LLM Harness - AI Agents That Build & Deploy Entire Apps
**Author:** Michael Piscitelli
**Published:** March 17, 2026

## Overview
Nova Forge is an AI agent framework built during the Amazon Nova Hackathon (12 days, 30,000 lines of Python, completed with 2 minutes to spare). Users input a single prompt and agents design, build, and deploy the complete application.

## Key Concepts
- Pure Python: 35 modules, 1,670 tests
- 14 agent tools: read, write, edit, replace_lines, bash, grep, think
- 11 team formations (solo through 5-agent architecture reviews)
- Works with Amazon Nova (Lite, Pro, Premier), Bedrock, OpenAI, Anthropic adapters
- Tower defense game: 802-line playable game generated in 341 seconds
- 9 playable games built by AI agents with zero human code

### Six Critical Challenges
1. Agents describe rather than write code
2. Specification degradation through summarization
3. Building agents lack full spec access
4. Verification phases disrupt multi-file projects
5. Silent failures from missing tools
6. Directory structure errors from lack of path guidance

### GitHub Repository
- https://github.com/herakles-dev/nova-forge

**Demo Gallery:** https://forge.herakles.dev/demos/
