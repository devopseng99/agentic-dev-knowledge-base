---
title: "AI powered PostgreSQL Test Data Generation Tool (Cloudflare AI Challenge)"
url: "https://dev.to/njabulomajozi/ai-powered-postgresql-test-data-generation-tool-cloudflare-ai-challenge-4572"
author: "Njabulo Majozi"
category: "hackathons"
---

# AI powered PostgreSQL Test Data Generation Tool (Cloudflare AI Challenge)
**Author:** Njabulo Majozi
**Published:** April 14, 2024

## Overview
A serverless application using Cloudflare Workers and Hono that generates test data for PostgreSQL databases by orchestrating two AI models in sequence: one for natural language steps and another for SQL conversion.

## Key Concepts
- `@hf/thebloke/deepseek-coder-6.7b-base-awq` for natural language step generation
- `@cf/defog/sqlcoder-7b-2` for SQL query generation
- Multi-LLM orchestration and chaining
- `/generate-data` endpoint accepting PostgreSQL schemas
- Natural language to SQL translation with constraint compliance

### GitHub Repository
- https://github.com/njabulomajozi/retriedge
