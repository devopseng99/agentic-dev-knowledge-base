---
title: "Building an Interactive Chatbot with Langchain and ChainLit"
url: "https://dev.to/scrapehero/building-an-interactive-chatbot-with-langchain-and-chainlit-leveraging-our-data-for-enhanced-conversational-experiences-57bn"
author: "Amal Ajay (ScrapeHero)"
category: "agent-ui-frameworks"
---

# Building an Interactive Chatbot with Langchain and ChainLit
**Author:** Amal Ajay (ScrapeHero)
**Published:** July 5, 2023

## Overview
Combining Langchain and Chainlit to build a conversational AI interface using pandas dataframe agent with custom data.

## Key Concepts

```python
from langchain.agents import create_pandas_dataframe_agent
agent = create_pandas_dataframe_agent(llm, data, verbose=False)
response = agent.run(message)
```

### File Upload
```python
files = await cl.AskFileMessage(
    content="Please upload a csv file to begin!",
    accept=["text/csv"]
).send()
cl.user_session.set('data', df)
```

- Langchain: prompt templates, LLMs, agents, memory, evaluation components
- Chainlit: flexible UI with custom styling for LLM chatbots
- GPT-3.5 Turbo's 4096-token limit; upgrade to GPT-4 or Anthropic for larger datasets
