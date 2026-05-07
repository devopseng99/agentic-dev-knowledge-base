---
title: "Hacking the Helm Operator with Flux: Creating Self-Installable Services"
url: "https://dev.to/hkhelil/hacking-the-helm-operator-with-flux-creating-self-installable-services-for-easier-app-deployment-5a8l"
author: "Hamdi (KHELIL) LION"
category: "k8s-native-agents"
---

# Hacking the Helm Operator with Flux: Creating Self-Installable Services
**Author:** Hamdi (KHELIL) LION
**Published:** August 28, 2024

## Overview
Using Operator SDK and Flux to create self-installable Kubernetes services with three examples: NGINX, Apache Tomcat, and Redis operators.

## Key Concepts

### Create Helm-Based Operator
```bash
operator-sdk init --plugins helm --domain mydomain.com --group web --version v1 --kind NGINXOperator
operator-sdk init --plugins helm --domain mydomain.com --group web --version v1 --kind TomcatOperator
operator-sdk init --plugins helm --domain mydomain.com --group data --version v1 --kind RedisOperator
```

Workflow: Scaffold operator -> Add Helm chart -> Customize logic -> Create HelmRelease -> Deploy via `make deploy`. Features automated dependencies, self-configuration via ConfigMaps/Secrets, and built-in autoscaling.
