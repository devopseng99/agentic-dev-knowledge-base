---
title: "Kubernetes Troubleshooting with K8sGPT + Amazon Bedrock"
url: "https://dev.to/prithiviraj_rengarajan/kubernetes-troubleshooting-with-k8sgpt-amazon-bedrock-1m5a"
author: "Prithiviraj R"
category: "k8s-native-agents"
---

# Kubernetes Troubleshooting with K8sGPT + Amazon Bedrock
**Author:** Prithiviraj R
**Published:** November 21, 2025

## Overview
Integrating K8sGPT with Amazon Bedrock Nova Lite model for Kubernetes troubleshooting. Covers setup, intentionally broken workloads, and AI-powered analysis.

## Key Concepts

### Analysis Commands
```bash
k8sgpt analyze
k8sgpt analyze --filter Pod --namespace k8sgpt-demo --explain | head -20
k8sgpt analyze --explain --namespace k8sgpt-demo
k8sgpt analyze --explain --filter Pod,Deployment,Service
k8sgpt auth list
k8sgpt filters list
k8sgpt analyze --explain --verbose
```

### Bedrock Model Options
| Model | Speed | Cost | Best Use Case |
|-------|-------|------|---------------|
| Nova Lite | Fastest | Cheapest | Day-to-day troubleshooting |
| Nova Pro | High | Moderate | Complex multi-resource analysis |
| Claude 3 Haiku | Fast | Good | Detailed explanations |
