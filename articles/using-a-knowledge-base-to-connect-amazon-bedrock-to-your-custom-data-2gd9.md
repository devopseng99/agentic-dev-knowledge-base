---
title: "Configuring an Amazon Bedrock Knowledge Base"
url: "https://dev.to/aws-builders/using-a-knowledge-base-to-connect-amazon-bedrock-to-your-custom-data-2gd9"
author: "Faye Ellis"
category: "aws-agents"
---

# Configuring an Amazon Bedrock Knowledge Base
**Author:** Faye Ellis
**Published:** April 21, 2024

## Overview
Step-by-step tutorial for setting up Knowledge Bases with Amazon Bedrock using S3, OpenSearch Serverless for vector storage, and SageMaker Notebook. Costs under $5 with cleanup. Prevents hallucinations by restricting responses to indexed data.

## Key Concepts

### Architecture
- SageMaker Notebook as IDE
- S3 for document storage (PDF, CSV, Word, text)
- Amazon OpenSearch Serverless (AOSS) for vector indexes
- Bedrock Knowledge Base connecting AOSS to foundation models

### Implementation Steps
1. Library Installation (boto3, opensearch-py)
2. S3 Bucket Creation
3. OpenSearch Collection creation
4. Vector Index Generation
5. Knowledge Base Configuration linking Bedrock to OpenSearch
6. Data Ingestion

### Key Benefit
Model returns "I don't know" for unsupported queries, ensuring accuracy and preventing hallucinations through data governance.
