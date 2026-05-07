---
title: "Using KIRO and AMDF MCP to Build Reusable Kubernetes KRO Packages"
url: "https://dev.to/aws-builders/kiro-and-amdf-mcp-for-create-reusable-packages-for-kubernetes-with-kro-gig"
author: "Javier Sepulveda"
category: "k8s-native-agents"
---

# Using KIRO and AMDF MCP to Build Reusable Kubernetes KRO Packages
**Author:** Javier Sepulveda
**Published:** March 14, 2026

## Overview
Accelerating creation of reusable Kubernetes packages from CRDs using KIRO and AMDF MCP with KCL for strong typing and validation. Demonstrates a Keycloak stack with local PostgreSQL or AWS RDS backends.

## Key Concepts

### Compile and Deploy
```bash
kcl library/main.k
kcl library/main.k | kubectl apply -f -
```

### KeycloakStack Instance
```yaml
apiVersion: kro.run/v1alpha1
kind: KeycloakStack
metadata:
  name: keycloak-dev
spec:
  projectName: "dev"
  environment: "dev"
  keycloakReplicas: 1
  keycloakImage: "quay.io/keycloak/keycloak:latest"
  localTest: false
  rdsInstanceClass: "db.t3.micro"
  rdsAllocatedStorage: 20
  rdsEngineVersion: "17"
  rdsDBName: "keycloak"
  rdsSubnetIDs:
    - "subnet-0436a5657992422d2"
  rdsVPCID: "vpc-0d7e4425ca4d23f89"
```

KRO ResourceGraphDefinition creates a new KeycloakStack API. Uses ACK EC2/RDS Controllers and External Secrets Operator for AWS integration.
