---
title: "Solutions Architect Agent using Knowledge Bases for Amazon Bedrock"
url: "https://dev.to/vivekpophale/solutions-architect-agent-using-knowledge-bases-for-amazon-bedrock-5he3"
author: "vivekpophale"
category: "knowledge-base-embeddings"
---

# Solutions Architect Agent using Knowledge Bases for Amazon Bedrock

**Author:** vivekpophale
**Published:** March 16, 2025

## Overview
Demonstrates rapid Knowledge Base and RAG setup using AWS Well Architected Framework and Cloud Adoption Framework documentation for solution architect-level responses.

## Key Concepts

### RAG Two-Step Process
1. Retrieve relevant information from knowledge base using a retriever
2. Generate responses based on retrieved information and input query

### Implementation Steps
1. Download AWS documentation and upload to S3
2. Create Knowledge Base on Bedrock with vector store
3. Define S3 document location
4. Select parsing and chunking strategy
5. Choose embedding model (Amazon Titan) and vector store (OpenSearch)
6. Sync data source
7. Select model for chat (Claude 3.5 Sonnet)
8. Customize prompt template
9. Test with queries like "How to deploy AWS Glue securely"
10. Create agent, add knowledge base, prepare and test

### Key Feature
Responses include information source references visible via show details option, enabling verification of answers against source documents.
