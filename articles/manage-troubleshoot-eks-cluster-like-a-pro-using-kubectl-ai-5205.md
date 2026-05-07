---
title: "Manage & Troubleshoot EKS Cluster Like a Pro Using kubectl-AI"
url: "https://dev.to/aws-builders/manage-troubleshoot-eks-cluster-like-a-pro-using-kubectl-ai-5205"
author: "Sarvar Nadaf"
category: "k8s-native-agents"
---

# Manage & Troubleshoot EKS Cluster Like a Pro Using kubectl-AI
**Author:** Sarvar Nadaf
**Published:** June 20, 2025

## Overview
kubectl-ai is a Google Cloud open-source CLI plugin that brings generative AI to Kubernetes terminal for generating kubectl commands, YAML templates, and error explanations using Google Gemini or OpenAI GPT.

## Key Concepts

### Installation
```bash
curl -sSL https://raw.githubusercontent.com/GoogleCloudPlatform/kubectl-ai/main/install.sh | bash
```

### Configure Gemini
```bash
export GEMINI_API_KEY=your_gemini_api_key
kubectl-ai --model gemini-2.5-flash-preview-04-17
```

Use cases: debugging pod crashes, restarting deployments, diagnosing image pull issues, checking resource usage, service connectivity troubleshooting.
