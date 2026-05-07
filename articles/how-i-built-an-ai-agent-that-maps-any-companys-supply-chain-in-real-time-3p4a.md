---
title: "How I Built an AI Agent That Maps Any Company's Supply Chain in Real-Time"
url: "https://dev.to/meirk-codes/how-i-built-an-ai-agent-that-maps-any-companys-supply-chain-in-real-time-3p4a"
author: "Meir"
category: "domain-agents"
---

# How I Built an AI Agent That Maps Any Company's Supply Chain in Real-Time
**Author:** Meir
**Published:** March 2, 2026

## Overview
Supply Chain Sankey discovers upstream suppliers and downstream distributors for any company using web search, scraping, and LLM analysis, then visualizes relationships as interactive Sankey diagrams with confidence scores and source URL citations.

## Key Concepts
Architecture integrates Bright Data (web searching/scraping), AWS Bedrock AgentCore (serverless hosting), LangGraph (pipeline orchestration), and Amazon Nova 2 Lite (analysis). The seven-step process includes parallel web searches using ThreadPoolExecutor with 6 workers.

```python
def bright_data_search(query: str, num_results: int = 5) -> list[dict]:
    # Handles anti-bot systems and JavaScript rendering automatically
```

Output converts discovered relationships into D3-compatible JSON with nodes color-coded by tier position.
