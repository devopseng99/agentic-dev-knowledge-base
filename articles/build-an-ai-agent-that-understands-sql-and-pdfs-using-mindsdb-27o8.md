---
title: "Build an AI Agent That Understands SQL and PDFs Using MindsDB"
url: "https://dev.to/koolkamalkishor/build-an-ai-agent-that-understands-sql-and-pdfs-using-mindsdb-27o8"
author: "KAMAL KISHOR"
category: "ai-agent-pdf"
---

# Build an AI Agent That Understands SQL and PDFs Using MindsDB

**Author:** KAMAL KISHOR
**Published:** May 1, 2025

## Overview
A production-ready AI agent combining database queries with document analysis through MindsDB, integrating structured PostgreSQL data with unstructured PDF content.

## Code Examples

### Create Conversational Model

```sql
CREATE MODEL conversational_model
PREDICT answer
USING
    engine = 'langchain',
    openai_api_key = 'YOUR_OPENAI_API_KEY',
    model_name = 'gpt-4',
    mode = 'conversational',
    user_column = 'question',
    assistant_column = 'answer',
    prompt_template = 'Answer the user input in a helpful way',
    max_tokens = 100,
    temperature = 0;
```

### Text-to-SQL Skill

```sql
CREATE DATABASE datasource
WITH ENGINE = "postgres",
PARAMETERS = {
    "user": "demo_user",
    "password": "demo_password",
    "host": "samples.mindsdb.com",
    "port": "5432",
    "database": "demo",
    "schema": "demo_data"
};

CREATE SKILL text2sql_skill
USING
    type = 'text2sql',
    database = 'datasource',
    tables = ['house_sales'],
    description = 'Contains US house sales data from 2007 to 2015';
```

### Knowledge Base Skill for PDFs

```sql
CREATE MODEL embedding_model_hf
PREDICT embedding
USING
    engine = 'langchain_embedding',
    class = 'HuggingFaceEmbeddings',
    input_columns = ["content"];

CREATE KNOWLEDGE BASE my_knowledge_base
USING model = embedding_model_hf;

INSERT INTO my_knowledge_base
SELECT * FROM files.my_file_name;

CREATE SKILL kb_skill
USING
    type = 'knowledge_base',
    source = 'my_knowledge_base',
    description = 'PDF report with analysis on house pricing trends';
```

### Create the AI Agent

```sql
CREATE AGENT ai_agent
USING
    model = 'conversational_model',
    skills = ['text2sql_skill', 'kb_skill'];

SELECT question, answer
FROM ai_agent
WHERE question = 'How many houses were sold in 2015?';
```

### Deploy to Slack

```sql
CREATE DATABASE mindsdb_slack
WITH ENGINE = 'slack',
PARAMETERS = { "token": "xoxb-xxx", "app_token": "xapp-xxx" };

CREATE CHATBOT ai_chatbot
USING database = 'mindsdb_slack', agent = 'ai_agent';
```
