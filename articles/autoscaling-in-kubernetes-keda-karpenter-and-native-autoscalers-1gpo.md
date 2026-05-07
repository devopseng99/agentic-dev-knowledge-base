---
title: "Autoscaling in Kubernetes: KEDA, Karpenter, and Native Autoscalers"
url: "https://dev.to/hkhelil/autoscaling-in-kubernetes-keda-karpenter-and-native-autoscalers-1gpo"
author: "Hamdi (KHELIL) LION"
category: "k8s-native-agents"
---

# Autoscaling in Kubernetes: KEDA, Karpenter, and Native Autoscalers
**Author:** Hamdi (KHELIL) LION
**Published:** September 2, 2024

## Overview
Comprehensive comparison of KEDA (event-driven pod autoscaling), Karpenter (dynamic node scaling), and native HPA/VPA autoscalers.

## Key Concepts

### KEDA Installation
```bash
helm repo add kedacore https://kedacore.github.io/charts
helm install keda kedacore/keda --namespace keda --create-namespace
```

### KEDA ScaledObject (RabbitMQ)
```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: rabbitmq-queue-scaler
spec:
  scaleTargetRef:
    name: my-rabbitmq-app
  triggers:
  - type: rabbitmq
    metadata:
      queueName: my-queue
      host: "amqp://guest:guest@rabbitmq.default.svc.cluster.local:5672"
      queueLength: "10"
```

### VPA Configuration
```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: my-app-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind: Deployment
    name: my-app
  updatePolicy:
    updateMode: "Auto"
```

### Karpenter Provisioner
```yaml
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  requirements:
    - key: "node.kubernetes.io/instance-type"
      operator: In
      values: ["t3a.medium", "t3a.large"]
    - key: "karpenter.sh/capacity-type"
      operator: In
      values: ["spot"]
  ttlSecondsAfterEmpty: 30
```
