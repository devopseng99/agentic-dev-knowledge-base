---
title: "Building a Multi-Agent Candidate Search System with Azure AI Foundry"
url: "https://dev.to/sreeni5018/building-a-multi-agent-candidate-search-system-with-azure-ai-foundry-5gcm"
author: "Seenivasa Ramadurai"
category: "cloud-agents"
---

# Building a Multi-Agent Candidate Search System with Azure AI Foundry
**Author:** Seenivasa Ramadurai
**Published:** October 5, 2025

## Overview
Building a recruitment platform using Azure AI Foundry's multi-agent architecture. Three specialized agents (LinkedIn, Web Research, Social Media) work in parallel to gather and consolidate candidate information using ConnectedAgentTool for inter-agent communication.

## Key Concepts

### FastAPI Implementation

```python
from azure.ai.agents import AgentsClient
from azure.ai.agents.models import ConnectedAgentTool, MessageRole

@app.post("/search", response_model=CandidateSearchResponse)
async def search_candidate(request: CandidateSearchRequest):
    agents_client = AgentsClient(
        endpoint=project_endpoint,
        credential=DefaultAzureCredential()
    )
    # Creates specialized agents for parallel information gathering
```

### Agent Architecture
1. **LinkedIn Search Specialist**: Finds professional profiles
2. **Web Research Specialist**: General web search for candidate info
3. **Social Media Analyst**: Analyzes social media presence

### Core Components
- **AgentsClient**: Coordinates AI agents and manages conversations
- **ConnectedAgentTool**: Enables inter-agent communication
- **Tavily API**: Provides real-time web search capabilities

Consolidates scattered candidate data across platforms into comprehensive profiles.
