---
title: "Building AI Agents with GKE"
url: "https://dev.to/ki3ani/building-ai-agents-with-gke-5clk"
author: "Kim"
category: "ai-agent-kubernetes-deploy"
---

# Building AI Agents with GKE

**Author:** Kim
**Published:** September 22, 2025

## Overview

Multi-agent AI system on Google Kubernetes Engine enhancing the Online Boutique microservices app with external AI capabilities (recommendation, support, marketing, business analysis agents) without modifying original code.

## Key Concepts

### Service Discovery

```yaml
apiVersion: v1
kind: Service
metadata:
  name: marketing-campaigner-service
spec:
  selector:
    app: marketing-campaigner-agent
  ports:
  - port: 8080
    targetPort: 8080
```

### MCP Server with Cloud SQL Sidecar

```yaml
spec:
  serviceAccountName: mcp-toolbox-sa
  containers:
  - name: server
    image: ...
    env:
      - name: DB_HOST
        value: "127.0.0.1"
  - name: cloud-sql-proxy
    image: gcr.io/cloud-sql-connectors/cloud-sql-proxy:2.8.0
```

### Scheduled Agent with CronJob

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: business-analyst-agent
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
```

### Agent-to-Agent Communication

```python
def send_a2a_goal(self, product_name):
    marketing_agent_url = "http://marketing-campaigner-service:8080/goal"
    a2a_message = {
        "goal": "create_promotional_content",
        "payload": { "product_name": product_name }
    }
    requests.post(marketing_agent_url, json=a2a_message)
```

### Hallucination Prevention

```python
final_prompt = f"""
Answer the user's question based ONLY on the product data provided.
Do not make up information.
User's Question: "{question}"
Product Data: "{product_context}"
"""
final_response = model.generate_content(final_prompt)
```

### Public LoadBalancer

```yaml
apiVersion: v1
kind: Service
metadata:
  name: dashboard-ui-service
spec:
  type: LoadBalancer
  selector:
    app: dashboard-ui
  ports:
  - port: 80
    targetPort: 8080
```

### Why GKE
Declarative infrastructure, seamless service discovery, appropriate resource types (CronJobs, Deployments), built-in resilience, and effortless scalability.
