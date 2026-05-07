---
title: "What Is A Kubernetes Operator?"
url: "https://dev.to/thenjdevopsguy/what-is-a-kubernetes-operator-53kb"
author: "Michael Levan"
category: "k8s-native-agents"
---

# What Is A Kubernetes Operator?
**Author:** Michael Levan
**Published:** July 7, 2023

## Overview
Explains Kubernetes Operators as combinations of CRDs and Controllers, covering Kubebuilder, Operator Framework, Metacontroller, and client-go for building operators.

## Key Concepts

### Example CRD
```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: MikesType
spec:
  group: mikestype.example.com
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                cronSpec:
                  type: string
                image:
                  type: string
                replicas:
                  type: integer
```

Building options: Kubebuilder (Go, auto-generates CRDs), Operator Framework (Go/Helm/Ansible), Metacontroller (any language), client-go (custom code generation).
