---
title: "Beyond YAML: Building Kubernetes Operators with CRDs and the Reconciliation Loop"
url: "https://dev.to/naveens16/beyond-yaml-building-kubernetes-operators-with-crds-and-the-reconciliation-loop-524d"
author: "Kubernetes with Naveen"
category: "k8s-native-agents"
---

# Beyond YAML: Building Kubernetes Operators with CRDs and the Reconciliation Loop
**Author:** Kubernetes with Naveen
**Published:** October 29, 2025

## Overview
Deep dive into building Kubernetes Operators with CRDs and reconciliation loops in Go using Kubebuilder, covering scaffolding, reconciler patterns, status updates, and best practices.

## Key Concepts

### Scaffold Project
```bash
kubebuilder init --domain your.domain --repo github.com/you/your-operator
kubebuilder create api --group <group> --version <version> --kind <KindName>
```

### Reconciler Structure
```go
func (r *MyKindReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
    var my mygroupv1.MyKind
    if err := r.Get(ctx, req.NamespacedName, &my); err != nil {
        if apierrors.IsNotFound(err) {
            return ctrl.Result{}, nil
        }
        return ctrl.Result{}, err
    }
    // Desired vs actual comparison, create/update child resources
    return ctrl.Result{}, nil
}

func (r *MyKindReconciler) SetupWithManager(mgr ctrl.Manager) error {
    return ctrl.NewControllerManagedBy(mgr).
        For(&mygroupv1.MyKind{}).
        Owns(&appsv1.Deployment{}).
        Complete(r)
}
```

### Return Patterns
- `ctrl.Result{}, nil` - complete, no requeue
- `ctrl.Result{Requeue: true}, nil` - immediate requeue
- `ctrl.Result{RequeueAfter: time.Duration}, nil` - delayed requeue
