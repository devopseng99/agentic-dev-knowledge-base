---
title: "Orchestrating Secure AI Agents on Amazon EKS"
url: "https://dev.to/mattcamp/orchestrating-secure-ai-agents-on-amazon-eks-50kh"
author: "Matt Camp"
category: "k8s-native-agents"
---

# Orchestrating Secure AI Agents on Amazon EKS
**Author:** Matt Camp
**Published:** March 27, 2026

## Overview
Describes Osmia, an open-source orchestration layer that translates tasks into Kubernetes Jobs for AI coding agents on EKS. Covers security, secrets management, Karpenter integration, trajectory scoring, per-codebase memory, and engine routing.

## Key Concepts

### IAM Policy for Secrets Manager
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["secretsmanager:GetSecretValue"],
      "Resource": "arn:aws:secretsmanager:eu-west-1:123456789:secret:osmia/*"
    }
  ]
}
```

### ServiceAccount Annotation
```yaml
metadata:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789:role/osmia-secrets
```

### Secret Resolver Configuration
```yaml
secret_resolver:
  backends:
    - scheme: "aws-sm"
      backend: "aws-secrets-manager"
      config:
        region: "eu-west-1"
        cache_ttl: "5m"
```

### Multi-Backend Secret Configuration
```yaml
secret_resolver:
  backends:
    - scheme: "k8s"
      backend: "k8s"
    - scheme: "aws-sm"
      backend: "aws-secrets-manager"
      config:
        region: "eu-west-1"
  policy:
    allowed_schemes: ["k8s", "aws-sm"]
    blocked_env_patterns: ["AWS_*"]
```

### External Secrets Operator Integration
```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: osmia-anthropic-key
  namespace: osmia
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: ClusterSecretStore
  target:
    name: osmia-anthropic-key
  data:
    - secretKey: api_key
      remoteRef:
        key: osmia/anthropic-api-key
        property: api_key
```

### Helm Deployment
```bash
helm repo add osmia https://unitaryai.github.io/osmia
helm install osmia osmia/osmia \
  --namespace osmia-system \
  --create-namespace \
  -f values-eks.yaml
```
