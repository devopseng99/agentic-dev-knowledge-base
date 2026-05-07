---
title: "Using LLMs For Kubernetes: Enter k8sgpt"
url: "https://dev.to/thenjdevopsguy/using-llms-for-kubernetes-enter-k8sgpt-3pb9"
author: "Michael Levan"
category: "k8s-native-agents"
---

# Using LLMs For Kubernetes: Enter k8sgpt
**Author:** Michael Levan
**Published:** August 5, 2024

## Overview
Demonstrates using k8sgpt to scan and troubleshoot Kubernetes clusters with GenAI, including deploying a test microservices application and filtering analysis by resource type.

## Key Concepts

### Install k8sgpt
```bash
brew tap k8sgpt-ai/k8sgpt
brew install k8sgpt
```

### Generate and Add Auth
```bash
k8sgpt generate
k8sgpt auth add
```

### Run Analysis
```bash
k8sgpt analyze
k8sgpt analyze --with-doc
k8sgpt analyze --explain --filter=Pod --namespace=microdemo
k8sgpt analyze --explain --filter=Service --namespace=microdemo
```
