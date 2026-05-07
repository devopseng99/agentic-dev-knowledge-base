---
title: "Kubernetes Event Driven Autoscaling: Spring Boot & RabbitMQ"
url: "https://dev.to/aissam_assouik/kubernetes-event-driven-autoscaling-21ii"
author: "AISSAM ASSOUIK"
category: "k8s-native-agents"
---

# Kubernetes Event Driven Autoscaling: Spring Boot & RabbitMQ
**Author:** AISSAM ASSOUIK
**Published:** June 11, 2025

## Overview
Detailed walkthrough of KEDA with Spring Boot and RabbitMQ, covering TriggerAuthentication, Gateway API, ScaledObject configuration, and load testing.

## Key Concepts

### TriggerAuthentication
```yaml
apiVersion: keda.sh/v1alpha1
kind: TriggerAuthentication
metadata:
  name: rabbitmq-trigger-authentication
  namespace: spring-boot
spec:
  secretTargetRef:
    - parameter: host
      key: rabbitmq-uri
      name: tts-secrets
```

### ScaledObject
```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: tts-analytics-rabbitmq-scaled-object
  namespace: spring-boot
spec:
  scaleTargetRef:
    name: tts-analytics
  minReplicaCount: 1
  maxReplicaCount: 10
  triggers:
    - type: rabbitmq
      metadata:
        protocol: amqp
        queueName: post-tts-analytics.analytics-group
        mode: QueueLength
        value: "5"
      authenticationRef:
        name: rabbitmq-trigger-authentication
```

### Gateway API
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: tts-gateway
spec:
  gatewayClassName: nginx
  listeners:
    - name: http
      port: 80
      protocol: HTTP
```
