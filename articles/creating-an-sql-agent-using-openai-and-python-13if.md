---
title: "Creating an SQL Agent Using OpenAI and Python"
url: "https://dev.to/suyashmuley/creating-an-sql-agent-using-openai-and-python-13if"
author: "Suyash Muley"
category: "sql-agents"
---

# Creating an SQL Agent Using OpenAI and Python

**Author:** Suyash Muley
**Published:** December 11, 2024

## Overview

The article presents a practical approach to bridging natural language and SQL database queries. As the author explains, this enables "users [who] don't need to know SQL to interact with databases."

## Key Benefits

The article identifies three main advantages:

1. **Simplified Database Access** - Eliminates SQL expertise requirements
2. **Enhanced Productivity** - Reduces query development time
3. **Broader Accessibility** - Allows non-technical staff to retrieve data independently

## How the System Works

The implementation operates through three sequential steps:

1. **Natural Language Processing** - OpenAI's GPT-4o model translates user queries into SQL
2. **Query Execution** - SQLAlchemy runs the generated SQL against MS SQL Server
3. **Result Presentation** - Findings display in human-readable format

## Code Implementation

```python
import openai
from sqlalchemy import create_engine, text
import re

openai.api_key = "your_openai_api_key"
DATABASE_URI = "your_db_connection string"
engine = create_engine(DATABASE_URI)

def interpret_prompt_with_ai(prompt):
    try:
        response = openai.chat.completions.create(
            model="gpt-4o",
            messages=[{
                "role": "user",
                "content": f"Convert this user query into an SQL statement for MS SQL Server: {prompt}"
            }],
            temperature=0.5,
            max_tokens=150,
        )
        response_text = response.choices[0].message.content
        sql_query = re.search(r"```sql\n(.*?)\n```", response_text, re.DOTALL)
        if sql_query:
            return sql_query.group(1).strip()
        else:
            return response_text
    except Exception as e:
        print("Error interpreting prompt:", e)
        return None

def execute_query(sql_query):
    try:
        with engine.connect() as connection:
            result = connection.execute(text(sql_query))
            return result.fetchall()
    except Exception as e:
        print("Error executing query:", e)
        return None

def main():
    print("Welcome! Please specify your query in plain English:")
    user_prompt = input("> ")
    sql_query = interpret_prompt_with_ai(user_prompt)

    if not sql_query:
        print("Sorry, I couldn't generate a query from your input.")
        return

    print("\nGenerated SQL Query:")
    print(sql_query)

    results = execute_query(sql_query)
    if results is None:
        print("Sorry, the query could not be executed.")
        return

    print("\nQuery Results:")
    for row in results:
        print(row)

if __name__ == "__main__":
    main()
```

## Core Features

- **Natural Language Input** - Users submit plain English queries
- **AI-Powered SQL Generation** - GPT-4o generates contextually appropriate queries
- **Safe Database Operations** - SQLAlchemy manages secure query execution
- **Robust Error Handling** - Graceful failure messages for interpretation or execution issues

## Conclusion

The article concludes by encouraging readers to experiment with the tool and explore additional functionality extensions.
