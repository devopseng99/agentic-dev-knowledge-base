---
title: "Tutorial: Build an Agentic AI Application with Agents for Amazon Bedrock"
url: "https://dev.to/aws-builders/tutorial-build-an-agentic-ai-application-with-agents-for-amazon-bedrock-2cpk"
author: "Faye Ellis"
category: "bedrock-agent-aws"
---

# Tutorial: Build an Agentic AI Application with Agents for Amazon Bedrock

**Author:** Faye Ellis
**Published:** March 11, 2025

## Overview

Tutorial demonstrating building an agentic AI application using Amazon Bedrock agents to automate teacher appointment bookings with Lambda functions and DynamoDB.

## Key Concepts

### Architecture Components

1. **Amazon Bedrock** - API access to Claude 3 Sonnet foundation model
2. **Amazon Bedrock Agent** - User reasoning and request fulfillment
3. **Amazon Bedrock Action Group** - Defines available agent actions
4. **Lambda Function** - Executes API calls for DynamoDB operations
5. **DynamoDB** - Stores appointment and teacher data
6. **SageMaker Jupyter Notebook** - Development environment

### Implementation

Uses a CloudFormation template creating a SageMaker notebook with configured IAM permissions for Bedrock, DynamoDB, Lambda, and IAM services. The GitHub repository (`bedrock-agent-demo`) contains a Jupyter notebook that:

- Installs boto3 SDK
- Creates and populates two DynamoDB tables
- Develops a Lambda function with three capabilities
- Establishes agent and action group configurations

### Example Prompts

- "Who teaches Sociology?"
- "Book the first available appointment with the I.T. teacher"
- "When is the history teacher available?"
- "List all Miss White's appointments"
- "Cancel the 18:30 appointment with Mr Stokes"

### Cost

Estimated under $5 with proper cleanup.
