---
title: "Kubernetes Autoscaling with KEDA: Event-Driven Scaling for Queues and Microservices - Part 1"
url: "https://dev.to/suavebajaj/kubernetes-autoscaling-with-keda-event-driven-scaling-for-queues-and-microservices-part-1-2bhp"
author: "Suave Bajaj"
category: "k8s-native-agents"
---

# Kubernetes Autoscaling with KEDA: Event-Driven Scaling for Queues and Microservices - Part 1
**Author:** Suave Bajaj
**Published:** September 20, 2025

## Overview
KEDA ScaledObject patterns for RabbitMQ and Kafka, covering replica calculation formulas, limitations of single-Deployment multi-queue patterns, and OR logic across triggers.

## Key Concepts

### RabbitMQ ScaledObject
```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: orders-consumer-scaler
spec:
  scaleTargetRef:
    name: orders-consumer
  minReplicaCount: 1
  maxReplicaCount: 10
  triggers:
  - type: rabbitmq
    metadata:
      queueName: orders-queue
      host: amqp://guest:guest@rabbitmq:5672/
      queueLength: "100"
```

Replica formula: `desiredReplicas = ceil(currentQueueLength / queueLengthThreshold)`

Limitations: N queues require N consumers (N Deployments + N ScaledObjects). All pods in a Deployment scale together. OR logic across triggers.
