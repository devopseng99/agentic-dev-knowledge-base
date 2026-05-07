---
title: "Automating SQL Queries with LangChain and Gemini: A Step-by-Step Guide"
url: "https://dev.to/exson_joseph/automating-sql-queries-with-langchain-and-gemini-a-step-by-step-guide-816"
author: "Exson Joseph"
category: "agent-natural-language-sql"
---

# Automating SQL Queries with LangChain and Gemini: A Step-by-Step Guide

**Author:** Exson Joseph
**Published:** April 2, 2025

## Overview
A step-by-step guide to building a natural language SQL automation pipeline using LangChain and Google Gemini.

## Key Concepts

### Setup

```python
pip install mysql-connector-python langchain langchain-community langchain-google-genai python-dotenv
```

### Importing Required Modules

```python
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_community.utilities import SQLDatabase
from langchain_community.tools.sql_database.tool import QuerySQLDatabaseTool
from langchain import hub
from dotenv import load_dotenv
import os
```

### Initializing Gemini AI Model

```python
llm = ChatGoogleGenerativeAI(model="gemini-1.5-flash")
```

### SQL Query Generation

```python
query_prompt_template = hub.pull("langchain-ai/sql-query-system-prompt")

def write_query(question: str):
    prompt = query_prompt_template.invoke(
        {
            "dialect": db.dialect,
            "top_k": 10,
            "table_info": db.get_table_info(),
            "input": question,
        }
    )
    response = llm.invoke(prompt.to_string())
    extraction_prompt = """
    Please extract the SQL query from the following text and return only the SQL query:
    {response}
    SQL Query:
    """
    prompt = extraction_prompt.format(response=response)
    parsed_query = llm.invoke(prompt)
    return parsed_query.content
```

### Natural Language Answer Generation

```python
def generate_answer(question: str, query: str, result: str):
    prompt = (
        "Given the following user question, corresponding SQL query, "
        "and SQL result, answer the user question.\n\n"
        f'Question: {question}\n'
        f'SQL Query: {query}\n'
        f'SQL Result: {result}'
    )
    response = llm.invoke(prompt)
    return response.content
```

### Integration Example

```python
question = "Which employee is leading Project Gamma"
query = write_query(question)
result = execute_query(query)
answer = generate_answer(question, query, result)
print(answer)
# Output: Charlie Brown is the Marketing Lead for Project Gamma.
```
