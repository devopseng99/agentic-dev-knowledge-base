---
title: "Create Your Own Custom LLM Agent Using Open Source Models (llama3.1)"
url: https://dev.to/emmakodes_/create-your-own-custom-llm-agent-using-open-source-models-llama31-4aag
author: Emmanuel Onwuegbusi
category: ai-agent-open-source-llama
---

# Create Your Own Custom LLM Agent Using Open Source Models (llama3.1)

**Author:** Emmanuel Onwuegbusi
**Date Published:** August 16, 2024

## Overview

This tutorial demonstrates how to build a custom LLM agent using Llama 3.1, an open-source model that runs locally. The guide leverages Ollama for model management and LangChain for agent orchestration.

## Key Steps

### 1. Installation
- Install Ollama via GitHub (instructions vary by OS)
- For Linux: `curl -fsSL https://ollama.com/install.sh | sh`

### 2. Model Setup
- Pull the default model: `ollama pull llama3.1`
- Alternatively, access https://ollama.com/library/llama3.1 for other versions (e.g., 70b parameter model)
- Models stored at: `~/.ollama/models` (Mac) or `/usr/share/ollama/.ollama/models` (Linux/WSL)

### 3. Server Configuration
- Start Ollama: `ollama serve`
- Models automatically serve on `localhost:11434`

### 4. Python Environment Setup
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -U langchain langchain-ollama
```

## Implementation Example

The provided Python code creates an agent with a custom word-length tool:

```python
from langchain_ollama import ChatOllama
from langchain.agents import tool
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.agents.format_scratchpad.openai_tools import format_to_openai_tool_messages
from langchain.agents import AgentExecutor
from langchain.agents.output_parsers.openai_tools import OpenAIToolsAgentOutputParser

llm = ChatOllama(model="llama3.1", temperature=0, verbose=True)

@tool
def get_word_length(word: str) -> int:
    """Returns the length of a word."""
    return len(word)

tools = [get_word_length]

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are very powerful assistant"),
    ("user", "{input}"),
    MessagesPlaceholder(variable_name="agent_scratchpad"),
])

llm_with_tools = llm.bind_tools(tools)
agent = ({
    "input": lambda x: x["input"],
    "agent_scratchpad": lambda x: format_to_openai_tool_messages(x["intermediate_steps"]),
} | prompt | llm_with_tools | OpenAIToolsAgentOutputParser())

agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)
result = agent_executor.invoke({"input": "How many letters in the word educa"})

if result:
    print(f"[Output] --> {result['output']}")
```

## Expected Output

The agent successfully invokes the tool and returns:
```
> Entering new AgentExecutor chain...
Invoking: `get_word_length` with `{'word': 'educa'}`
5
The word "educa" has 5 letters.
> Finished chain.
[Output] --> The word "educa" has 5 letters.
```

## Key Takeaway

This approach demonstrates building functional agents with "locally-running open-source models, enabling privacy-conscious AI development without cloud dependencies."
