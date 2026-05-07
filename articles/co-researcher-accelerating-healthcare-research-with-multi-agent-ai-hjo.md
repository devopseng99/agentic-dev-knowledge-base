---
title: "Co-Researcher: Accelerating Healthcare Research with Multi-Agent AI"
url: "https://dev.to/ashiqsultan/co-researcher-accelerating-healthcare-research-with-multi-agent-ai-hjo"
author: "Mohamed Ashiq Sultan"
category: "healthcare-ai-agent"
---

# Co-Researcher: Accelerating Healthcare Research with Multi-Agent AI

**Author:** Mohamed Ashiq Sultan
**Published:** August 30, 2025

## Overview

An AI-powered research automation tool for drug discovery and medical research, using multiple n8n AI Agent nodes for specialized tasks with Bright Data for real-time internet data retrieval.

## Key Concepts

### Multi-Agent Architecture
The system employs separate agents for distinct research phases:
- Gathering clinical trial information
- Reviewing scientific literature
- Evaluating safety data
- A final agent synthesizes all findings

### Two-Workflow Design
1. **Main Workflow:** Orchestrates research using multiple specialized AI agents
2. **Sub-Workflow:** Reusable web-searching functionality callable by multiple agents

### Technology Stack
- Next.js (web application)
- n8n (workflow automation)
- Bright Data (web searching)
- Airtable (data persistence)
- Google Gemini Flash (language model)

### Key Design Breakthrough
Initial attempts to integrate Bright Data directly as an agent tool failed because search results stored in snapshots created orchestration challenges. The solution was creating a separate reusable workflow called as a tool -- "a reusable web searching workflow" deployable across different research contexts.

### Challenges
- Output inconsistencies due to n8n's Agent output structure tool cleaning the output JSON
- Limitations from Gemini's free-tier capabilities

### Deliverables
- Live Application: https://co-researcher.vercel.app
- GitHub Repository with complete source code and n8n workflow JSON files
