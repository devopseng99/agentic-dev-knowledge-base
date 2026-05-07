---
title: "Tutorial: Building SQL Agent with Langchain, OpenAI and DuckDB"
url: "https://dev.to/squadbase/tutorial-building-sql-agent-with-langchain-openai-and-duckdb-4ng3"
author: "Naoto Shibata"
category: "sql-agents"
---

# Tutorial: Building SQL Agent with Langchain, OpenAI and DuckDB

**Author:** Naoto Shibata (Squadbase)
**Published:** March 10, 2025

## Overview

This tutorial demonstrates building an AI-powered SQL agent that generates and executes SQL queries on CSV data using LangChain, OpenAI's API, and DuckDB. The application provides a chat interface for answering questions about marketing data.

## Setup

Initialize a new Morph project:

```bash
morph new sql-agent-app
```

Configure dependencies in `pyproject.toml`:

```toml
[tool.poetry.dependencies]
python = "<3.13,>=3.9"
morph-data = "0.2.0"
langchain = "0.3.16"
langchain-core = "0.3.32"
langchain-openai = "0.3.2"
```

Set your OpenAI API key in `.env`:

```
OPENAI_API_KEY=[your-key-here]
```

## Frontend Implementation

Create an MDX-based chat interface with data visualization:

```mdx
# Q&A Agent over SQL

<Grid cols={2} className="py-4">
    <div>
        <DataTable loadData="example_data" height={400} />
    </div>
    <div className="p-4 bg-gray-50 rounded-lg">
        <Chat postData="sql_agent" />
    </div>
</Grid>
```

## Backend: SQL Agent Implementation

### Initialize ChatOpenAI Model

```python
from langchain_openai import ChatOpenAI

chat = ChatOpenAI(
    model="gpt-4o",
    temperature=0,
    streaming=False,
)
```

### Define System Prompt

```python
SYSTEM_TEMPLATE = """Please execute SQL queries on a table named
`./data/Traffic_Orders_Demo_Data.csv` in DuckDB with the following schema:
date: text - date
source: text - traffic source
traffic: int - traffic count
orders: int - order count

Generate a SQL query to answer the user's question.
{format_instructions}
"""
```

### SQL Generation Chain

```python
from langchain.output_parsers import StructuredOutputParser, ResponseSchema
from langchain.prompts import ChatPromptTemplate
from langchain.schema.runnable import RunnablePassthrough

sql_schema = ResponseSchema(name="sql", description="The SQL query")
output_parser = StructuredOutputParser.from_response_schemas([sql_schema])
format_instructions = output_parser.get_format_instructions()

prompt = ChatPromptTemplate.from_messages([
    ("system", SYSTEM_TEMPLATE),
    ("human", "{question}")
])

chain = (
    {"question": RunnablePassthrough(),
     "format_instructions": lambda _: format_instructions}
    | prompt
    | chat
    | StrOutputParser()
    | output_parser
)
```

### Execute SQL Query

```python
from morph_lib.database import execute_sql
from morph_lib.stream import stream_chat

result = chain.invoke(context.vars["prompt"])
sql = result["sql"]

yield stream_chat(f"### SQL\n{sql}")

data = execute_sql(sql, "DUCKDB")
data_md = data.to_markdown(index=False)
```

### Generate Natural Language Response

```python
analysis_prompt = ChatPromptTemplate.from_messages([
    ("system", f"""Please answer in markdown format.
Data from SQL query: {sql}
Results: {data_md}"""),
    ("human", "{question}")
])

analysis_chain = (
    {"question": RunnablePassthrough()}
    | analysis_prompt
    | chat
)

for chunk in analysis_chain.stream(context.vars["prompt"]):
    if chunk.content:
        yield stream_chat(chunk.content)
```

## Complete Python Code

```python
from typing import Generator

from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain.schema.output_parser import StrOutputParser
from langchain.schema.runnable import RunnablePassthrough
from langchain.output_parsers import ResponseSchema, StructuredOutputParser
from morph_lib.database import execute_sql
from morph_lib.stream import stream_chat
from morph_lib.types import MorphChatStreamChunk

import morph
from morph import MorphGlobalContext

SYSTEM_TEMPLATE = """Please execute SQL queries on a table named
`./data/Traffic_Orders_Demo_Data.csv` in DuckDB with schema:
date: text, source: text, traffic: int, orders: int

{format_instructions}
"""

@morph.func
def sql_agent(
    context: MorphGlobalContext,
) -> Generator[MorphChatStreamChunk, None, None]:
    chat = ChatOpenAI(model="gpt-4o", temperature=0)

    sql_schema = ResponseSchema(name="sql", description="SQL query")
    output_parser = StructuredOutputParser.from_response_schemas([sql_schema])
    format_instructions = output_parser.get_format_instructions()

    prompt = ChatPromptTemplate.from_messages([
        ("system", SYSTEM_TEMPLATE),
        ("human", "{question}")
    ])

    chain = (
        {"question": RunnablePassthrough(),
         "format_instructions": lambda _: format_instructions}
        | prompt
        | chat
        | StrOutputParser()
        | output_parser
    )

    result = chain.invoke(context.vars["prompt"])
    sql = result["sql"]
    yield stream_chat(f"### SQL\n{sql}")

    data = execute_sql(sql, "DUCKDB")
    data_md = data.to_markdown(index=False)

    analysis_prompt = ChatPromptTemplate.from_messages([
        ("system", f"""Answer in markdown. Data: {data_md}"""),
        ("human", "{question}")
    ])

    analysis_chain = (
        {"question": RunnablePassthrough()}
        | analysis_prompt
        | chat
    )

    for chunk in analysis_chain.stream(context.vars["prompt"]):
        if chunk.content:
            yield stream_chat(chunk.content)
```

## Deployment

Deploy via GitHub integration through the Morph dashboard. The application automatically includes authentication and can be shared with team members.

## Key Takeaways

- LangChain's Runnable API chains operations for flexible data workflows
- StructuredOutputParser ensures consistent, parseable LLM outputs
- DuckDB provides efficient SQL execution on CSV files
- Morph framework simplifies frontend and deployment logistics
