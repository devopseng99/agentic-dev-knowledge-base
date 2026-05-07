---
title: "Beyond Chatbots: Building Autonomous Multi-Agent Workflows with Amazon Bedrock and Step Functions"
url: "https://dev.to/aws-builders/beyond-chatbots-building-autonomous-multi-agent-workflows-with-amazon-bedrock-and-step-functions-472d"
author: "Evans Kiprotich"
category: "aws-agents"
---

# Beyond Chatbots: Building Autonomous Multi-Agent Workflows with Amazon Bedrock and Step Functions
**Author:** Evans Kiprotich
**Published:** January 18, 2026

## Overview
Complete implementation guide for autonomous order processing using Bedrock Agents orchestrated by Step Functions. Includes Lambda tool functions, OpenAPI schemas, Boto3 agent creation, CloudFormation templates, and Step Functions state machine definition.

## Key Concepts

### Product Catalog Lambda Tool

```python
def lambda_handler(event, context):
    api_path = event['apiPath']
    parameters = event['parameters']
    if api_path == '/products/{productId}':
        product_id = next(p['value'] for p in parameters if p['name'] == 'productId')
        if product_id == 'PROD123':
            return {'body': json.dumps({"productName": "AWS Widget Pro", "price": 99.99, "inStock": True})}
```

### Bedrock Agent Creation with Boto3

```python
bedrock_agent_client = boto3.client('bedrock-agent')

response = bedrock_agent_client.create_agent(
    agentName='OrderValidationAgent',
    agentResourceRoleArn=agent_role_arn,
    foundationModel='anthropic.claude-v2',
    instruction="You are an order validation assistant. Verify product details using the product catalog tool."
)

bedrock_agent_client.create_agent_action_group(
    agentId=agent_id, agentVersion='DRAFT',
    actionGroupName='ProductCatalogActionGroup',
    actionGroupExecutor={'lambda': product_catalog_lambda_arn},
    apiSchema={'payload': product_catalog_schema}
)
```

### Step Functions State Machine (CloudFormation)

```yaml
"InvokeOrderValidationAgent": {
  "Type": "Task",
  "Resource": "arn:aws:states:::bedrock:invokeAgent",
  "Parameters": {
    "AgentId": "${OrderValidationAgentId}",
    "AgentAliasId": "TSTALIAS",
    "InputText.$": "States.Format('Validate order: {}', $.orderId)"
  },
  "Next": "CheckValidationStatus"
},
"CheckValidationStatus": {
  "Type": "Choice",
  "Choices": [
    {"Variable": "$.validationResult.output.text", "StringContains": "Validation successful", "Next": "InvokeShippingAgent"}
  ],
  "Default": "OrderValidationFailed"
}
```

### Execution

```bash
aws stepfunctions start-execution \
    --state-machine-arn "arn:aws:states:REGION:ACCOUNT:stateMachine:AutonomousOrderProcessingWorkflow" \
    --input '{"orderId": "ORD789", "items": [{"productId": "PROD123", "quantity": 1}]}'
```
