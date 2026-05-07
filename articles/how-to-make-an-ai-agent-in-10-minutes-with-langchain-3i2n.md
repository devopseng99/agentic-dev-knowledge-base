---
title: "How I Made an AI Agent in 10 Minutes with LangChain"
url: "https://dev.to/timesurgelabs/how-to-make-an-ai-agent-in-10-minutes-with-langchain-3i2n"
author: "Chandler (TimeSurge Labs)"
category: "langchain-tutorial"
---

# How I Made an AI Agent in 10 Minutes with LangChain

**Author:** Chandler (TimeSurge Labs)
**Published:** August 15, 2023
**Updated:** February 19, 2024

---

## Overview

This tutorial demonstrates creating AI agents using LangChain, a Python library that enables rapid prototyping of language model applications. The guide shows how to build autonomous agents with custom tools for web research and content summarization.

## Prerequisites

- Python 3.9 (3.10+ may have compatibility issues)
- OpenAI API Key
- Basic Python knowledge

## Setup Instructions

Create a project directory and virtual environment:

```bash
mkdir myproject
cd myproject
python -m venv env
source env/bin/activate
```

Install required packages:

```bash
pip install langchain openai python-dotenv requests duckduckgo-search
```

Create a `.env` file with your API key:

```
OPENAI_API_KEY=Your-api-key-here
```

## Key Concepts

**Agents** operate LLMs in loops to complete tasks, consisting of:
- Agent Type (e.g., ReAct)
- LLM (the AI model)
- Tools (Python functions agents can invoke)

## Implementation Steps

### 1. Import Libraries

```python
import requests
from bs4 import BeautifulSoup
from dotenv import load_dotenv
from langchain.tools import Tool, DuckDuckGoSearchResults
from langchain.prompts import PromptTemplate
from langchain.chat_models import ChatOpenAI
from langchain.chains import LLMChain
from langchain.agents import initialize_agent, AgentType
```

### 2. Load Environment Variables

```python
load_dotenv()
```

### 3. Initialize Search Tool

```python
ddg_search = DuckDuckGoSearchResults()
```

### 4. Define Web Request Headers

```python
HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:90.0) Gecko/20100101 Firefox/90.0'
}
```

### 5. Parse HTML Content

```python
def parse_html(content) -> str:
    soup = BeautifulSoup(content, 'html.parser')
    text_content_with_links = soup.get_text()
    return text_content_with_links
```

### 6. Fetch Web Pages

```python
def fetch_web_page(url: str) -> str:
    response = requests.get(url, headers=HEADERS)
    return parse_html(response.content)
```

### 7. Create Web Fetcher Tool

```python
web_fetch_tool = Tool.from_function(
    func=fetch_web_page,
    name="WebFetcher",
    description="Fetches the content of a web page"
)
```

### 8. Set Up Summarization

```python
prompt_template = "Summarize the following content: {content}"
llm = ChatOpenAI(model="gpt-3.5-turbo-16k")
llm_chain = LLMChain(
    llm=llm,
    prompt=PromptTemplate.from_template(prompt_template)
)

summarize_tool = Tool.from_function(
    func=llm_chain.run,
    name="Summarizer",
    description="Summarizes a web page"
)
```

### 9. Initialize Agent

```python
tools = [ddg_search, web_fetch_tool, summarize_tool]

agent = initialize_agent(
    tools=tools,
    agent_type=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
    llm=llm,
    verbose=True
)
```

### 10. Execute Agent

```python
prompt = "Research how to use the requests library in Python. Use your tools to search and summarize content into a guide on how to use the requests library."

print(agent.run(prompt))
```

## Advanced: Plan and Execute Agent

For complex multi-step tasks, install the experimental package:

```bash
pip install langchain_experimental
```

Import and configure:

```python
from langchain_experimental.plan_and_execute import PlanAndExecute, load_agent_executor, load_chat_planner

planner = load_chat_planner(llm)
executor = load_agent_executor(llm, tools, verbose=True)

agent = PlanAndExecute(planner=planner, executor=executor, verbose=True)

result = agent.run("Research how to use the requests library in Python. Use your tools to search and summarize content into a guide on how to use the requests library.")
print(result)
```

## Key Takeaways

LangChain simplifies agent creation through intuitive design, allowing developers to chain LLM tasks and define custom tools rapidly. The framework supports both simple reactive agents and sophisticated planning-based agents for complex automation scenarios.
