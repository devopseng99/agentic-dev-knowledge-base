---
title: "Create Your First Google ADK Agent: A Beginner's Guide"
url: "https://dev.to/ranand12/create-your-first-google-adk-agent-a-beginners-guide-5d41"
author: "Anand Kumar R"
category: "cloud-agents"
---

# Create Your First Google ADK Agent: A Beginner's Guide
**Author:** Anand Kumar R
**Published:** November 13, 2025

## Overview
Beginner-friendly guide to Google's Agent Development Kit (ADK) covering two creation methods: Visual Builder (low-code) and YAML Configuration (CLI-based). Explains core agent components (Name, Model, Instructions, Description, Tools).

## Key Concepts

### Prerequisites

```bash
pip install --upgrade google-adk
```

### Method 1: Visual Builder

```bash
adk web
```
Create agents visually with AI Assistant using natural language prompts. Example: "Create a bull and bear research agent for a given stock using Google Search."

### Method 2: YAML Configuration

```bash
adk create --name "My-YAML-Agent" --configuration
```

Follow CLI prompts to select model, provider, and API key. Generates a `root_agent.yaml` file.

### Core Agent Components
- **Name**: Identifier for the agent
- **Model**: Gemini or third-party via LiteLLM
- **Instructions**: Detailed prompts defining behavior
- **Description**: For multi-agent systems discovery
- **Tools**: Google Search, File Retrieval, custom functions
