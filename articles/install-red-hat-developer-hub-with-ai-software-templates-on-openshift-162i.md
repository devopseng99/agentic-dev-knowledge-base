---
title: "Install Red Hat Developer Hub with AI Software Templates on OpenShift"
url: "https://dev.to/fortune-ndlovu/install-red-hat-developer-hub-with-ai-software-templates-on-openshift-162i"
author: "Fortune Ndlovu"
category: "templatized-software"
---
# Install Red Hat Developer Hub with AI Software Templates on OpenShift
**Author:** Fortune Ndlovu  **Published:** April 24, 2025

## Overview
This guide demonstrates how to deploy Red Hat Developer Hub (RHDH), built on Backstage, with AI Software Templates on OpenShift. It enables organizations to standardize and accelerate the development of intelligent software through curated internal developer platforms.

## Key Concepts
- **Software Templates**: YAML-defined blueprints that scaffold projects including source repositories, GitOps configurations, CI/CD pipelines (Tekton), and deployment settings
- **AI Software Templates**: Specialized templates that scaffold AI applications (RAG chatbots, audio-to-text, object detection), integrate LLM inference servers (llama.cpp, vLLM), include GitOps support
- **Architecture Flow**: User selects template → parameters collected → template executes steps (fetch, publish to GitHub, catalog registration, ArgoCD configuration) → two repos created (app source and GitOps) → deployment via Argo CD

```bash
sudo curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/bin/yq
sudo chmod +x /usr/bin/yq
```

```bash
git clone https://github.com/redhat-ai-dev/ai-rhdh-installer.git
cd ai-rhdh-installer
```

```bash
cp default-private.env private.env
source private.env
```

```bash
helm upgrade --install ai-rhdh ./chart --namespace ai-rhdh --create-namespace
```

```bash
oc create secret generic rhdh-argocd-secret \
  --from-literal=url=https://github.com/<your-org>/rhdh-ai-gitops \
  --from-literal=token=$GITOPS__GIT_TOKEN \
  -n ai-rhdh
```

```bash
oc create secret generic backstage-env-ai-rh-developer-hub \
  --from-literal=GITHUB__APP__ID=$GITHUB__APP__ID \
  --from-literal=GITHUB__APP__CLIENT__ID=$GITHUB__APP__CLIENT__ID \
  --dry-run=client -o yaml | oc apply -f - -n ai-rhdh
```

```bash
oc rollout restart deployment/backstage-ai-rh-developer-hub -n ai-rhdh
```

GitHub Repos:
- https://github.com/redhat-ai-dev/ai-rhdh-installer
- https://github.com/redhat-ai-dev/ai-lab-template/tree/release-v0.9.x
- https://github.com/redhat-developer/red-hat-developer-hub-software-templates
