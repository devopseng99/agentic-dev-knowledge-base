---
title: "Build a Kubernetes Operator"
url: "https://dev.to/austincunningham/build-a-kubernetes-operator-1g08"
author: "Austin Cunningham"
category: "k8s-native-agents"
---

# Build a Kubernetes Operator
**Author:** Austin Cunningham
**Published:** June 10, 2022

## Overview
Tutorial for building a Kubernetes operator using Operator SDK that manages custom Podroute resources to automate Deployment, Service, and Route creation.

## Key Concepts

### Bootstrap
```bash
operator-sdk init --domain quay.io --repo github.com/austincunningham/pod-route
operator-sdk create api --version v1alpha1 --kind Podroute --resource --controller
```

### CRD Spec
```go
type PodrouteSpec struct {
    Image    string `json:"image,omitempty"`
    Replicas int32  `json:"replicas,omitempty"`
}
```

### Deployment Builder
```go
func (r *PodrouteReconciler) podRouteDeployment(cr *quayiov1alpha1.Podroute) *appsv1.Deployment {
    labels := labels(cr, "backend-podroute")
    size := cr.Spec.Replicas
    podRouteDeployment := &appsv1.Deployment{
        ObjectMeta: metav1.ObjectMeta{
            Name:      "pod-route",
            Namespace: cr.Namespace,
        },
        Spec: appsv1.DeploymentSpec{
            Replicas: &size,
            Selector: &metav1.LabelSelector{MatchLabels: labels},
            Template: corev1.PodTemplateSpec{
                ObjectMeta: metav1.ObjectMeta{Labels: labels},
                Spec: corev1.PodSpec{
                    Containers: []corev1.Container{{
                        Image:           cr.Spec.Image,
                        ImagePullPolicy: corev1.PullAlways,
                        Name:            "podroute-pod",
                        Ports: []corev1.ContainerPort{{ContainerPort: 8080, Name: "podroute"}},
                    }},
                },
            },
        },
    }
    controllerutil.SetControllerReference(cr, podRouteDeployment, r.Scheme)
    return podRouteDeployment
}
```
