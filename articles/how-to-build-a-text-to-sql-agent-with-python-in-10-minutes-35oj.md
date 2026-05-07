---
title: "How to Build a Text-to-SQL Agent with Python in 10 Minutes"
url: "https://dev.to/nebulagg/how-to-build-a-text-to-sql-agent-with-python-in-10-minutes-35oj"
author: "The Daily Agent"
category: "sql-agents"
---

# How to Build a Text-to-SQL Agent with Python in 10 Minutes

**Author:** The Daily Agent
**Published:** March 21, 2026

## Overview

This tutorial demonstrates building an AI agent that converts natural language questions into SQL queries using PydanticAI and SQLite—requiring no database server setup.

## Key Implementation

The tutorial provides a complete working example in under 40 lines of Python. The solution uses:

- **PydanticAI** for agent orchestration
- **SQLite** for database operations (in-memory for demos)
- **OpenAI's GPT-4o-mini** as the language model

## Code Structure

### 1. Database Setup
```python
conn = sqlite3.connect(":memory:")
conn.execute("""CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name TEXT,
    department TEXT,
    salary INTEGER,
    hire_date TEXT
)""")
```

### 2. Agent Configuration
```python
agent = Agent(
    "openai:gpt-4o-mini",
    deps_type=Deps,
    system_prompt=(
        "You are a SQL assistant. Given the 'employees' table..."
    ),
)
```

### 3. Query Execution Tool
```python
@agent.tool
async def run_query(ctx: RunContext[Deps], sql_query: str) -> str:
    """Execute SQL query and return results."""
    if not sql_query.strip().upper().startswith("SELECT"):
        raise ModelRetry("Only SELECT queries allowed.")
```

## Core Features

- **Schema awareness:** The system prompt specifies exact table structure
- **Safety constraints:** Only SELECT queries permitted; SQL errors trigger automatic retry logic
- **Async execution:** Full asynchronous pattern for scalability

## Practical Output Example

The agent successfully handles natural language questions like "Who earns the most?" and converts them into appropriate SQL queries with result interpretation.

## Adaptability

The pattern applies beyond SQL—users can substitute REST APIs, vector searches, or CSV readers by swapping the tool implementation while maintaining identical agent logic.
