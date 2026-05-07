---
title: "Karpenter: Tool for Autoscaling Kubernetes Clusters"
url: "https://dev.to/klasniyparen/karpenter-tool-for-autoscaling-kubernetes-clusters-eph"
author: "Artem Gontar"
category: "k8s-native-agents"
---

# Karpenter: Tool for Autoscaling Kubernetes Clusters
**Author:** Artem Gontar
**Published:** December 29, 2022

## Overview
Karpenter automatically scales Kubernetes clusters by monitoring resource usage and adding/removing nodes. Supports multiple cloud providers and custom metrics.

## Key Concepts

### Install via Helm
```bash
helm install karpenter openfaas/karpenter
```

### Install via YAML
```bash
kubectl apply -f https://raw.githubusercontent.com/openfaas/karpenter/main/yaml/karpenter.yaml
```

### Install via Docker
```bash
docker pull openfaas/karpenter
docker run -d --name karpenter openfaas/karpenter
```
