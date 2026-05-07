---
title: "A 100% Serverless WhatsApp Agent: Go + AWS Lambda + EventBridge"
url: "https://dev.to/pedrosoaresll/a-100-serverless-whatsapp-agent-go-aws-lambda-eventbridge-3ohf"
author: "Pedro Oliveira"
category: "aws-agents"
---

# A 100% Serverless WhatsApp Agent: Go + AWS Lambda + EventBridge
**Author:** Pedro Oliveira
**Published:** December 11, 2025

## Overview
Fully serverless WhatsApp commercial assistant using Go, Lambda, EventBridge Scheduler, DynamoDB, and OpenAI Agents. EventBridge acts as a buffer/delay mechanism to batch user messages before processing.

## Key Concepts

### Architecture
- API Gateway HTTP API v2: webhook endpoints
- Lambda Functions (Go, provided.al2023): verification, message handling, answer generation
- EventBridge Scheduler: buffer + delay mechanism decoupling ingestion from processing
- DynamoDB: messages, conversation memory, entities
- Secrets Manager: WhatsApp API credentials

### Message Flow
1. WhatsApp POSTs to webhook Lambda
2. Message persisted to DynamoDB
3. EventBridge Scheduler scheduled to invoke answer-handler
4. Answer-handler loads conversation memory, concatenates pending messages
5. OpenAI Agent processes with tools (file search, web search constrained to domain)
6. Response sent back via WhatsApp Cloud API

### Agent Configuration (Go)
- Model: gpt-5
- Tools: file search (vector store) + web search constrained to specific domain
- Structured output schema for consistent response format
- Conversation memory via LastResponseID

### Design Benefits
- Scale-to-zero: minimal costs when idle
- Batches multiple messages to reduce API calls
- Resilient: stored messages prevent loss
- CDK infrastructure as code
