---
title: "Introducing KubeAI: Open AI Inference Operator"
url: "https://dev.to/samos123/introducing-kubeai-open-ai-inference-operator-4hm3"
author: "Sam Stoelinga"
category: "k8s-native-agents"
---

# Introducing KubeAI: Open AI Inference Operator
**Author:** Sam Stoelinga
**Published:** September 16, 2024

## Overview
KubeAI provides an OpenAI-compatible API endpoint for running LLMs, embedding models, and speech-to-text on Kubernetes with metrics-based autoscaling including scale-from-zero, without requiring Knative or Istio dependencies.

## Key Concepts
- Directly operates vLLM and Ollama servers in isolated Pods
- Model-by-model configuration and optimization
- Metrics-based autoscaling with scale-from-zero
- No external dependencies beyond Kubernetes
- OpenAI-compatible API endpoint
