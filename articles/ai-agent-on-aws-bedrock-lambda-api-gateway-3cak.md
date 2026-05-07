---
title: "Launching Your AI Agent on AWS: Bedrock, Lambda & API Gateway"
url: "https://dev.to/sergioestebance/ai-agent-on-aws-bedrock-lambda-api-gateway-3cak"
author: "Sergio Esteban"
category: "aws-agents"
---

# Launching Your AI Agent on AWS: Bedrock, Lambda & API Gateway
**Author:** Sergio Esteban
**Published:** November 8, 2025

## Overview
Complete serverless AI service using API Gateway, Lambda, and Bedrock Nova Micro. TypeScript implementation with Docker containerization, Terraform IaC, and GitHub Actions CI/CD. Cost analysis: <$0.01/month at 100 requests, $3.76/month at 100K requests. Uses @ai-sdk/amazon-bedrock for Bedrock integration with multi-stage Docker builds targeting Lambda Node.js 22 runtime.

## Key Concepts

### Architecture
- API Gateway (HTTP v2) -> Lambda (Node.js 22, container image) -> Bedrock Nova Micro
- ECR for Docker image storage (~300MB)
- CloudWatch JSON logging for observability

### Cost Breakdown (100 requests/month)
- Bedrock: ~$0.003 (22 input tokens, 232 output tokens per request)
- Lambda: Free tier (1M requests/month)
- API Gateway: $0.0004
- At 100K requests: $3.76/month

### Technology Stack
- TypeScript + Node.js 22
- @ai-sdk/amazon-bedrock + ai library
- Zod for validation
- Terraform with AWS modules
- GitHub Actions with OIDC authentication
- Multi-stage Docker (Alpine builder -> Lambda runtime)

## Code Examples

### Lambda Handler (index.ts)
```typescript
import { main } from "./app";

export const handler = async (event: any, context: any) => {
    try {
        const body = event.body ? JSON.parse(event.body) : {};
        const prompt = body.prompt ?? "Welcome from Warike technologies - GenAI solutions architecture";
        const response = await main(prompt);
        return {
            statusCode: 200,
            body: JSON.stringify({
                success: true,
                data: response,
            }),
        };
    } catch (error) {
        console.error('Error in Lambda handler:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({
                success: false,
                error: error instanceof Error ? error.message : 'An unexpected error occurred'
            }),
        };
    }
};
```

### Bedrock Integration (utils/bedrock.ts)
```typescript
import { config } from "./config";
import { createAmazonBedrock } from '@ai-sdk/amazon-bedrock';
import { generateText } from 'ai';

export async function generateResponse(prompt: string){
  const { regionId, modelId } = config({ });
  try {
    const bedrock = createAmazonBedrock({
        region: regionId
    });

    const { text, usage } = await generateText({
        model: bedrock(modelId),
        system: "You are a helpful assistant.",
        prompt: [
          { role: "user", content: prompt },
        ],
        });
    console.log(`model: ${modelId}, \n response: ${text}, usage: ${JSON.stringify(usage)}`);
    return text;

  } catch (error) {
    console.log(`ERROR: Can't invoke '${modelId}'. Reason: ${error}`);
  }
}
```

### Dockerfile (Multi-Stage)
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

### Terraform: API Gateway
```hcl
module "warike_development_api_gw" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "5.4.1"

  name          = local.api_gateway_name
  description   = "API Gateway for ${local.project_name}"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["*"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  stage_name = "dev"

  routes = {
    "POST /" = {
      integration = {
        uri                    = module.warike_development_lambda.lambda_function_arn
        payload_format_version = "2.0"
      }
    }
  }
}
```

### Terraform: Bedrock IAM Policy
```hcl
locals {
  model_id = "amazon.nova-micro-v1:0"
}

data "aws_bedrock_inference_profile" "warike_development_lambda_bedrock_model" {
  inference_profile_id = "us.${local.model_id}"
}

data "aws_iam_policy_document" "warike_development_lambda_bedrock_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["bedrock:InvokeModel"]
    resources = ["*"]
  }
}
```

### Terraform: Lambda
```hcl
module "warike_development_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "8.1.2"

  function_name           = local.lambda_function_name
  image_uri               = "${aws_ecr_repository.warike_development_ecr.repository_url}:latest"
  package_type            = "Image"
  create_package          = false
  memory_size             = 128
  timeout                 = 900

  environment_variables = local.lambda_env_vars
  create_role           = false
  lambda_role           = aws_iam_role.warike_development_lambda_role.arn
}
```

### GitHub Actions CI/CD
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
      - run: pnpm install --frozen-lockfile
      - run: pnpm audit --audit-level=critical
      - run: pnpm test:ci
      - run: pnpm run build

  build-docker:
    needs: build
    steps:
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_OIDC_ROLE_ARN }}
      - uses: aws-actions/amazon-ecr-login@v2
      - run: |
          docker build -t $DOCKER_IMAGE .
          docker push $DOCKER_IMAGE

  deploy-prod:
    needs: build-docker
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: aws-actions/aws-lambda-deploy@v1.1.0
        with:
          function-name: ${{ secrets.AWS_LAMBDA_FUNCTION_NAME }}
          package-type: Image
          image-uri: ${{ secrets.ECR_REPOSITORY }}:${{ inputs.app-name }}-${{ needs.build-docker.outputs.sha }}
```

### Test
```bash
curl -sS "https://123456.execute-api.us-west-2.amazonaws.com/dev/" \
  -H "Content-Type: application/json" \
  -d '{"prompt":"Heeey hoe gaat het?"}' | jq
```
