---
title: "Amazon Nova Powered AI Claims Assistant"
url: "https://dev.to/aws-builders/amazon-nova-powered-ai-claims-assistant-42p1"
author: "Harsha Mathan"
category: "domain-agents"
---

# Amazon Nova Powered AI Claims Assistant
**Author:** Harsha Mathan
**Published:** April 20, 2025

## Overview
Demonstrates building an AI-powered insurance claims assistant using Amazon Bedrock and the Nova model. The system analyzes adjuster notes to produce summaries, fraud risk indicators, and a 0-10 fraud risk score. Scoring: 0-3 (low risk/legitimate), 4-6 (moderate/needs review), 7-10 (high risk/red flags).

## Key Concepts
Implementation uses a Lambda function with boto3 that accepts JSON claim notes and invokes the Amazon Nova Pro model via Bedrock API. IAM policy grants `bedrock:InvokeModel` permissions. Future enhancements include API Gateway integration, Step Functions orchestration, and S3 storage.
