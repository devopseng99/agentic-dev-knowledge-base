---
title: "Finding Ghosts: Detecting AI Agents Running in Kubernetes With No Source Code"
url: "https://dev.to/mwaseem-defendai/we-found-a-ghost-detecting-an-ai-agent-running-in-kubernetes-with-no-source-code-1ac6"
author: "Mohamed Waseem"
category: "k8s-native-agents"
---

# Finding Ghosts: Detecting AI Agents Running in Kubernetes With No Source Code
**Author:** Mohamed Waseem
**Published:** April 8, 2026

## Overview
Describes detecting GHOST agents - runtime-only AI processes in Kubernetes with no source code, manifests, or documentation. Uses AgentDiscover Scanner with four-layer detection: static code analysis, network monitoring, K8s control plane inspection via eBPF/Tetragon, and correlation analysis.

## Key Concepts

### Install and Run Scanner
```bash
pip install agent-discover-scanner
agent-discover-scanner scan-all ~/projects --duration 10
```

Detection categories: CONFIRMED (code + runtime), UNKNOWN (code only), SHADOW AI, ZOMBIE (inactive code), GHOST (runtime only, no source).
