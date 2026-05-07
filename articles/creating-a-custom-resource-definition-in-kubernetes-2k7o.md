---
title: "Creating a Custom Resource Definition In Kubernetes"
url: "https://dev.to/thenjdevopsguy/creating-a-custom-resource-definition-in-kubernetes-2k7o"
author: "Michael Levan"
category: "k8s-native-agents"
---

# Creating a Custom Resource Definition In Kubernetes
**Author:** Michael Levan
**Published:** July 25, 2023

## Overview
Creating and using Kubernetes Custom Resource Definitions to extend the API with custom resources using OpenAPI v3 schema.

## Key Concepts

### Create CRD
```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: mikesnginxapps.simplyengineering.com
spec:
  group: simplyengineering.com
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
                image:
                  type: string
                replicas:
                  type: integer
  scope: Namespaced
  names:
    kind: MikesNginxApp
    plural: mikesnginxapps
    shortNames:
    - mikeapp
```

### Create Custom Resource
```yaml
apiVersion: simplyengineering.com/v1
kind: MikesNginxApp
metadata:
  name: mikesapptest
spec:
  image: nginx:latest
  replicas: 2
```

```bash
kubectl get crd
kubectl get mikeapp
kubectl describe mikeapp mikesapptest
```
