---
title: "Agentic AWS - Day 1: Amazon Bedrock AgentCore Gateway"
url: "https://dev.to/suhas_mallesh/agentic-aws-day-1-amazon-bedrock-agentcore-gateway-555l"
author: "Suhas Mallesh"
category: "aws-agents"
---

# Agentic AWS - Day 1: Amazon Bedrock AgentCore Gateway
**Author:** Suhas Mallesh
**Published:** April 23, 2026

## Overview
Hands-on guide provisioning AgentCore Gateway via Terraform, registering a Lambda function as a tool target, and connecting a Bedrock-powered agent using MCP streamable HTTP transport. AgentCore Gateway is a fully managed MCP server that converts Lambda functions and OpenAPI specs into agent-ready tools with built-in auth, routing, and semantic tool discovery.

## Key Concepts

### Architecture

```
Bedrock Agent (Python + MCP client)
        |
        | streamable HTTP (MCP protocol)
        v
AgentCore Gateway  <-- IAM inbound auth
        |
        | IAM role assumption
        v
Lambda Target: order-status-tool
        |
        v
DynamoDB (mock order table)
```

### Terraform Infrastructure

```hcl
# variables.tf
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "project_name" {
  description = "Project prefix for resource naming"
  type        = string
  default     = "agentic-aws"
}

variable "semantic_search_enabled" {
  description = "Enable semantic tool search index on the gateway"
  type        = bool
  default     = false
}
```

### Lambda Tool - Order Status

```hcl
resource "aws_lambda_function" "order_tool" {
  function_name    = "${var.project_name}-order-tool-${var.environment}"
  role             = aws_iam_role.order_tool_lambda.arn
  filename         = data.archive_file.order_tool.output_path
  source_code_hash = data.archive_file.order_tool.output_base64sha256
  runtime          = "python3.12"
  handler          = "handler.lambda_handler"
  memory_size      = var.lambda_memory_mb
  timeout          = 30
}
```

### AgentCore Gateway Terraform Resource

```hcl
resource "aws_bedrock_agent_core_gateway" "main" {
  name        = "${var.project_name}-gateway-${var.environment}"
  description = "Agentic AWS - order management tool gateway"
  authorizer_configuration = {
    type = "AWS_IAM"
  }
  search_type = var.semantic_search_enabled ? "SEMANTIC" : "LEXICAL"
}

resource "aws_bedrock_agent_core_gateway_target" "order_tool" {
  gateway_id  = aws_bedrock_agent_core_gateway.main.id
  name        = "order-status-target"
  description = "Retrieves order status and shipment details"
  target_configuration = {
    lambda = {
      lambda_arn       = aws_lambda_function.order_tool.arn
      execution_role   = aws_iam_role.gateway_execution.arn
    }
  }
}
```

### Lambda Handler Implementation

```python
# lambda/order_tool/handler.py
import json
import os
import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["ORDERS_TABLE"])

def get_order_status(order_id: str) -> dict:
    response = table.get_item(Key={"order_id": order_id})
    item = response.get("Item")
    if not item:
        return {"error": f"Order {order_id} not found"}
    return {
        "order_id": item["order_id"],
        "status": item.get("status", "unknown"),
        "carrier": item.get("carrier"),
        "tracking_number": item.get("tracking_number"),
        "estimated_delivery": item.get("estimated_delivery"),
    }

def lambda_handler(event: dict, context) -> dict:
    tool_name = event.get("tool_name", "")
    tool_input = event.get("tool_input", {})
    if tool_name == "get_order_status":
        order_id = tool_input.get("order_id")
        if not order_id:
            return {"error": "order_id is required"}
        result = get_order_status(order_id)
    else:
        result = {"error": f"Unknown tool: {tool_name}"}
    return {"tool_name": tool_name, "tool_result": result}
```

### Python Agent with MCP Client

```python
import asyncio
import boto3
import os
from mcp import ClientSession
from mcp.client.streamable_http import streamablehttp_client
from botocore.auth import SigV4Auth
from botocore.awsrequest import AWSRequest

GATEWAY_ENDPOINT = os.environ["GATEWAY_ENDPOINT"]
AWS_REGION = os.environ.get("AWS_REGION", "us-east-1")
MODEL_ID = "anthropic.claude-3-5-sonnet-20241022-v2:0"

bedrock = boto3.client("bedrock-runtime", region_name=AWS_REGION)

async def run_agent(user_query: str):
    headers = signed_headers(GATEWAY_ENDPOINT)
    async with streamablehttp_client(GATEWAY_ENDPOINT, headers=headers) as (read, write, _):
        async with ClientSession(read, write) as mcp_session:
            await mcp_session.initialize()
            tools_response = await mcp_session.list_tools()
            # Agentic loop with tool calling
            while True:
                response = bedrock.invoke_model(modelId=MODEL_ID, ...)
                if stop_reason == "tool_use":
                    mcp_result = await mcp_session.call_tool(tool_name, tool_input)
                elif stop_reason == "end_turn":
                    break
```

### Decision Framework

| Scenario | Target Type |
|----------|------------|
| Custom business logic, no existing API | Lambda |
| Existing REST API with OpenAPI spec | OpenAPI target |
| Existing MCP server (third-party) | MCP server target |
| Small tool set (< 20 tools) | Lexical search |
| Large tool set (> 20 tools) | Semantic search |
