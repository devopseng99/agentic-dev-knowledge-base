---
title: "Building a Multi-Source AI Agent: Bridging Databases, APIs, and AI Models"
url: "https://dev.to/burhanahmeed/building-a-multi-source-ai-agent-bridging-databases-apis-and-ai-models-3lna"
author: "Burhanuddin Ahmed"
category: "ai-agent-database-query"
---

# Building a Multi-Source AI Agent: Bridging Databases, APIs, and AI Models

**Author:** Burhanuddin Ahmed
**Published:** February 13, 2025

## Overview
Proof-of-concept for automatically generating chart data from datasources using Python, FastAPI, and Google's Gemini API (Vertex AI), without frameworks like LangChain.

## Key Concepts

### Architecture
Two primary workflows connecting MySQL, Vertex AI LLM, and FastAPI:

**Uploader API:**
1. Upload CSV file
2. Extract sample rows
3. LLM determines data schema
4. Save schema metadata in MySQL
5. Create dynamic tables and insert data

**Fetcher API:**
1. Retrieve metadata by entity ID
2. Call LLM with schema as context
3. Receive AI-generated SQL queries
4. Execute queries against raw data

### Sample Response
```json
{
  "data": [
    {
      "date": "2024-01-05",
      "total_sales": 10000
    },
    {
      "date": "2024-01-10",
      "total_sales": 90000
    },
    {
      "date": "2024-01-17",
      "total_sales": 92000
    }
  ],
  "insight": "sales per day",
  "summary": "Lorem ipsum, lorem ipsum"
}
```

### Key Challenge
LLM hallucination: misleading data schema or SQL queries are the most common incorrect responses, causing runtime errors from missing columns or incorrect data formats.
