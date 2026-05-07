---
title: "ML Platform Deployment with Helm Charts"
url: "https://dev.to/martinbald81/ml-platform-deployment-with-helm-charts-1o32"
author: "martinbald81"
category: "k8s-native-agents"
---

# ML Platform Deployment with Helm Charts
**Author:** martinbald81
**Published:** May 23, 2023

## Overview
Deploying ML/AI platforms on Kubernetes using Helm charts, covering Wallaroo ML platform installation with TLS, node selectors, and preflight checks.

## Key Concepts

### Installation
```bash
helm registry login registry.replicated.com --username $YOURUSERNAME --password $YOURPASSWORD
kubectl preflight --interactive=false preflight.yaml
kubectl create secret tls my-tls-secrets --cert=example.com.crt --key=example.com.key
helm install wallaroo oci://registry.replicated.com/wallaroo/EE/wallaroo --version 2022.4.0-main-2297 --values local-values.yaml
helm test wallaroo
```

Node selectors for ML Engine, Load Balancer, Database, Grafana, and Prometheus.
