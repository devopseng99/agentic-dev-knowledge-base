---
title: "Building AI Agents with Amazon Bedrock AgentCore Runtime: A Complete Setup Guide"
url: "https://dev.to/aws-builders/building-ai-agents-with-amazon-bedrock-agentcore-runtime-a-complete-setup-guide-50oh"
author: "Myron Zaiets"
category: "bedrock-agent-aws"
---

# Building AI Agents with Amazon Bedrock AgentCore Runtime: A Complete Setup Guide

**Author:** Myron Zaiets
**Published:** September 16, 2025

## Overview

Complete guide for deploying AI agents on Amazon Bedrock AgentCore Runtime, a serverless container platform supporting workloads up to 8 hours with session isolation and integrated CloudWatch monitoring. Covers CDK infrastructure, Strands agent framework, and Bedrock Memory integration.

## Key Concepts

### ECR Repository Setup (TypeScript/CDK)

```typescript
const agentRepository = new ecr.Repository(this, 'AgentRepository', {
  repositoryName: 'bedrock-agentcore-sample',
  removalPolicy: cdk.RemovalPolicy.DESTROY,
});
```

### IAM Execution Role (TypeScript/CDK)

```typescript
const executionRole = new iam.Role(this, 'AgentCoreExecutionRole', {
  assumedBy: new iam.ServicePrincipal('bedrock-agentcore.amazonaws.com'),
  inlinePolicies: {
    AgentCorePolicy: new iam.PolicyDocument({
      statements: [
        new iam.PolicyStatement({
          actions: [
            'bedrock:InvokeModel',
            'bedrock-agent:CreateEvent',
            'bedrock-agent:GetMemory',
            'logs:CreateLogGroup',
          ],
          resources: ['*'],
        }),
      ],
    }),
  },
});
```

### Agent Implementation (Python)

```python
from bedrock_agentcore import BedrockAgentCoreApp
from strands import Agent
import boto3

app = BedrockAgentCoreApp()
agent = Agent()

@app.entrypoint
def invoke(payload):
    user_message = payload.get("prompt", "Hello!")
    session_id = "custom-session-12345678901234567890123"

    memory_client = boto3.client('bedrock-agent', region_name='eu-central-1')

    return {"result": result.message, "sessionId": session_id}
```

### Agent Configuration (.bedrock_agentcore.yaml)

```yaml
default_agent: my_agent
agents:
  my_agent:
    name: my_agent
    entrypoint: my_agent.py
    platform: linux/arm64
    aws:
      region: eu-central-1
      network_configuration:
        network_mode: PUBLIC
      observability:
        enabled: true
```

### Memory Integration (Python)

```python
# Store conversation events
memory_client.create_event(
    memoryId=MEMORY_ID,
    actorId=ACTOR_ID,
    sessionId=session_id,
    eventTimestamp=datetime.utcnow(),
    payload={"message": user_message, "role": "user"}
)

# Retrieve conversation context
memory_response = memory_client.get_memory(
    memoryId=MEMORY_ID,
    actorId=ACTOR_ID,
    sessionId=session_id
)
```

### Lambda Handler for API Integration (Python)

```python
import json
import boto3
import uuid
from datetime import datetime

def handler(event, context):
    try:
        body = json.loads(event['body'])
        prompt = body.get('prompt', '')

        client = boto3.client('bedrock-agentcore', region_name='eu-central-1')
        session_id = 'custom-session-12345678901234567890123'

        payload = json.dumps({"prompt": prompt})

        response = client.invoke_agent_runtime(
            agentRuntimeArn='arn:aws:bedrock-agentcore:eu-central-1:{accountId}:runtime/my_agent-{customString}',
            runtimeSessionId=session_id,
            payload=payload,
            qualifier="DEFAULT"
        )

        response_body = b''.join(response['response']).decode('utf-8')
        response_data = json.loads(response_body)

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
            },
            'body': json.dumps({
                'response': response_data['result']['content'][0]['text'],
                'sessionId': session_id
            })
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
```

### Deployment Commands

```bash
npm install
npx cdk bootstrap --region eu-central-1
npx cdk deploy

cd agent
pip install bedrock-agentcore strands-agents bedrock-agentcore-starter-toolkit
agentcore configure -e my_agent.py --region eu-central-1
agentcore launch
```

### Testing

```bash
agentcore invoke '{"prompt": "What can you help me with?"}'
```

## Production Best Practices

- Use least-privilege IAM policies
- Implement session management
- Enable CloudWatch logging
- Configure appropriate memory/CPU limits
- Use ARM64 platform for cost optimization
