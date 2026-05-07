---
title: "Part 1: Why I Chose Amazon Bedrock AgentCore (And What Lambda Gets Wrong for AI Agents)"
url: "https://dev.to/rajmurugan/part-1-why-i-chose-amazon-bedrock-agentcore-and-what-lambda-gets-wrong-for-ai-agents-jm3"
author: "Raj Murugan"
category: "serverless-agents"
---

# Why I Chose Amazon Bedrock AgentCore (And What Lambda Gets Wrong for AI Agents)

**Author:** Raj Murugan
**Published:** March 30, 2026

## Overview
A production AI agent built on AWS -- not a demo but a real system with persistent memory, guardrails, and CI/CD pipelines. Lambda's constraints become liabilities for stateful, long-running agent workloads.

## Key Concepts

### Lambda's Problems for AI Agents

1. **15-Minute Timeout:** Agentic loops can easily hit 5-10 minutes per complex interaction
2. **Session State:** Requires external storage (DynamoDB, ElastiCache) with complex lifecycle management
3. **Cross-Session Memory:** Needs vector databases, summarization pipelines, retrieval systems

### AgentCore Architecture

AgentCore is a managed container orchestrator for stateful AI agent sessions:
- Container lifecycle management
- Session routing to appropriate instances
- Built-in memory persistence (Semantic, Summary, UserPreference strategies)
- JWT validation, VPC networking without cold start penalties
- Server-Sent Events (SSE) streaming

### Architectural Comparison

**Lambda:** User message -> API Gateway -> Lambda (cold start) -> load session from DynamoDB -> call Bedrock -> save session -> return -> Lambda exits

**AgentCore:** User message -> AgentCore Runtime (JWT validated) -> warm container -> call Bedrock -> streaming response -> container stays warm

### Production Stack
- CI/CD: GitHub Actions with OIDC
- Registry: Amazon ECR
- Infrastructure: CDK v2 TypeScript
- Runtime: AgentCore with Cognito JWT
- Protocol: AG-UI HTTP with SSE streaming
- Primary Model: Claude Sonnet 4.6 with prompt caching
- Secondary Model: Amazon Nova Pro for classification
