---
title: "Kubernetes Custom Resource Definitions (CRDs): Teaching K8s New Tricks"
url: "https://dev.to/hritikraj8804/kubernetes-custom-resource-definitions-crds-teaching-k8s-new-tricks-1gj6"
author: "Hritik Raj"
category: "k8s-native-agents"
---

# Kubernetes Custom Resource Definitions (CRDs): Teaching K8s New Tricks
**Author:** Hritik Raj
**Published:** July 21, 2025

## Overview
Introduction to CRDs as a mechanism for extending the Kubernetes API with custom resource types, covering definition, creation, and the Operator Pattern.

## Key Concepts

### Define the CRD
```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: myapps.stable.example.com
spec:
  group: stable.example.com
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
                  minimum: 1
                databaseName:
                  type: string
  scope: Namespaced
  names:
    plural: myapps
    singular: myapp
    kind: MyApp
    shortNames:
      - ma
```

### Create Custom Resource
```yaml
apiVersion: stable.example.com/v1
kind: MyApp
metadata:
  name: notes-frontend
spec:
  image: yourdockerhub/notes-frontend:v1.0
  replicas: 3
  databaseName: notes-db-prod
```

```bash
kubectl apply -f my-app-crd.yml
kubectl get myapps
kubectl describe myapp notes-frontend
```
