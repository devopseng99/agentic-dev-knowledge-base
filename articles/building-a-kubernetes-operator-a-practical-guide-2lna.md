---
title: "Building a Kubernetes Operator | A Practical Guide"
url: "https://dev.to/jimjunior/building-a-kubernetes-operator-a-practical-guide-2lna"
author: "Beingana Jim Junior"
category: "k8s-native-agents"
---

# Building a Kubernetes Operator | A Practical Guide
**Author:** Beingana Jim Junior
**Published:** December 28, 2024

## Overview
Practical guide to building a Kubernetes Operator in Go using controller-runtime, covering CRD definitions, reconciliation loops, and Docker deployment.

## Key Concepts

### CRD Definition
```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: applications.operator.com
spec:
  group: operator.com
  names:
    kind: Application
    plural: applications
  scope: Namespaced
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
              ports:
                type: array
                items:
                  type: object
```

### Go CRD Types
```go
type Application struct {
  metav1.TypeMeta   `json:",inline"`
  metav1.ObjectMeta `json:"metadata,omitempty"`
  Spec ApplicationSpec `json:"spec"`
}

type ApplicationSpec struct {
  Image   string               `json:"image"`
  Volumes []ApplicationVolume  `json:"volumes"`
  Ports   []ApplicationPortMap `json:"ports"`
  EnvFrom string               `json:"envFrom"`
}
```

### Reconciler
```go
func (r *Reconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
  var application cranev1.Application
  err := r.Client.Get(ctx, req.NamespacedName, &application)
  if err != nil {
    if k8serrors.IsNotFound(err) {
      err = craneKubeUtils.DeleteApplication(ctx, req, r.kubeClient)
      return ctrl.Result{}, nil
    }
  }
  err = craneKubeUtils.ApplyApplication(ctx, req, application, r.kubeClient)
  return ctrl.Result{}, nil
}
```
