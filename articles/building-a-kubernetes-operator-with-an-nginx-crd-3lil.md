---
title: "Building a Kubernetes Operator with an NGINX CRD"
url: "https://dev.to/hkhelil/building-a-kubernetes-operator-with-an-nginx-crd-3lil"
author: "Hamdi (KHELIL) LION"
category: "k8s-native-agents"
---

# Building a Kubernetes Operator with an NGINX CRD
**Author:** Hamdi (KHELIL) LION
**Published:** August 29, 2024

## Overview
Complete tutorial for building a Kubernetes operator in Go using controller-runtime to manage NGINX instances via a custom CRD, including reconciliation logic, garbage collection, and Docker deployment.

## Key Concepts

### Nginx CRD
```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: nginxes.example.com
spec:
  group: example.com
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
                replicas:
                  type: integer
                image:
                  type: string
  scope: Namespaced
  names:
    plural: nginxes
    singular: nginx
    kind: Nginx
```

### Go Reconcile Logic
```go
func (r *ReconcileNginx) Reconcile(ctx context.Context, request reconcile.Request) (reconcile.Result, error) {
    nginx := &Nginx{}
    err := r.client.Get(ctx, request.NamespacedName, nginx)
    if err != nil {
        if errors.IsNotFound(err) {
            return reconcile.Result{}, nil
        }
        return reconcile.Result{}, err
    }
    pod := &corev1.Pod{
        ObjectMeta: v1.ObjectMeta{
            Name:      nginx.Name + "-pod",
            Namespace: request.Namespace,
        },
        Spec: corev1.PodSpec{
            Containers: []corev1.Container{{Name: "nginx", Image: nginx.Spec.Image}},
        },
    }
    found := &corev1.Pod{}
    err = r.client.Get(ctx, request.NamespacedName, found)
    if err != nil && errors.IsNotFound(err) {
        err = r.client.Create(ctx, pod)
    }
    return reconcile.Result{}, nil
}
```
