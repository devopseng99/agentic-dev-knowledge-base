---
title: "I Built a Team of 5 Agents using Google ADK, Meta Llama and Nemotron-Ultra-253B"
url: "https://dev.to/astrodevil/i-built-a-team-of-5-agents-using-google-adk-meta-llama-and-nemotron-ultra-253b-ec3"
author: "Astrodevil"
category: "cloud-agents"
---

# I Built a Team of 5 Agents using Google ADK, Meta Llama and Nemotron-Ultra-253B
**Author:** Astrodevil
**Published:** April 26, 2025

## Overview
A comprehensive guide for building a sequential multi-agent system using Google's Agent Development Kit (ADK) with open-source models from Nebius AI Studio. Demonstrates a 5-agent pipeline integrating Tavily, Exa, and Firecrawl for web search and content scraping.

## Key Concepts

### Installation

```bash
pip install -q google-adk litellm python-dotenv exa-py tavily-python firecrawl-py
```

### Imports and Setup

```python
from google.adk.models.lite_llm import LiteLlm
from google.adk.agents.llm_agent import LlmAgent
from google.adk.agents.sequential_agent import SequentialAgent
from google.adk.sessions import InMemorySessionService
from google.adk.runners import Runner
from exa_py import Exa
from tavily import TavilyClient
from firecrawl import FirecrawlApp
import os
from datetime import datetime, timedelta
from google.genai import types
```

### LLM Configuration

```python
nebius_model = LiteLlm(
    model="openai/meta-llama/Meta-Llama-3.1-8B-Instruct",
    api_base=os.getenv("NEBIUS_API_BASE"),
    api_key=os.getenv("NEBIUS_API_KEY")
)
```

### Sequential Agent Pipeline

```python
pipeline = SequentialAgent(
    name="AIPipelineAgent",
    sub_agents=[exa_agent, tavily_agent, summary_agent, firecrawl_agent, analysis_agent]
)
```

### Agent Architecture
1. **ExaAgent** - Fetches AI news from Twitter/X
2. **TavilyAgent** - Retrieves benchmarks from artificialanalysis.ai
3. **SummaryAgent** - Combines and formats results
4. **FirecrawlAgent** - Scrapes Nebius AI Studio homepage
5. **AnalysisAgent** - Performs in-depth analysis using Nemotron-Ultra-253B

The pipeline uses `Runner` and `InMemorySessionService` for session state management and deterministic sequential execution.
