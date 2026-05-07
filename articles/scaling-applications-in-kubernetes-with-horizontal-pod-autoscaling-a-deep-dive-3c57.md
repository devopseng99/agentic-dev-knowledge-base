---
title: "Scaling Applications in Kubernetes with Horizontal Pod Autoscaling: A Deep Dive"
url: "https://dev.to/rubixkube/scaling-applications-in-kubernetes-with-horizontal-pod-autoscaling-a-deep-dive-3c57"
author: "Yash Londhe"
category: "k8s-native-agents"
---

# Scaling Applications in Kubernetes with Horizontal Pod Autoscaling: A Deep Dive
**Author:** Yash Londhe
**Published:** December 23, 2024

## Overview
Deep dive into Kubernetes HPA covering metrics-based scaling, custom metrics, multi-metric scaling, scaling policies, and troubleshooting.

## Key Concepts

### HPA Resource
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

### Scaling Policies
```yaml
behavior:
  scaleUp:
    policies:
    - type: Pods
      value: 4
      periodSeconds: 60
  scaleDown:
    policies:
    - type: Percent
      value: 50
      periodSeconds: 60
```

### Custom Metrics
```yaml
metrics:
- type: Pods
  pods:
    metricName: http_requests_per_second
    target:
      type: AverageValue
      averageValue: "50"
```

### Debugging
```bash
kubectl describe hpa <hpa-name>
kubectl get hpa <hpa-name> -o yaml
kubectl top pods
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/pods"
```
