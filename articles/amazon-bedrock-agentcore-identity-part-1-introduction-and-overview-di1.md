---
title: "Amazon Bedrock AgentCore Identity - Part 1 Introduction and Overview"
url: "https://dev.to/aws-heroes/amazon-bedrock-agentcore-identity-part-1-introduction-and-overview-di1"
author: "Vadym Kazulkin"
category: "agent-identity"
---

# Amazon Bedrock AgentCore Identity - Part 1 Introduction and Overview
**Author:** Vadym Kazulkin
**Published:** October 20, 2025

## Overview
Amazon Bedrock AgentCore Identity is an identity and credential management service for AI agents and automated workloads. Enables agents to securely access AWS resources and third-party services via Sigv4, OAuth 2.0 flows, and API keys.

## Key Concepts

### Authentication Types
- **Inbound Auth:** Authenticates callers using IAM or JWT tokens from identity providers (Cognito, Okta, Auth0)
- **Outbound Auth:** Uses API keys or OAuth clients for agents to access downstream resources

### Outbound Auth Configuration
- API Key credentials stored in AWS Secrets Manager
- OAuth Client supports included providers (Google, Microsoft, LinkedIn, Slack, GitHub, Salesforce) or custom configuration

### Observability
Tracing can be enabled for Outbound Auth credentials for enhanced monitoring beyond standard AgentCore features.
