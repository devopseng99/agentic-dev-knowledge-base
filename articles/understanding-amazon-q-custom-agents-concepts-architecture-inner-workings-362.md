---
title: "Understanding Amazon Q Custom Agents: Concepts, Architecture & Inner Workings"
url: "https://dev.to/aws-builders/understanding-amazon-q-custom-agents-concepts-architecture-inner-workings-362"
author: "Sarvar Nadaf"
category: "aws-agents"
---

# Understanding Amazon Q Custom Agents: Concepts, Architecture & Inner Workings
**Author:** Sarvar Nadaf
**Published:** December 2, 2025

## Overview
Comprehensive guide to Amazon Q Custom Agents covering three agent types, knowledge base architecture, indexing strategies, storage options, deployment types, pricing, and security features.

## Key Concepts

### Three Agent Types
1. **Knowledge Base Agents** - Answer questions using documents, wikis, internal sources
2. **Action Agents** - Execute tasks through APIs and AWS service integrations
3. **Hybrid Agents** - Combine information retrieval with task execution

### Architecture Workflow

```
User Question
    |
Amazon Q Agent
    |
Processing Logic
    |
Document Search <- Knowledge Base
    |
Response Generation
    |
User Answer / Action Execution -> AWS Services
```

### Pricing
- Amazon Q Business Pro: $20/user/month
- Amazon Q Business Lite: $3/user/month
- Document Processing: $0.10 per 1,000 documents
- Vector Storage: $0.30/GB monthly
- Query Processing: $0.004 per query

### Integration Options
- Direct: SharePoint, Salesforce, ServiceNow, Confluence, Jira, Teams, Slack
- Custom: REST APIs, databases, file crawlers, Kinesis streams, Git repositories

### Deployment Types
1. Single-Region - Simple, cost-efficient
2. Multi-Region - Global availability
3. Hybrid - Local control with cloud scalability
