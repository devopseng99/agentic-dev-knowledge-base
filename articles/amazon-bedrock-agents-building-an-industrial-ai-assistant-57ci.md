---
title: "Amazon Bedrock Agents: Building an Industrial AI Assistant"
url: "https://dev.to/aws-builders/amazon-bedrock-agents-building-an-industrial-ai-assistant-57ci"
author: "Gerardo Arroyo"
category: "ai-assistant-api"
---

# Amazon Bedrock Agents: Building an Industrial AI Assistant

**Author:** Gerardo Arroyo
**Published:** March 27, 2026

## Overview
Demonstrates building an intelligent industrial monitoring system using Amazon Bedrock Agents with Claude 3.5 Sonnet v2. The AI assistant analyzes equipment health, predicts failures, and provides maintenance recommendations through integration with industrial APIs and knowledge bases.

## Key Concepts

### AI-Adapted API Design
Documentation quality is foundational to agent success. Traditional API docs must be enriched with context for language models.

```yaml
# Traditional approach
/sensors/temp:
  get:
    summary: "Obtener temperatura"
    responses:
      200:
        description: "Exito"

# AI-enriched approach
/equipment/{id}/health:
  get:
    description: |
      Evalua el estado integral del equipo considerando multiples factores...
```

## Code Examples

### Lambda Function Implementation (Python)

```python
import json
import urllib3
import os
from urllib.parse import urljoin

def process_api_path(api_path, parameters):
    processed_path = api_path
    for param in parameters:
        placeholder = '{' + param['name'] + '}'
        if placeholder in processed_path:
            processed_path = processed_path.replace(placeholder, str(param['value']))
    return processed_path

def lambda_handler(event, context):
    agent = event['agent']
    actionGroup = event['actionGroup']
    apiPath = event['apiPath']
    httpMethod = event['httpMethod']
    parameters = event.get('parameters', [])

    BASE_URL = "https://MYENDPOINT.execute-api.us-east-1.amazonaws.com/dev"

    try:
        processed_path = process_api_path(apiPath, parameters)
        processed_path = processed_path.lstrip('/')
        full_url = f"{BASE_URL}/{processed_path}"

        http = urllib3.PoolManager()
        response = http.request('GET', full_url)
        response_data = json.loads(response.data.decode('utf-8'))

        responseBody = {
            "application/json": {
                "body": response_data
            }
        }

        action_response = {
            'actionGroup': actionGroup,
            'apiPath': apiPath,
            'httpMethod': httpMethod,
            'httpStatusCode': response.status,
            'responseBody': responseBody
        }

        return {
            'response': action_response,
            'messageVersion': event['messageVersion']
        }

    except Exception as e:
        error_response = {
            'actionGroup': actionGroup,
            'apiPath': apiPath,
            'httpMethod': httpMethod,
            'httpStatusCode': 500,
            'responseBody': {
                "application/json": {
                    "body": f"Error calling API: {str(e)}"
                }
            }
        }
        return {
            'response': error_response,
            'messageVersion': event['messageVersion']
        }
```
