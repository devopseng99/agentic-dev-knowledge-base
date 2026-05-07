---
title: "I Built an Open-Source Tool for Debugging Kubernetes Agentically"
url: "https://dev.to/adam_dickinson_9842266356/i-built-an-open-source-tool-for-debugging-kubernetes-agentically-341"
author: "Adam Dickinson"
category: "k8s-native-agents"
---

# I Built an Open-Source Tool for Debugging Kubernetes Agentically
**Author:** Adam Dickinson
**Published:** November 26, 2025

## Overview
Kubently is an open-source tool for troubleshooting Kubernetes clusters through natural language conversations with LLMs, featuring ~50ms command delivery, read-only by default, multi-cluster native, and A2A protocol support.

## Key Concepts
- Kubently API: FastAPI service with Redis pub/sub for A2A communication
- Kubently Executor: Lightweight agent deployed per cluster, read-only by default
- LLM Integration: Multi-provider support via factory pattern
- Server-Sent Events for ~50ms command delivery latency
- Cloud agnostic: works across EKS, GKE, AKS, bare metal, k3s
- Multi-cluster native from the start
- A2A Protocol for integration with LangGraph, LangChain
