---
title: "How I built my AWS AI assistant: Integrating Amazon Bedrock Agents with Slack"
url: "https://dev.to/aws-builders/how-i-built-my-aws-ai-assistant-integrating-amazon-bedrock-agents-with-slack-3e8n"
author: "Artur Schneider"
category: "ai-agent-slack-bot"
---

# How I built my AWS AI assistant: Integrating Amazon Bedrock Agents with Slack

**Author:** Artur Schneider
**Published:** April 1, 2025

## Overview
Build an AI-powered AWS assistant connecting Amazon Bedrock Agents with Slack. Includes Slack signature verification, event deduplication, user authorization, and least-privilege IAM policies. Architecture: Slack App -> API Gateway -> Lambda -> Bedrock Agent.

## Key Concepts

### Security Requirements
- Least privilege IAM permissions for Lambda functions
- Slack signature verification for request authentication
- User authorization via optional whitelist
- Secure token storage using AWS Secrets Manager

## Code Examples

### EC2 Operations Lambda

```python
import json
import boto3
import traceback
import datetime

def lambda_handler(event, context):
    agent = event['agent']
    actionGroup = event['actionGroup']
    apiPath = event['apiPath']
    httpMethod = event['httpMethod']
    parameters = event.get('parameters', [])

    if isinstance(parameters, list):
        parameters_dict = {}
        for param in parameters:
            if isinstance(param, dict) and 'name' in param:
                parameters_dict[param['name']] = param['value']
        parameters = parameters_dict

    try:
        if apiPath == '/instances':
            result = describe_instances(parameters)
            responseBody = {
                "application/json": {
                    "body": json.dumps(result)
                }
            }

        action_response = {
            'actionGroup': actionGroup,
            'apiPath': apiPath,
            'httpMethod': httpMethod,
            'httpStatusCode': 200,
            'responseBody': responseBody
        }

        return {
            'response': action_response,
            'messageVersion': event['messageVersion']
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {"statusCode": 500}

def describe_instances(parameters):
    region = parameters.get('region', 'us-east-1')
    instance_id = parameters.get('instanceId', None)
    ec2 = boto3.client('ec2', region_name=region)
    filters = []
    if instance_id:
        filters.append({'Name': 'instance-id', 'Values': [instance_id]})

    instances = []
    paginator = ec2.get_paginator('describe_instances')
    page_iterator = paginator.paginate(
        Filters=filters if filters else [],
        PaginationConfig={'MaxItems': 100, 'PageSize': 20}
    )

    for page in page_iterator:
        for reservation in page['Reservations']:
            for instance in reservation['Instances']:
                instances.append({
                    'InstanceId': instance['InstanceId'],
                    'InstanceType': instance['InstanceType'],
                    'State': instance['State']['Name'],
                    'LaunchTime': instance['LaunchTime'].isoformat(),
                    'PublicIpAddress': instance.get('PublicIpAddress', 'N/A'),
                    'PrivateIpAddress': instance.get('PrivateIpAddress', 'N/A')
                })
    return {'Instances': instances, 'Count': len(instances), 'Region': region}
```

### Slack Handler Lambda with Signature Verification

```python
import os, json, hmac, hashlib, boto3, time
from datetime import datetime, timedelta

BEDROCK_AGENT_ID = os.environ.get("BEDROCK_AGENT_ID")
BEDROCK_AGENT_ALIAS = os.environ.get("BEDROCK_AGENT_ALIAS")
SLACK_BOT_TOKEN = os.environ.get("SLACK_BOT_TOKEN")
SLACK_SIGNING_SECRET = os.environ.get("SLACK_SIGNING_SECRET")

bedrock_client = boto3.client("bedrock-agent-runtime", region_name="eu-central-1")
processed_events = {}

def lambda_handler(event, context):
    body = event.get('body')
    slack_event = json.loads(body)

    if slack_event.get("type") == "url_verification":
        return {"statusCode": 200, "body": slack_event.get("challenge", "")}

    headers = event.get('headers', {})
    timestamp = headers.get('x-slack-request-timestamp')
    signature = headers.get('x-slack-signature')
    if not verify_slack_signature(SLACK_SIGNING_SECRET, body, timestamp, signature):
        return {"statusCode": 401, "body": "Invalid signature"}

    if "event" in slack_event:
        event_info = slack_event["event"]
        user_id = event_info.get("user")
        text = event_info.get("text", "")
        channel_id = event_info.get("channel")

        if event_info.get("bot_id") or user_id is None:
            return {"statusCode": 200}

        # Event deduplication
        event_id = slack_event.get("event_id")
        now = datetime.now()
        if event_id in processed_events:
            if now - processed_events[event_id] < timedelta(minutes=5):
                return {"statusCode": 200}
        processed_events[event_id] = now

        response = bedrock_client.invoke_agent(
            agentId=BEDROCK_AGENT_ID,
            agentAliasId=BEDROCK_AGENT_ALIAS,
            sessionId=channel_id,
            inputText=text
        )

        answer = ""
        for chunk in response.get("completion", []):
            answer += chunk["chunk"]["bytes"].decode('utf-8')

        send_slack_message(channel_id, answer)
    return {"statusCode": 200}

def verify_slack_signature(signing_secret, request_body, timestamp, signature):
    req = str.encode('v0:' + str(timestamp) + ':' + request_body)
    secret = str.encode(signing_secret)
    hash_hex = 'v0=' + hmac.new(secret, req, hashlib.sha256).hexdigest()
    return hmac.compare_digest(hash_hex, signature)
```

### OpenAPI Schema for Action Group

```yaml
openapi: "3.0.1"
info:
  title: "EC2 Management API"
  version: "1.0.0"
paths:
  /instances:
    get:
      operationId: listInstances
      summary: "List running EC2 instances in a region"
      parameters:
        - in: query
          name: region
          required: true
          schema:
            type: string
      responses:
        '200':
          description: "Success"
```

### IAM Policies

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ec2:DescribeInstances"],
      "Resource": "*"
    }
  ]
}
```
