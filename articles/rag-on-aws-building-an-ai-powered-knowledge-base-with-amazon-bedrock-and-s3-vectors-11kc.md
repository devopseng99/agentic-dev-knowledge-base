---
title: "RAG on AWS: Building an AI-powered Knowledge Base with Amazon Bedrock and S3 Vectors"
url: "https://dev.to/aws-builders/rag-on-aws-building-an-ai-powered-knowledge-base-with-amazon-bedrock-and-s3-vectors-11kc"
author: "Davide De Sio"
category: "knowledge-base-embeddings"
---

# RAG on AWS: Building an AI-powered Knowledge Base with Amazon Bedrock and S3 Vectors

**Author:** Davide De Sio
**Published:** September 2, 2025

## Overview
AWS released Amazon S3 Vectors as native vector storage inside S3, capable of storing and querying billions of vectors with sub-second latency at approximately 90% cost reduction compared to traditional vector databases.

## Key Concepts

### S3 Vectors
The first cloud object store with native vector support. Provides integrated APIs within S3 for embedding storage and retrieval.

### Benefits
- 90% cost savings compared to traditional vector databases
- Sub-second query performance at scale
- Leverages S3 durability and elasticity
- Seamless integration with Bedrock Knowledge Bases

### Limitations (Preview)
- Still in preview, not production-ready
- Lacks CloudFormation integration
- No CDK support yet
- Critical barriers for enterprise infrastructure-as-code deployments
