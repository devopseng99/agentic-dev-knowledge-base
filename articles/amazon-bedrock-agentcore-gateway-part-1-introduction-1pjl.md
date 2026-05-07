---
title: "Amazon Bedrock AgentCore Gateway - Part 1 Introduction"
url: "https://dev.to/aws-heroes/amazon-bedrock-agentcore-gateway-part-1-introduction-1pjl"
author: "Vadym Kazulkin"
category: "ai-agent-api-gateway"
---

# Amazon Bedrock AgentCore Gateway - Part 1 Introduction

**Author:** Vadym Kazulkin (AWS Heroes)
**Published:** August 7, 2025

## Overview
AgentCore Gateway transforms existing APIs and Lambda functions into MCP-compatible agent-ready tools.

## Key Concepts

### AgentCore Services (7 Capabilities)
1. **Runtime** - Low-latency serverless with session isolation
2. **Memory** - Session and long-term memory management
3. **Observability** - Step-by-step execution visualization
4. **Identity** - Secure access to AWS and third-party tools
5. **Gateway** - API/Lambda to MCP tool conversion
6. **Browser** - Managed web browser instances
7. **Code Interpreter** - Isolated code execution environments

### Gateway Concepts
- **Gateway** - MCP server providing single access point
- **Gateway Target** - Defines APIs/Lambda as tools
- **Authorizer** - OAuth authorization management
- **Credential Provider** - Credential storage for API access

### Supported Tool Types
- OpenAPI specifications
- Lambda functions
- Smithy models

### CloudWatch Metrics
Invocations, Throttles (429), System Errors (5xx), User Errors (4xx), Latency, Duration, TargetExecutionTime
