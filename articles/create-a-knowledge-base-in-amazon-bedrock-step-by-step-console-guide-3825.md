---
title: "Create a Knowledge Base in Amazon Bedrock (Step-by-Step Console Guide)"
url: "https://dev.to/dipayan_das/create-a-knowledge-base-in-amazon-bedrock-step-by-step-console-guide-3825"
author: "Dipayan Das"
category: "knowledge-base-embeddings"
---

# Create a Knowledge Base in Amazon Bedrock (Step-by-Step Console Guide)

**Author:** Dipayan Das
**Published:** December 16, 2025

## Overview
Step-by-step walkthrough for establishing an Amazon Bedrock Knowledge Base via the AWS console for RAG capabilities.

## Key Concepts

### Embedding and Vector Store Options
- Amazon OpenSearch Serverless (recommended)
- Aurora PostgreSQL with pgvector
- Neptune Analytics for GraphRAG

### Parsing Strategies
- **Default Parser:** Best for text-heavy PDFs and documents
- **Data Automation Parser:** Handles multimodal content including images and audio
- **Foundation Models Parser:** Processes complex layouts and structured documents

### Chunking
Default chunking splits text into approximately 500 tokens with overlap preservation for context continuity.

### Setup Steps
1. Navigate to Amazon Bedrock, select Knowledge Bases
2. Configure name, description, tags
3. Set data source (S3)
4. Select parsing and chunking strategy
5. Choose embedding model (Amazon Titan or Cohere) and vector store
6. Review, create, sync, and test
