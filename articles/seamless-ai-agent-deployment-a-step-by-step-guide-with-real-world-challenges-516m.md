---
title: "Seamless AI Agent Deployment: A Step-by-Step Guide with Real-World Challenges"
url: "https://dev.to/ashutoshsarangi/seamless-ai-agent-deployment-a-step-by-step-guide-with-real-world-challenges-516m"
author: "Ashutosh Sarangi"
category: "ai-agents-deployment"
---

# From Localhost to Kubernetes: Containerizing an AI Log Analysis Agent

**Author:** Ashutosh Sarangi
**Date Published:** August 1, 2025
**Tags:** #docker #kubernetes #agentaichallenge #python

---

## Overview

This article chronicles the development and deployment journey of an AI agent proof-of-concept designed to process logs, summarize content, and detect errors in parallel using LangGraph and Large Language Models.

## The AI Agent POC

The system combines:
- **LangGraph** for agent workflow orchestration
- **Parallelization and subgraph concepts** for parallel processing
- **Python server** exposing the agent via API for external consumption
- **UI integration** for log submission and result retrieval

---

## Docker Containerization Challenges

### Challenge 1: Port Binding Issue

**Problem:** After running the Docker container with port mapping, Uvicorn logs showed:

```
INFO: Uvicorn running on http://127.0.0.1:9000 (Press CTRL+C to quit)
```

The application was inaccessible from the host despite correct port mapping (`-p 8080:9000`).

**Root Cause:** "Uvicorn was binding to `127.0.0.1` (localhost) inside the container" rather than listening on all network interfaces.

**Solution:** Modify the Dockerfile CMD to bind on all interfaces:

```dockerfile
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "9000"]
```

Result: Application became accessible at `http://localhost:8080`

---

## Kubernetes Deployment Challenges

### Understanding Service Types

**ClusterIP (Default):** "Only reachable from within the Kubernetes cluster" for inter-pod communication.

**NodePort:** Exposes services on static ports across nodes.

**LoadBalancer:** Provisions external load balancers (cloud providers).

### Challenge 2: Docker Desktop Access Limitations

**Problems:**
1. Kubernetes runs in isolated VMs (WSL2/Hyper-V)
2. Node IPs obtained via kubectl are VM internal addresses
3. Direct NodeIP:NodePort access from host is unreliable

**Solution: kubectl port-forward**

```bash
kubectl port-forward service/python-app-service 7000:80
```

Parameters:
- `service/python-app-service`: Target Kubernetes service name
- `7000`: Local machine port (access at http://localhost:7000)
- `80`: Service's internal cluster IP port (not the Pod's targetPort)

**Critical Insight:** "The second port number in the command must be the Service's port, not the Pod's `targetPort` or the `nodePort`."

---

## Service Configuration Example

```yaml
spec:
  ports:
    - protocol: TCP
      port: 80              # Service's internal cluster port
      targetPort: 9000      # Pod's listening port
      nodePort: 30080       # Node port (for NodePort type)
  type: NodePort
```

---

## Key Takeaways

1. **Docker networking:** Container services must bind to `0.0.0.0` to accept external connections
2. **Kubernetes routing:** Understand the distinction between service ports, target ports, and node ports
3. **Docker Desktop limitations:** kubectl port-forward is the most reliable development solution for local Kubernetes access
4. **End-to-end deployment:** Successfully demonstrated building, containerizing, and orchestrating AI agents through Kubernetes
