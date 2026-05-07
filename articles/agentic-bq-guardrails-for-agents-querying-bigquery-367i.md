---
title: "agentic-bq - Guardrails for Agents Querying BigQuery"
url: "https://dev.to/raghavachellu/agentic-bq-guardrails-for-agents-querying-bigquery-367i"
author: "Raghava Chellu"
category: "agent-guardrails"
---

# agentic-bq - Guardrails for Agents Querying BigQuery

**Author:** Raghava Chellu
**Published:** February 23, 2026

## Overview
A Python library for safely managing LLM agent interactions with Google BigQuery. Provides parameterized query enforcement, destructive command blocking, automatic LIMIT injection, dry-run cost estimation, and audit-ready logging.

## Key Concepts
- Parameterized queries eliminate SQL injection
- Denylist engine blocks DROP, DELETE, ALTER, TRUNCATE
- Automatic LIMIT injection prevents resource exhaustion
- Dry-run cost estimation before execution
- Structured JSON results for agent consumption

## Code Examples

### Installation and Basic Usage
```python
pip install agentic-bq
```

```python
from agentic_bq import AgenticBQ

bq = AgenticBQ(project="my-gcp-project")

query = """
SELECT name, total_sales
FROM retail_dataset.sales
WHERE region = @region
ORDER BY total_sales DESC
"""

params = {"region": "US"}
result = bq.safe_query(query, params=params, limit=100)
print(result.to_json())
```

### Dry-Run Cost Estimation
```python
info = bq.dry_run("SELECT COUNT(*) FROM massive_table")
print(f"Estimated bytes processed: {info.estimated_bytes_processed/1e9:.2f} GB")
```

### Configuration
```python
bq = AgenticBQ(
    project="my-project",
    max_cost_gb=5,          # deny if > 5 GB processed
    enforce_limit=200,      # default limit
    denylist=["DELETE", "DROP", "UPDATE"],
    log_dir="/var/log/agentic_bq"
)
```

### LangChain Integration
```python
tool("bq_query", bq.safe_query, description="Run cost-controlled BigQuery SQL")
```

## Design Principles
- Least Privilege for Data Agents
- Predictable Cost Profiles
- Composability (LangChain integration)
- Transparency through intent logging

## Roadmap
- v0.1: Parameter binding + LIMIT enforcement
- v0.2: Async API support
- v0.3: Adaptive budgeting via BigQuery reservations
- v1.0: Production stability and OpenTelemetry metrics
