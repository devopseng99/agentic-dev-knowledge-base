---
title: "Building a Proactive Web-Scraping Agent with Python, Firecrawl, and Azure OpenAI"
url: "https://dev.to/pratikpathak/building-a-proactive-web-scraping-agent-with-python-firecrawl-and-azure-openai-4813"
author: "Pratik Pathak"
category: "ai-agents"
---

# Building a Proactive Web-Scraping Agent with Python, Firecrawl, and Azure OpenAI

**Author:** Pratik Pathak
**Date Published:** April 15, 2026

## Overview

The article explains how to build an autonomous agent that monitors competitor websites, extracts pricing data, tracks changes, and sends alerts--all without human intervention.

## Key Concepts

**Why This Tech Stack?**
- Firecrawl handles brittle scraping issues by converting web pages to clean markdown
- Azure OpenAI provides enterprise security and data privacy compliance
- Python serves as the integration glue

## Core Implementation Steps

### Step 1: Environment Setup
```bash
pip install firecrawl-py openai azure-cosmos python-dotenv requests
```

Create a `.env` file containing:
- FIRECRAWL_API_KEY
- AZURE_OPENAI_API_KEY
- AZURE_OPENAI_ENDPOINT
- AZURE_OPENAI_DEPLOYMENT_NAME
- COSMOS_DB_ENDPOINT and COSMOS_DB_KEY
- SLACK_WEBHOOK_URL

### Step 2: Web Extraction with Firecrawl
```python
from firecrawl import FirecrawlApp
from dotenv import load_dotenv

load_dotenv()
firecrawl = FirecrawlApp(api_key=os.getenv("FIRECRAWL_API_KEY"))

def scrape_target_url(url):
    try:
        scrape_result = firecrawl.scrape_url(
            url,
            params={'formats': ['markdown']}
        )
        return scrape_result.get('markdown', '')
    except Exception as e:
        print(f"Error scraping URL: {e}")
        return None
```

### Step 3: Structured Data Extraction with Azure OpenAI
```python
from openai import AzureOpenAI

client = AzureOpenAI(
    api_key=os.getenv("AZURE_OPENAI_API_KEY"),
    api_version="2024-02-01",
    azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT")
)

def analyze_content(markdown_text):
    system_prompt = """Extract pricing tiers and features. Return JSON with
    'tiers' key containing objects with 'name', 'price', and 'key_features'."""

    response = client.chat.completions.create(
        model=os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME"),
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": markdown_text}
        ],
        response_format={"type": "json_object"},
        temperature=0.1
    )

    return json.loads(response.choices[0].message.content)
```

**Key Tip:** "Using `response_format={'type': 'json_object'}` alongside low temperature eliminates need for complex regex parsers."

### Step 4: State Management with Azure Cosmos DB
```python
from azure.cosmos import CosmosClient, exceptions

cosmos_client = CosmosClient(
    os.getenv("COSMOS_DB_ENDPOINT"),
    os.getenv("COSMOS_DB_KEY")
)
container = cosmos_client.get_database_client(
    "IntelligenceDB"
).get_container_client("CompetitorPricing")

def get_previous_state(competitor_id):
    try:
        return container.read_item(
            item=competitor_id,
            partition_key=competitor_id
        )
    except exceptions.CosmosResourceNotFoundError:
        return None

def update_state(competitor_id, new_data):
    document = {
        "id": competitor_id,
        "partitionKey": competitor_id,
        "pricing_data": new_data
    }
    container.upsert_item(document)
```

### Step 5: Change Detection & Alerts
```python
import requests

def send_slack_alert(message):
    webhook_url = os.getenv("SLACK_WEBHOOK_URL")
    if webhook_url:
        requests.post(webhook_url, json={"text": message})

if previous_data:
    if previous_data["pricing_data"] != current_pricing_data:
        alert_msg = "Pricing Change Detected!"
        send_slack_alert(alert_msg)
        update_state("example-corp", current_pricing_data)
```

### Step 6: Automation with Azure Functions
```python
import azure.functions as func

app = func.FunctionApp()

@app.schedule(
    schedule="0 0 8 * * *",
    arg_name="myTimer",
    run_on_startup=False
)
def proactive_pricing_agent(myTimer: func.TimerRequest) -> None:
    # Scrape -> Analyze -> Compare -> Alert
    pass
```

## Key Takeaways

1. **Markdown Over HTML:** LLMs process markdown significantly better than raw HTML
2. **Deterministic Extraction:** Forced JSON output with low temperature ensures consistent results
3. **State Comparison:** Cosmos DB enables historical comparison for change detection
4. **Scheduled Autonomy:** Azure Functions eliminate manual triggering
5. **Scalability:** This pattern extends beyond pricing to lead generation and customer support auditing

## Architecture Summary

The system workflow: Firecrawl extracts -> Azure OpenAI structures -> Cosmos DB stores state -> Detection logic identifies changes -> Slack webhook notifies team -> Azure Functions triggers daily execution.
