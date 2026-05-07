---
title: "Deploying a Serverless AI Agent with AWS Bedrock, Lambda, and API Gateway"
url: "https://dev.to/swat_24/deploying-a-serverless-ai-agent-with-aws-bedrock-lambda-and-api-gateway-2123"
author: "Swati Tyagi"
category: "serverless-agents"
---

# Deploying a Serverless AI Agent with AWS Bedrock, Lambda, and API Gateway

**Author:** Swati Tyagi
**Published:** December 28, 2025

## Overview
Building a question-answering service using AWS Bedrock Nova Micro model with serverless infrastructure, fully automated via GitHub Actions and Terraform.

## Cost Analysis (100 monthly requests)
- Bedrock (Nova Micro): ~$0.003
- Lambda: Free (free tier)
- API Gateway: Free (Year 1)
- At 100K requests/month: ~$3.76

## Code Examples

### Lambda Handler (TypeScript)

```typescript
export const handler = async (event: any, context: any) => {
    try {
        const body = event.body ? JSON.parse(event.body) : {};
        const prompt = body.prompt ?? "Welcome from Warike technologies";
        const response = await main(prompt);
        return {
            statusCode: 200,
            body: JSON.stringify({ success: true, data: response }),
        };
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({
                success: false,
                error: error instanceof Error ? error.message : 'Unexpected error'
            }),
        };
    }
};
```

### Bedrock Integration

```typescript
export async function generateResponse(prompt: string) {
    const { regionId, modelId } = config({});
    const bedrock = createAmazonBedrock({ region: regionId });
    const { text, usage } = await generateText({
        model: bedrock(modelId),
        system: "You are a helpful assistant.",
        prompt: [{ role: "user", content: prompt }],
    });
    return text;
}
```

### Dockerfile

```dockerfile
FROM node:22-alpine AS builder
WORKDIR /usr/src/app
RUN corepack enable
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm run build

FROM public.ecr.aws/lambda/nodejs:22
WORKDIR ${LAMBDA_TASK_ROOT}
COPY --from=builder /usr/src/app/dist/src ./
COPY --from=builder /usr/src/app/node_modules ./node_modules
CMD [ "index.handler" ]
```
