---
title: "Implementing Kubernetes Pod Security Standards"
url: "https://dev.to/thenjdevopsguy/implementing-kubernetes-pod-security-standards-4aco"
author: "Michael Levan"
category: "k8s-native-agents"
---

# Implementing Kubernetes Pod Security Standards
**Author:** Michael Levan
**Published:** July 29, 2024

## Overview
Three Pod Security Standard levels (Privileged, Baseline, Restricted) with Pod Security Admission Controller enforcement, namespace labeling, and OPA/Kyverno for pod-level policies.

## Key Concepts

### Cluster-Level AdmissionConfiguration
```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: PodSecurity
  configuration:
    apiVersion: pod-security.admission.config.k8s.io/v1
    kind: PodSecurityConfiguration
    defaults:
      enforce: "baseline"
      enforce-version: "latest"
      audit: "restricted"
      warn: "restricted"
    exemptions:
      namespaces: [kube-system]
```

### Namespace Labels
```bash
kubectl label --overwrite namespace testytest \
  pod-security.kubernetes.io/audit=restricted \
  pod-security.kubernetes.io/warn=restricted
```

Policy enforcers: OPA with Gatekeeper (works across systems) and Kyverno (expanded beyond K8s).
