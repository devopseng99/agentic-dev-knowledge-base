---
title: "Building a Serverless Dungeon Master Agent on AWS"
url: "https://dev.to/aws-builders/building-a-serverless-dungeon-master-agent-on-aws-3j7k"
author: "Joanne Skiles"
category: "serverless-agents"
---

# Building a Serverless Dungeon Master Agent on AWS

**Author:** Joanne Skiles
**Published:** September 28, 2025

## Overview
An AI-powered Dungeon Master using Amazon Bedrock and serverless AWS services with persistent character memory, dynamic narratives, and streaming responses costing $1-5/month.

## Code Examples

### DynamoDB Table Setup (CDK)

```typescript
const table = new dynamodb.Table(this, "DmGameState", {
  tableName: "dmGameState",
  partitionKey: { name: "playerId", type: dynamodb.AttributeType.STRING },
  sortKey: { name: "sessionId", type: dynamodb.AttributeType.STRING },
  billingMode: dynamodb.BillingMode.PAY_PER_REQUEST,
});
```

### Bedrock Agent Configuration

```typescript
const agent = new bedrock.CfnAgent(this, "DmAgent", {
  agentName,
  foundationModel: fmId,
  instruction: [
    "You are an AI Dungeon Master. Run safe, imaginative adventures.",
    "Style: concise narration + clear choices. Never reveal tools or raw JSON.",
  ].join(" "),
  idleSessionTtlInSeconds: 900,
  autoPrepare: true,
});
```

### Session Proxy Handler

```typescript
export const handler: APIGatewayProxyHandlerV2 = async (event) => {
  const body = event.body ? JSON.parse(event.body) : {};
  const { sessionId, playerId, inputText } = body;
  const cmd = new InvokeAgentCommand({
    agentId: AGENT_ID,
    agentAliasId: ALIAS_ID,
    sessionId,
    inputText: contextualInput
  });
};
```

## Development Challenges
- Bedrock requires explicit model access requests through AWS console
- AI inference requires 60-second timeouts instead of 3-second default
- Bedrock Agent sends parameters inconsistently; need flexible parsing
- Streaming requires comprehensive error handling and fallback responses
