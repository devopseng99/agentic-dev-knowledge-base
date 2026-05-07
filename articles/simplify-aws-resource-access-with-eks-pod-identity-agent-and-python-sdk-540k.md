---
title: "Simplify AWS resource access with EKS Pod Identity Agent and Python SDK"
url: "https://dev.to/aws-builders/simplify-aws-resource-access-with-eks-pod-identity-agent-and-python-sdk-540k"
author: "saifeddine Rajhi"
category: "k8s-native-agents"
---

# Simplify AWS resource access with EKS Pod Identity Agent and Python SDK
**Author:** saifeddine Rajhi
**Published:** October 7, 2024

## Overview
Guide to using EKS Pod Identity Agent with Boto3 Python SDK for secure AWS resource access from Kubernetes pods without distributing credentials.

## Key Concepts

### EKS Cluster Config
```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: eks-pod-identity-boto3
  region: eu-west-1
managedNodeGroups:
  - name: managed-nodes
    instanceType: m5.large
    minSize: 2
    desiredCapacity: 3
    maxSize: 4
```

### Service Account
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: s3-access-sa
  namespace: default
```

### Pod Identity Association
```bash
aws eks create-pod-identity-association \
  --cluster-name eks-pod-identity-boto3 \
  --namespace default \
  --service-account s3-access-sa \
  --role-arn arn:aws:iam::012345678901:role/EKS-S3-Access-Role
```

### Boto3 S3 Script
```python
import boto3
session = boto3.Session()
s3 = session.client('s3')
response = s3.list_buckets()
for bucket in response['Buckets']:
    print(f"  {bucket['Name']}")
```
