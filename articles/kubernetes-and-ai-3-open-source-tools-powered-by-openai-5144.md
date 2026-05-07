---
title: "Kubernetes and AI: 3 Open Source Tools Powered by OpenAI"
url: "https://dev.to/ajeetraina/kubernetes-and-ai-3-open-source-tools-powered-by-openai-5144"
author: "Ajeet Singh Raina"
category: "k8s-native-agents"
---

# Kubernetes and AI: 3 Open Source Tools Powered by OpenAI
**Author:** Ajeet Singh Raina
**Published:** May 26, 2024

## Overview
Explores three AI-powered Kubernetes tools: KoPylot (monitoring), K8sGPT (diagnostics), and kubectl-ai (manifest generation), plus Krs (recommendation system).

## Key Concepts

### KoPylot Installation
```bash
export KOPYLOT_AUTH_TOKEN=your_api_key
pip install kopylot
kopylot diagnose deployment nginx --namespace default
```

### K8sGPT Setup
```bash
brew tap k8sgpt-ai/k8sgpt
brew install k8sgpt
k8sgpt generate
k8sgpt auth
k8sgpt analyze --explain
```

### Custom K8sGPT Analyzer Interface (Go)
```go
type Analyzer interface {
  Analyze(resource *unstructured.Unstructured) ([]*Issue, error)
  Name() string
  Enabled() bool
}
```

### kubectl-ai
```bash
brew tap sozercan/kubectl-ai
brew install kubectl-ai
export OPENAI_API_KEY=<your_OpenAI_key>
kubectl ai "Create a namespace called ns1 and deploy a Nginx Pod"
```
