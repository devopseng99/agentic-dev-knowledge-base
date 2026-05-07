---
title: "Proactive cluster autoscaling in Kubernetes"
url: "https://dev.to/danielepolencic/proactive-cluster-autoscaling-in-kubernetes-jpc"
author: "Daniele Polencic"
category: "k8s-native-agents"
---

# Proactive cluster autoscaling in Kubernetes
**Author:** Daniele Polencic
**Published:** September 19, 2022

## Overview
Improving Kubernetes cluster scaling through proactive node provisioning using low-priority placeholder pods that get evicted by real workloads, triggering pre-emptive node creation.

## Key Concepts
- Cluster Autoscaler reacts to unschedulable pods every 10 seconds, causing multi-minute delays
- Placeholder pods with PriorityClass -1 consume allocatable resources on a spare node
- Real application pods evict placeholder pods, triggering immediate node creation
- Trade-off: maintains an idle spare node incurring cloud infrastructure charges
- Testing shows autoscaling takes approximately half the time with proactive provisioning
