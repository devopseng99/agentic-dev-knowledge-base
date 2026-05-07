---
title: "Deployer son agent sur Google Vertex AI Agent Engine"
url: "https://dev.to/zenika/deployer-son-agent-sur-google-vertex-ai-agent-engine-342l"
author: "Benjamin Bourgeois"
category: "vertex-ai-agent"
---

# Deployer son agent sur Google Vertex AI Agent Engine

**Author:** Benjamin Bourgeois (Zenika)
**Published:** November 5, 2025

## Overview

French-language tutorial exploring two deployment approaches for Vertex AI Agent Engine: native ADK and flexible SDK integration for frameworks like LangChain, LangGraph, and CrewAI.

## Key Concepts

### Method 1: ADK Framework

```bash
mkdir deploy-with-adk && cd deploy-with-adk
uv venv --python 3.12
source .venv/bin/activate
uv pip install google-adk
adk create personal_assistant
```

### Agent Creation with Vertex AI Search

```python
from google.adk.agents.llm_agent import Agent
from google.adk.tools import VertexAiSearchTool

root_agent = Agent(
    model='gemini-2.5-flash',
    name='root_agent',
    instruction="Answer questions using Vertex AI Search to find information from internal documents.",
    tools=[VertexAiSearchTool(data_store_id=DATASTORE_ID)]
)
```

### ADK Deployment

```bash
adk deploy agent_engine \
    --project=${PROJECT_ID} \
    --region=${PROJECT_REGION} \
    --staging_bucket=gs://${BUCKET_NAME} \
    --display_name="Personal Assistant" \
    personal_assistant
```

### Method 2: Via Vertex AI SDK (LangChain)

```python
from vertexai import init, agent_engines
from langchain_retrievers.google_vertex_ai_search import VertexAISearchRetriever
from langchain.tools import Tool

init(project=PROJECT_ID, location=PROJECT_REGION, staging_bucket=f"gs://{STAGING_BUCKET}")

retriever = VertexAISearchRetriever(data_store_id=DATASTORE_ID)

search_tool = Tool(
    name="vertex_search",
    func=lambda query: retriever.get_relevant_documents(query),
    description="Searches your private document store via Vertex AI Search."
)

agent = agent_engines.LangchainAgent(
    model="gemini-2.5-flash",
    system_instruction="You're an intelligent assistant that can answer questions using internal document search.",
    tools=[search_tool],
    model_kwargs={"temperature": 0.3, "top_p": 0.9, "max_output_tokens": 1000},
)
```

### Deploy via SDK

```python
remote_agent = agent_engines.create(
    agent_engine=agent,
    requirements=["google-cloud-aiplatform[agent_engines,langchain]", "langchain_community"],
)
```

### Querying Deployed Agent

```python
from vertexai import agent_engines

agent_engine = agent_engines.get(RESOURCE_ID)
response = agent_engine.query(input="Who won the FIFA World Cup in 2018?")
print(response.output_text)
```

### Express Mode

Available since November 2025, allows usage without a Google Cloud project using only a Gmail account and API key.
