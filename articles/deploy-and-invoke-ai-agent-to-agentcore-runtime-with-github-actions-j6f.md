---
title: "Deploy and Invoke AI Agent to AgentCore Runtime with Github Actions"
url: "https://dev.to/budionosan/deploy-and-invoke-ai-agent-to-agentcore-runtime-with-github-actions-j6f"
author: "Budiono Santoso"
category: "ai-agent-github-actions-ci"
---

# Deploy and Invoke AI Agent to AgentCore Runtime with Github Actions

**Author:** Budiono Santoso
**Published:** January 28, 2026

## Overview
Automating AI agent deployment and testing using GitHub Actions CI/CD integrated with AWS Bedrock AgentCore Runtime using LangGraph.

## Key Concepts

### Requirements
- AWS account with credentials
- Google Gemini account
- LangGraph framework
- GitHub account with secrets configured

### Workflow Structure
- Deployment job to AgentCore Runtime
- Test job for agent invocation
- Job dependency structure

### Key Configuration
- `auto_create_execution_role=False` for existing IAM roles
- ECR permissions require wildcard (`/*`) for AgentCore Runtime
- GitHub secrets: AWSACCESSKEY and AWSSECRETKEY

**Repository:** github.com/budionosanai/agentcore-runtime-github-actions
