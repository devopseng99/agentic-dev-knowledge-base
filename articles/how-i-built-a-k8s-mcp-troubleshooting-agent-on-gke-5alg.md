---
title: "How I Built a K8S MCP Troubleshooting Agent on GKE"
url: "https://dev.to/w3sqr/how-i-built-a-k8s-mcp-troubleshooting-agent-on-gke-5alg"
author: "Samir Saqer"
category: "k8s-native-agents"
---

# How I Built a K8S MCP Troubleshooting Agent on GKE
**Author:** Samir Saqer
**Published:** September 20, 2025

## Overview
A Kubernetes troubleshooting agent for the GKE Turns 10 Hackathon combining Kubernetes observability with AI insights. Uses MCP server via FastMCP and Google ADK for conversational agent capabilities.

## Key Concepts
Available tools include: get_cluster_info, list_pods, get_pod_logs, describe_pod, get_service_status, get_deployment_status, delete_resource, suggest_troubleshooting, automate_remediation, get_gke_cluster_metrics, scale_deployment, exec_pod_command, and network_connectivity_test.

Technologies: GKE, MCP (mcp.server.fastmcp), Google ADK (google.adk.agents.LlmAgent), Vertex AI, Python 3.11, kubernetes Python client.
