---
title: "Soaring to New Heights with Kaito: The Kubernetes AI Toolchain Operator"
url: "https://dev.to/azure/soaring-to-new-heights-with-kaito-the-kubernetes-ai-toolchain-operator-24ai"
author: "Paul Yu"
category: "k8s-native-agents"
---

# Soaring to New Heights with Kaito: The Kubernetes AI Toolchain Operator
**Author:** Paul Yu
**Published:** March 20, 2024

## Overview
Kaito is a Kubernetes Operator for AI workloads that automates GPU node provisioning, reduces time to inference, and supports popular open-source LLMs via preset configurations.

## Key Concepts

### Workspace Custom Resource
```yaml
apiVersion: kaito.sh/v1alpha1
kind: Workspace
metadata:
  name: workspace-falcon-7b-instruct
resource:
  instanceType: "Standard_NC12s_v3"
  labelSelector:
    matchLabels:
      apps: falcon-7b-instruct
inference:
  preset:
    name: "falcon-7b-instruct"
```

- Workspace controller handles node provisioning and inference workload creation
- Node provisioner uses Karpenter APIs to add GPU nodes
- Presets available for Llama2, Falcon, Mistral, and Phi-2
