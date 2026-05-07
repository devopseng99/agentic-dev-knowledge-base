---
title: "Txt-to-SQL: Querying Databases with Nebius AI Studio and Agents"
url: "https://dev.to/spara_50/txt-to-sql-querying-databases-with-nebius-ai-studio-and-agents-44pl"
author: "Sophia Parafina"
category: "ai-agent-database-query"
---

# Txt-to-SQL: Querying Databases with Nebius AI Studio and Agents

**Author:** Sophia Parafina
**Published:** December 13, 2024

## Overview
Building an agent to query databases using Nebius AI Studio with LangChain's SQL agent toolkit, comparing three LLMs for code generation quality.

## Key Concepts

### HTML to Text Utility
```python
def html2text(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    text = []
    for p in soup.find_all('p'):
        para = p.get_text()
        text.append(para)
    return str(text)
```

### Model Comparison
1. **Meta-Llama-3.1-405B-Instruct** - Generated reasonable agent code with minor unused imports
2. **Qwen2.5-Coder-32B-Instruct** - Failed, producing direct database connection code instead
3. **DeepSeek-Coder-V2-Lite-Instruct** - Accomplished goal but included unnecessary schema extraction

### Working Implementation

```python
from langchain_community.utilities import SQLDatabase
from langchain_community.agent_toolkits import SQLDatabaseToolkit
from langchain_community.agent_toolkits import create_sql_agent
from langchain_openai import ChatOpenAI
import os

API_KEY = os.environ.get('NEBIUS_API_KEY')

client = ChatOpenAI(
    base_url="https://api.studio.nebius.ai/v1/",
    api_key=API_KEY,
    model="meta-llama/Meta-Llama-3.1-70B-Instruct",
)

db = SQLDatabase.from_uri("postgresql://postgres:postgres@localhost:5432/NORTHWIND")

def db_query_tool(query: str) -> str:
    """Execute a SQL query against the database and return the results."""
    try:
        result = db.run_no_throw(query)
        if not result:
            return "Error: Query failed."
        return result
    except Exception as e:
        return f"Error: {str(e)}"

agent = create_sql_agent(
    llm=client,
    toolkit=SQLDatabaseToolkit(db=db, llm=client),
    verbose=True
)

sql_query = """SELECT country, COUNT(*) AS number_of_suppliers
FROM suppliers
GROUP BY country
ORDER BY country;
"""

response = agent.run(sql_query)
print(response)
```

### Takeaway
LLMs cannot replace developers but can accelerate understanding of unfamiliar APIs, enabling functional code assembly within an hour.
