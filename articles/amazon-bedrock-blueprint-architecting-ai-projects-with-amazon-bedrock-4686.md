---
title: "Amazon Bedrock Blueprint: Architecting AI Projects with Amazon Bedrock"
url: "https://dev.to/aws-builders/amazon-bedrock-blueprint-architecting-ai-projects-with-amazon-bedrock-4686"
author: "NaDia"
category: "knowledge-base-embeddings"
---

# Amazon Bedrock Blueprint: Architecting AI Projects with Amazon Bedrock

**Author:** NaDia (ronakreyhani)
**Published:** April 29, 2024

## Overview
A comprehensive overview of Amazon Bedrock components and integration workflows for generative AI projects, covering foundational models, knowledge bases, and agent workflows.

## Key Concepts

### Components
- **Foundational Models:** AI21 Labs, Anthropic, Cohere, Meta, Mistral AI, Stability AI, Amazon
- **Knowledge Base:** Addresses model limitations via RetrieveAndGenerate API and Retrieve API
- **Agents:** Automate prompt engineering using ReAct strategies (Reason, Action, Observation)

### Common Workflows

**Basic Model Invocation:** Event-driven (S3 triggers) or Application API (Lambda)

**RAG Applications:** S3 documents -> chunking -> embedding -> vector DB (OpenSearch) -> similarity search -> augmented prompt -> response

**Agent-Based Workflows:** Agents use ReAct methodology to reason on queries, act by calling APIs or Knowledge Base, and observe results to incorporate into prompts.

### Selection Guide
- Simple historical queries: Prompt engineering
- Complex domain-specific: Fine-tuning
- Static data (docs, FAQs): Knowledge Base alone
- Dynamic info (databases, APIs): Agents with Knowledge Base
