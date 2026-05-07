---
title: "How I Built an Autonomous AI Customer Retention Agent with AWS Bedrock AgentCore"
url: "https://dev.to/ajithmanmu/how-i-built-an-autonomous-ai-customer-retention-agent-with-aws-bedrock-agentcore-3ckp"
author: "ajithmanmu"
category: "hackathons"
---

# How I Built an Autonomous AI Customer Retention Agent with AWS Bedrock AgentCore
**Author:** ajithmanmu
**Published:** October 15, 2025

## Overview
An autonomous AI agent for customer retention built for the AWS AI Agent Global Hackathon using Amazon Bedrock AgentCore, Claude 3.7 Sonnet, Amazon Athena, and Cognito dual authentication.

## Key Concepts

### Memory Integration
```python
class CustomerRetentionMemoryHooks:
    def __init__(self, memory_id, customer_id, session_id, region):
        self.memory_client = boto3.client('bedrock-agent-runtime')
        self.memory_id = memory_id
        self.actor_id = customer_id
```

Three memory strategies: USER_PREFERENCE, SEMANTIC, SUMMARIZATION

### Churn Query
```python
query = f"""
SELECT customerid, churn_risk_score, tenure, contract, monthlycharges
FROM telco_augmented_vw
WHERE customerid = '{customer_id}'
"""
```

### Product Catalog Tool
```python
@tool
def get_product_catalog() -> str:
    """Get information about available telecom plans and services."""
    return formatted_catalog_info
```

Three Lambda functions exposed via MCP: Churn Data Query, Retention Offer generation, Web Search. Dual Cognito architecture separating user auth from agent-to-service communication.

### GitHub Repository
- https://github.com/ajithmanmu/customer-retention-agent
- https://github.com/awslabs/amazon-bedrock-agentcore-samples

**Live App:** https://customer-retention-agent.vercel.app/
