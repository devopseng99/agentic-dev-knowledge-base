---
title: "Jenkins Agents On Kubernetes"
url: "https://dev.to/cwprogram/jenkins-agents-on-kubernetes-578h"
author: "Chris White"
category: "k8s-native-agents"
---

# Jenkins Agents On Kubernetes
**Author:** Chris White
**Published:** September 4, 2023

## Overview
Configuring Kubernetes as a provider for Jenkins build agents using OpenID Connect (OIDC) authentication, including RBAC setup and custom agent images.

## Key Concepts

### OIDC API Server Configuration
```yaml
- --oidc-issuer-url=https://jenkins:8080/oidc
- --oidc-client-id=[unique value of some kind]
- --oidc-username-claim=sub
- --oidc-username-prefix="oidc:"
```

### RBAC Role and RoleBinding
```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: jenkins-oidc
  namespace: jenkins
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["create","delete","get","list","patch","update","watch"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create","delete","get","list","patch","update","watch"]
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get","list","watch"]
```

### Custom Agent Dockerfile
```dockerfile
FROM jenkins/inbound-agent:3148.v532a_7e715ee3-1-jdk11
COPY ca-chain.crt /usr/local/share/ca-certificates/
USER root
RUN apt-get update
RUN apt-get upgrade -y
RUN update-ca-certificates
RUN ${JAVA_HOME}/bin/keytool -import -trustcacerts -cacerts -noprompt -storepass changeit -alias jenkins-ca -file /usr/local/share/ca-certificates/ca-chain.crt
```

### Pipeline Pod Template
```groovy
podTemplate(yaml: '''
    apiVersion: v1
    kind: Pod
    spec:
      containers:
      - name: busybox
        image: busybox
        command:
        - sleep
        args:
        - 99d
    ''') {
    node(POD_LABEL) {
      container('busybox') {
        sh 'echo "test"'
      }
    }
}
```
