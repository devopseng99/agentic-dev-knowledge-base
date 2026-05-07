---
title: "Agentic RAG for Developers!"
url: "https://dev.to/pavanbelagatti/agentic-rag-for-developers-ioe"
author: "Pavan Belagatti"
category: "agentic-rag"
---

# Agentic RAG for Developers!

**Author:** Pavan Belagatti
**Published:** August 8, 2024

## Overview
A guide to mastering Agentic RAG using LangChain and CrewAI, examining the evolution from traditional RAG to its agentic counterpart. Agentic RAG integrates AI agents to enhance the RAG approach, employing autonomous agents to analyze findings and strategically select tools for data retrieval.

## Key Concepts

### The Evolution of RAG: From Traditional to Agentic
Traditional RAG systems have revolutionized AI by combining LLMs with vector databases but struggle with multi-tasking and complex use cases. Agentic RAG integrates AI agents that can break down complex tasks into subtasks, possess memory (chat history), and can call any API or tool to solve tasks with logic and reasoning.

### LangChain as the Backbone
LangChain operates on modular principles, supporting both short-term (in-context learning) and long-term memory (external vector stores). It integrates intelligent agents that plan, reason, and learn over time.

### CrewAI for Advanced Agentic RAG
CrewAI is an open-source framework for creating and managing teams of intelligent agents that collaborate and share information. It supports sequential, hierarchical, and asynchronous workflows.

## Code Examples

### Install Required Libraries

```python
!pip install crewai==0.28.8 crewai_tools==0.1.6 langchain_community==0.0.29 sentence-transformers langchain-groq --quiet
```

### Import Libraries

```python
from langchain_openai import ChatOpenAI
import os
from crewai_tools import PDFSearchTool
from langchain_community.tools.tavily_search import TavilySearchResults
from crewai_tools import tool
from crewai import Crew
from crewai import Task
from crewai import Agent
```

### Configure LLM with Groq

```python
import os
os.environ['GROQ_API_KEY'] = 'Add Your Groq API Key'

llm = ChatOpenAI(
    openai_api_base="https://api.groq.com/openai/v1",
    openai_api_key=os.environ['GROQ_API_KEY'],
    model_name="llama3-8b-8192",
    temperature=0.1,
    max_tokens=1000,
)
```

### Create RAG Tool with PDF Search

```python
rag_tool = PDFSearchTool(pdf='attenstion_is_all_you_need.pdf',
    config=dict(
        llm=dict(
            provider="groq",
            config=dict(
                model="llama3-8b-8192",
            ),
        ),
        embedder=dict(
            provider="huggingface",
            config=dict(
                model="BAAI/bge-small-en-v1.5",
            ),
        ),
    )
)
```

### Create Web Search Tool

```python
import os
os.environ['TAVILY_API_KEY'] = 'Add Your Tavily API Key'
web_search_tool = TavilySearchResults(k=3)
```

### Define Router Tool

```python
@tool
def router_tool(question):
  """Router Function"""
  if 'self-attention' in question:
    return 'vectorstore'
  else:
    return 'web_search'
```

### Create Router Agent

```python
Router_Agent = Agent(
  role='Router',
  goal='Route user question to a vectorstore or web search',
  backstory=(
    "You are an expert at routing a user question to a vectorstore or web search."
    "Use the vectorstore for questions on concept related to Retrieval-Augmented Generation."
    "You do not need to be stringent with the keywords in the question related to these topics. Otherwise, use web-search."
  ),
  verbose=True,
  allow_delegation=False,
  llm=llm,
)
```
