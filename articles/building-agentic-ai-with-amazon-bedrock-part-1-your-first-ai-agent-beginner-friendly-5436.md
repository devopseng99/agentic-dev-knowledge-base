---
title: "Building Agentic AI with Amazon Bedrock - Part 1: Your First AI Agent (Beginner Friendly)"
url: "https://dev.to/aws-builders/building-agentic-ai-with-amazon-bedrock-part-1-your-first-ai-agent-beginner-friendly-5436"
author: "Esteban"
category: "bedrock-agent-aws"
---

# Building Agentic AI with Amazon Bedrock - Part 1: Your First AI Agent (Beginner Friendly)

**Author:** Esteban
**Published:** November 14, 2025

## Overview

Beginner-friendly tutorial for building a weather assistant agent using Amazon Bedrock and AWS Lambda. Part 1 of a four-part series covering Foundation Models, Action Groups, and the complete agent lifecycle.

## Key Concepts

### Lambda Function (Python)

```python
import json
import os
import urllib.request
import urllib.parse
from typing import Tuple, Optional, Dict

USER_AGENT = "WeatherAssistant/1.0"

def http_get_json(url: str, headers: Optional[Dict] = None, timeout: int = 8) -> dict:
    req = urllib.request.Request(url, headers=headers or {})
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return json.loads(resp.read().decode("utf-8"))

def geocode_city(city: str) -> Optional[Tuple[float, float]]:
    if not city:
        return None
    params = urllib.parse.urlencode({"q": city, "format": "json", "limit": 1})
    url = f"https://nominatim.openstreetmap.org/search?{params}"
    try:
        results = http_get_json(url, headers={"User-Agent": USER_AGENT})
        if not results:
            return None
        return float(results[0]["lat"]), float(results[0]["lon"])
    except Exception as e:
        print(f"[ERROR] Geocoding failed: {e}")
        return None

def get_grid_endpoints(lat: float, lon: float) -> Tuple[str, str]:
    url = f"https://api.weather.gov/points/{lat:.4f},{lon:.4f}"
    data = http_get_json(url, headers={"User-Agent": USER_AGENT, "Accept": "application/geo+json"})
    props = data.get("properties", {})
    return props["forecast"], props["forecastHourly"]

def lambda_handler(event, context):
    api_path = event.get('apiPath', '/weather')
    http_method = event.get('httpMethod', 'GET')
    parameters = event.get('parameters', [])

    city = None
    mode = "hourly"
    for param in parameters:
        if param['name'] == 'city':
            city = param['value']
        elif param['name'] == 'mode':
            mode = param['value']

    if not city:
        return {
            "messageVersion": "1.0",
            "response": {
                "actionGroup": event.get('actionGroup', 'weather-tools'),
                "apiPath": api_path,
                "httpMethod": http_method,
                "httpStatusCode": 400,
                "responseBody": {"application/json": {"body": json.dumps({"error": "Missing required parameter: city"})}}
            }
        }

    try:
        coords = geocode_city(city)
        if not coords:
            return {"messageVersion": "1.0", "response": {"actionGroup": event.get('actionGroup'), "apiPath": api_path, "httpMethod": http_method, "httpStatusCode": 404, "responseBody": {"application/json": {"body": json.dumps({"error": f"Could not find city: {city}"})}}}}

        lat, lon = coords
        forecast_url, hourly_url = get_grid_endpoints(lat, lon)
        data = get_forecast(hourly_url if mode == "hourly" else forecast_url)
        weather_report = summarize_hourly_24h(data)

        return {"messageVersion": "1.0", "response": {"actionGroup": event.get('actionGroup'), "apiPath": api_path, "httpMethod": http_method, "httpStatusCode": 200, "responseBody": {"application/json": {"body": json.dumps({"weather_report": weather_report})}}}}
    except Exception as e:
        return {"messageVersion": "1.0", "response": {"actionGroup": event.get('actionGroup'), "apiPath": api_path, "httpMethod": http_method, "httpStatusCode": 500, "responseBody": {"application/json": {"body": json.dumps({"error": "Weather service error"})}}}}
```

### Agent Creation Script

```python
import boto3
import json

client = boto3.client('bedrock-agent', region_name='us-east-1')
ROLE_ARN = 'arn:aws:iam::YOUR_ACCOUNT:role/BedrockAgentRole'

response = client.create_agent(
    agentName='weather-assistant',
    agentResourceRoleArn=ROLE_ARN,
    foundationModel='us.anthropic.claude-3-5-sonnet-20241022-v2:0',
    instruction=(
        "You are a helpful weather assistant. "
        "When users ask about weather in any US city, use the getWeather tool "
        "to fetch current conditions and forecasts."
    ),
    idleSessionTTLInSeconds=600
)
agent_id = response['agent']['agentId']
```

### Action Group with OpenAPI Schema

```python
openapi_schema = {
    "openapi": "3.0.0",
    "info": {"title": "Weather API", "version": "1.0.0"},
    "paths": {
        "/weather": {
            "get": {
                "summary": "Get weather forecast",
                "operationId": "getWeather",
                "parameters": [
                    {"name": "city", "in": "query", "required": True, "schema": {"type": "string"}},
                    {"name": "mode", "in": "query", "required": False, "schema": {"type": "string", "enum": ["hourly", "daily"], "default": "hourly"}}
                ]
            }
        }
    }
}

client.create_agent_action_group(
    agentId=AGENT_ID,
    agentVersion='DRAFT',
    actionGroupName='weather-tools',
    actionGroupExecutor={'lambda': LAMBDA_ARN},
    apiSchema={'payload': json.dumps(openapi_schema)},
)
```

### Testing Script

```python
import boto3

client = boto3.client('bedrock-agent-runtime', region_name='us-east-1')

def chat(message):
    response = client.invoke_agent(
        agentId=AGENT_ID,
        agentAliasId=AGENT_ALIAS_ID,
        sessionId='test-session',
        inputText=message,
        enableTrace=True
    )
    for event in response['completion']:
        if 'chunk' in event:
            print(event['chunk']['bytes'].decode('utf-8'), end='', flush=True)
```

### Cost

Approximately $3.00 per month for 1,000 queries.
