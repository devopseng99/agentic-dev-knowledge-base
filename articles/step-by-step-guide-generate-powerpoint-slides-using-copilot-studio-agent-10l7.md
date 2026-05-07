---
title: "Step-by-Step Guide: Generate PowerPoint Slides Using Copilot Studio Agent"
url: "https://dev.to/seenakhan/step-by-step-guide-generate-powerpoint-slides-using-copilot-studio-agent-10l7"
author: "Seena Khan"
category: "cloud-agents"
---

# Step-by-Step Guide: Generate PowerPoint Slides Using Copilot Studio Agent
**Author:** Seena Khan
**Published:** April 1, 2026

## Overview
Building an AI-powered PowerPoint generator using Microsoft Copilot Studio and Power Automate. Collects topic, slide count, audience, and tone through conversation, then generates and saves presentations to OneDrive/SharePoint.

## Key Concepts

### Agent Instructions
"You are a presentation assistant that creates professional PowerPoint slides"

### Generative AI Prompt
"Create a PowerPoint presentation outline for {Topic}. Generate {Number of Slides} slides. Include: Title Slide, Agenda, Content Slides, Summary Slide"

### Power Automate Flow
1. Triggered by Copilot with inputs (Topic, Slide Count, Content)
2. Uses "Populate Microsoft PowerPoint Template" action
3. Maps title and content fields to template
4. Saves as `{Topic}.pptx` to OneDrive/SharePoint
5. Returns download URL to user

### Enterprise Features
- Multi-template support by department
- Approval workflows
- Data integration from SharePoint/Excel/APIs
- Auto-email and Teams integration
- Speaker notes generation
