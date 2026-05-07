---
title: "Orchestrating AI multi-agent infrastructure with AWS Bedrock, OpenAI and n8n"
url: "https://dev.to/aws-builders/orchestrating-ai-multi-agent-infrastructure-with-aws-bedrock-openai-and-n8n-28p6"
author: "Roman Tsypuk"
category: "aws-agents"
---

# Orchestrating AI multi-agent infrastructure with AWS Bedrock, OpenAI and n8n
**Author:** Roman Tsypuk
**Published:** September 26, 2025

## Overview
No-code multi-agent AI ecosystem using n8n, AWS Bedrock, OpenAI, and MCP servers. Each agent has its own model and memory storage. Demonstrates agent-to-agent communication, AWS documentation MCP integration, and hybrid model selection for cost optimization.

## Key Concepts

### Architecture
- Documentation Agent: connects to AWS docs via MCP
- News Agent: pulls JSON feeds from curated AWS news
- Orchestrator Agent: routes requests to appropriate specialist agents

### AWS MCP Configuration

| Parameter | Value |
|-----------|-------|
| Endpoint | https://knowledge-mcp.global.api.aws |
| Server Transport | HTTP streamable |
| Authentication | none |
| Tools | read, recommend, search |

### Memory Storage Schema

```sql
create table n8n_chat_reseach_histories
(
    id         serial primary key,
    session_id varchar(255) not null,
    message    jsonb        not null
);
```

### Cost Optimization
- Use lightweight models (Nano GPT-5.1) for simple lookups
- Use powerful models (Bedrock Claude 3.5 Sonnet) for reasoning-heavy prompts
- Each agent can have a different model tuned for its role

### Key Takeaway
Full multi-agent ecosystem built entirely without code using n8n orchestration, with persistent memory, MCP integration, and visual debugging.
