---
title: "How to Create a Web Search AI Agent with AWS Bedrock"
url: "https://dev.to/onepoint/how-to-create-a-web-search-ai-agent-with-aws-bedrock-5f1k"
author: "Meidi Airouche"
category: "bedrock-agent-aws"
---

# How to Create a Web Search AI Agent with AWS Bedrock

**Author:** Meidi Airouche
**Published:** July 25, 2025

## Overview

Explains how to build autonomous AI agents using Amazon Bedrock that perform real-time web searches by combining Bedrock Agents with the Serper API and AWS Lambda.

## Key Concepts

### Architecture

- Amazon Bedrock Agent as central orchestrator
- AWS Lambda for search API integration
- Serper API for real-time web search
- AWS Secrets Manager for credential storage
- Claude 3 Haiku model for language generation

### Lambda Function (Python)

```python
import json
import logging
import os
import http.client
import boto3

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

AWS_REGION = os.environ.get("AWS_REGION", "us-east-1")
ACTION_GROUP_NAME = os.environ.get("ACTION_GROUP", "action-group-websearch")
SERPER_API_KEY = os.environ.get("SERPER_API_KEY")

if not SERPER_API_KEY:
    secrets = boto3.client("secretsmanager", region_name=AWS_REGION)
    SERPER_API_KEY = secrets.get_secret_value(SecretId="SERPER_API_KEY")["SecretString"]

def extract_search_params(event):
    if event["actionGroup"] != ACTION_GROUP_NAME:
        logger.error("Invalid action group")
        return None, None
    params = {p["name"]: p["value"] for p in event.get("parameters", [])}
    return params.get("search_query"), params.get("target_website", "")

def google_search(query, target_site=""):
    if target_site:
        query += f" site:{target_site}"
    payload = json.dumps({"q": query})
    headers = {"X-API-KEY": SERPER_API_KEY, "Content-Type": "application/json"}
    conn = http.client.HTTPSConnection("google.serper.dev")
    conn.request("POST", "/news", payload, headers)
    res = conn.getresponse()
    return res.read().decode("utf-8")

def lambda_handler(event, _):
    query, site = extract_search_params(event)
    if not query:
        return {"error": "Missing query"}
    results = google_search(query, site)
    return {
        "response": {
            "actionGroup": event["actionGroup"],
            "function": event["function"],
            "functionResponse": {
                "responseBody": {
                    "TEXT": {
                        "body": f"Here are the top search results for '{query}': {results}"
                    }
                }
            },
        },
        "messageVersion": event["messageVersion"],
    }
```

### Secret Setup

```bash
aws secretsmanager create-secret \
    --name SERPER_API_KEY \
    --description "The API secret key for Serper." \
    --secret-string "<SERPER_API_KEY>"
```

### IAM Policy for Lambda

```json
{
  "Action": "secretsmanager:GetSecretValue",
  "Resource": [
    "arn:aws:secretsmanager:<REGION>:<ACCOUNT_ID>:secret:SERPER_API_KEY*"
  ],
  "Effect": "Allow",
  "Sid": "GetSecretsManagerSecret"
}
```
