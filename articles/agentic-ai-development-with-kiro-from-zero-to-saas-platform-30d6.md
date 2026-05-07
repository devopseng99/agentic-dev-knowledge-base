---
title: "Agentic AI Development with Kiro: From Zero to SaaS Platform"
url: "https://dev.to/aws-builders/agentic-ai-development-with-kiro-from-zero-to-saas-platform-30d6"
author: "Alejandro Velez"
category: "aws-agents"
---

# Agentic AI Development with Kiro: From Zero to SaaS Platform
**Author:** Alejandro Velez
**Published:** November 20, 2025

## Overview
Case study on building a production-ready SaaS platform (Athleon -- multi-tenant calisthenics competition management) using Kiro's spec-driven agentic AI development. Combines serverless AWS architecture (Lambda, DynamoDB, API Gateway, Cognito, EventBridge, CDK) with MCP servers for extending AI capabilities. Emphasizes that agentic AI accelerates development while human supervision maintains quality.

## Key Concepts

### Kiro Spec-Driven Methodology
- Three-phase transformation: Requirements (EARS notation) -> Design -> Tasks
- Steering files define product, tech stack, project structure, conventions
- Discrete, trackable implementation steps mapped to requirements

### Architecture
- **Compute:** AWS Lambda (Node.js 18.x)
- **Database:** DynamoDB single-table-per-domain
- **API:** API Gateway with Cognito authorizers
- **Auth:** Amazon Cognito User Pools with custom role attributes
- **Events:** EventBridge domain + central event buses
- **Storage:** S3 for event images
- **IaC:** AWS CDK (TypeScript)

### Frontend Stack
- React 18 + Vite, React Router v6
- Zustand + React Query for state
- AWS Amplify v6 for auth
- Playwright for E2E testing

### RBAC Implementation
- Pre-signup Lambda Trigger validates role, rejects super_admin
- Pre-token Generation Trigger adds role to JWT claims
- Custom attribute `custom:role` in Cognito

### MCP Integration
- AWS Labs Core MCP Server for AWS knowledge
- Playwright MCP for browser automation
- Limited to ~50 tools to prevent performance degradation

## Code Examples

### MCP Configuration
```json
{
  "mcpServers": {
    "awslabs.core-mcp-server": {
      "command": "uv",
      "args": [
        "tool",
        "run",
        "--from",
        "awslabs.core-mcp-server@latest",
        "awslabs.core-mcp-server.exe"
      ],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR",
        "AWS_PROFILE": "labvel-dev",
        "AWS_REGION": "us-east-2",
        "aws-foundation": "true",
        "solutions-architect": "true"
      },
      "disabled": false,
      "disabledTools": [
        "aws_knowledge_aws___get_regional_availability",
        "aws_knowledge_aws___list_regions",
        "pricing_get_bedrock_patterns",
        "cost_explorer_get_cost_comparison_drivers"
      ]
    },
    "playwright": {
      "command": "npx",
      "args": [
        "@playwright/mcp@latest"
      ],
      "disabled": false
    }
  }
}
```

### Tech Stack Definition (tech.md)
```yaml
# Tech Stack

## Infrastructure

- **IaC**: AWS CDK (TypeScript)
- **Compute**: AWS Lambda (Node.js 18.x)
- **Database**: DynamoDB (single-table per domain)
- **API**: API Gateway REST API with Cognito authorizer
- **Auth**: Amazon Cognito User Pools
- **Storage**: S3 (event images)
- **Events**: EventBridge (domain event bus + central bus)
- **Deployment**: CDK deploy with esbuild bundling

## Backend

- **Runtime**: Node.js 18.x
- **SDK**: AWS SDK v3 (@aws-sdk/client-*)
- **Testing**: Jest, Vitest, fast-check (property-based testing)
- **Shared Layer**: Lambda layer at `layers/athleon-shared/nodejs`

## Frontend

- **Framework**: React 18 + Vite
- **Routing**: React Router v6
- **State**: Zustand + React Query (@tanstack/react-query)
- **Auth**: AWS Amplify v6
- **UI**: Custom components with @aws-amplify/ui-react
- **i18n**: i18next + react-i18next
- **Testing**: Vitest + React Testing Library
- **E2E**: Playwright (in e2e-tests/)
```

### Requirements Document (EARS format)
```yaml
# Requirements Document

## Introduction

This specification defines a role-based user onboarding system for the Athleon platform
using a single Amazon Cognito User Pool. The system must support three distinct user roles
(athlete, organizer, and super admin) with different access levels and onboarding workflows.
Athletes and organizers can self-register through the frontend with role selection, while
super admins are created exclusively through backend scripts.
```

### Implementation Tasks
```yaml
# Implementation Plan

- [x] 1. Update Pre-Signup Lambda Trigger
  - Modify `lambda/auth/pre-signup-trigger.js` to extract and validate role from signup request
  - Implement logic to accept 'athlete' or 'organizer' roles
  - Implement logic to reject 'super_admin' role with error
  - Default to 'athlete' for missing or invalid roles
  - Add comprehensive CloudWatch logging for all role assignments
  - _Requirements: 1.2, 1.3, 1.4, 1.5, 5.1, 5.2, 5.3, 5.4, 5.5, 8.1, 8.2_

- [x] 1.1 Write property test for pre-signup trigger
  - **Property 1: Role assignment consistency**
  - **Property 2: Super admin rejection**
  - **Property 3: Default role assignment**
```
