---
title: "How to Build AI Agents for Kubernetes Deployments"
url: "https://dev.to/devopsstart/how-to-build-ai-agents-for-kubernetes-deployments-34m"
author: "DevOps Start"
category: "ai-agent-kubernetes-deploy"
---

# How to Build AI Agents for Kubernetes Deployments

**Author:** DevOps Start
**Published:** April 23, 2026

## Overview

Comprehensive guide for building autonomous Kubernetes agents that follow an "Observe -> Reason -> Act" loop. Uses MCP (Model Context Protocol), K8sGPT, ArgoCD, and safety rails with human-in-the-loop patterns.

## Key Concepts

### Agent Loop Architecture
1. **Observation:** Call tools to assess status
2. **Reasoning:** Analyze findings
3. **Action:** Execute decisions
4. **Repeat:** Continuous feedback loop

### MCP Server Implementation

```python
pip install mcp
```

```python
from mcp.server.fastmcp import FastMCP
import subprocess

mcp = FastMCP("K8s-Guardian")

@mcp.tool()
def get_pod_errors(namespace: str) -> str:
    """Fetches only Warning events for pods in a specific namespace."""
    cmd = ["kubectl", "get", "events", "-n", namespace,
           "--field-selector", "type=Warning"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        return f"Error fetching events: {result.stderr}"
    return result.stdout if result.stdout else "No warning events found."

if __name__ == "__main__":
    mcp.run()
```

### RBAC Configuration

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: k8s-ai-agent
  namespace: ai-ops
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: agent-read-write-role
  namespace: staging
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log", "events", "configmaps"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list", "patch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: agent-read-write-binding
  namespace: staging
subjects:
- kind: ServiceAccount
  name: k8s-ai-agent
  namespace: ai-ops
roleRef:
  kind: Role
  name: agent-read-write-role
  apiGroup: rbac.authorization.k8s.io
```

### K8sGPT Integration

```python
@mcp.tool()
def analyze_cluster_health(namespace: str) -> str:
    """Runs a K8sGPT analysis on the namespace to find errors."""
    cmd = ["k8sgpt", "analyze", "--namespace", namespace]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout
```

### Resource Optimization Tool

```python
@mcp.tool()
def get_pod_resource_usage(pod_name: str, namespace: str) -> str:
    """Retrieves CPU and Memory usage for a specific pod."""
    cmd = ["kubectl", "top", "pod", pod_name, "-n", namespace]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout
```

### ArgoCD Integration

```python
@mcp.tool()
def get_argocd_app_status(app_name: str) -> str:
    """Checks if an ArgoCD application is Synced and Healthy."""
    cmd = ["argocd", "app", "get", app_name]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout
```

### Safety Rails with Dry-Run

```python
@mcp.tool()
def propose_deployment_patch(deployment_name: str, namespace: str, patch_yaml: str) -> str:
    """Proposes a change to a deployment using dry-run."""
    with open("patch.yaml", "w") as f:
        f.write(patch_yaml)
    cmd = ["kubectl", "patch", "deployment", deployment_name,
           "-n", namespace, "--patch-file", "patch.yaml",
           "--dry-run=server"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return f"Proposed Change: {result.stdout}"
```

### Troubleshooting
- Infinite loops: Refine system prompts with maximum tool call limits
- RBAC forbidden errors: Verify Role resources explicitly list `pods/log`
- Hallucinated CLI flags: Be explicit in MCP tool descriptions
- Context window overflow: Filter and summarize tool outputs before LLM processing
