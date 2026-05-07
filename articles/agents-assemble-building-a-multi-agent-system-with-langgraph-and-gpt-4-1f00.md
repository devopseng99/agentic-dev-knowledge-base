---
title: "Agents Assemble! Building a Multi-Agent System with LangGraph and GPT-4"
url: "https://dev.to/sakethkowtha/agents-assemble-building-a-multi-agent-system-with-langgraph-and-gpt-4-1f00"
author: "sakethk"
category: "multi-agent system Python"
---

# Agents Assemble! Building a Multi-Agent System with LangGraph and GPT-4

**Author:** sakethk
**Published:** April 21, 2025

## Overview
This tutorial demonstrates building a multi-agent system using LangGraph and GPT-4 where specialized agents (Coder, Reviewer, Refactor) collaborate in a sequential workflow to write, review, and improve code.

## Key Concepts

### Installation

```bash
pip install langchain langgraph openai
```

### Agent Creation

```python
from langchain.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langgraph.graph import StateGraph, END

gpt4 = ChatOpenAI(model="gpt-4")

def create_agent(role, instructions):
    prompt = ChatPromptTemplate.from_messages([
        ("system", f"You are a {role}. {instructions}"),
        ("human", "{input}")
    ])
    return prompt | gpt4

coder = create_agent("Coder", "Write Python code based on the given requirements.")
reviewer = create_agent("Reviewer", "Review the given code and suggest improvements.")
refactor = create_agent("Refactor", "Implement the suggested improvements in the code.")
```

### Workflow Configuration

```python
workflow = StateGraph(nodes=[coder, reviewer, refactor])

workflow.add_edge(coder, reviewer)
workflow.add_edge(reviewer, refactor)
workflow.add_edge(refactor, END)

chain = workflow.compile()
```

### Execution

```python
task = "Create a function that calculates the factorial of a number"

result = chain.invoke({"input": task})
print(result)
```

### System Architecture
The workflow demonstrates sequential agent collaboration: a Coder writes initial code, a Reviewer analyzes and suggests improvements, then a Refactor agent implements enhancements.
