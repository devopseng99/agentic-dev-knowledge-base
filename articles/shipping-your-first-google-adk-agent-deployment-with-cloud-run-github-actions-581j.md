---
title: "Shipping Your First Google ADK Agent: Deployment with Cloud Run & GitHub Actions"
url: "https://dev.to/xilentdev/shipping-your-first-google-adk-agent-deployment-with-cloud-run-github-actions-581j"
author: "LaKaleigh Harris"
category: "hackathons"
---

# Shipping Your First Google ADK Agent: Deployment with Cloud Run & GitHub Actions
**Author:** LaKaleigh Harris
**Published:** June 19, 2025

## Overview
A comprehensive guide to deploying Google ADK agents using the "GetHired" multi-agent job-search assistant as a working example. Covers two deployment paths and GitHub Actions CI/CD automation.

## Key Concepts

### Option 1: Simple Deploy
```bash
pip install google-adk
adk deploy cloud_run my_agents \
  --project=YOUR_PROJECT_ID \
  --region=us-central1 \
  $AGENT_PATH
```

### Option 2: Custom Dockerfile
```dockerfile
FROM python:3.11-slim
WORKDIR /app
ENV PORT=8080 PYTHONUNBUFFERED=1 GOOGLE_GENAI_USE_VERTEXAI=true TIMEOUT=300

RUN apt-get update && apt-get install -y curl gnupg && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && apt-get clean

COPY jobsearch_agents/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY jobsearch_agents/package*.json ./
RUN npm install && npm install @gannonh/firebase-mcp

COPY template/ ./template/
COPY jobsearch_agents/ .

EXPOSE ${PORT}
CMD ["python", "-m", "coordinator", "--host=0.0.0.0", "--port=8080"]
```

### GitHub Actions CI/CD
```yaml
- id: auth
  uses: google-github-actions/auth@v2
  with:
    credentials_json: '${{ secrets.GCP_CREDENTIALS }}'

- name: Build and Push Docker Image
  run: |
    IMAGE_NAME="gcr.io/$GOOGLE_CLOUD_PROJECT/gethired-agents"
    docker build -f jobsearch_agents/Dockerfile -t ${IMAGE_NAME}:${IMAGE_TAG} .
    gcloud auth configure-docker gcr.io -q
    docker push ${IMAGE_NAME}:${IMAGE_TAG}
```

### Secrets with Google Secret Manager
```bash
gcloud run deploy SERVICE \
  --image IMAGE_URL \
  --update-secrets=ENV_VAR_NAME=SECRET_NAME:VERSION
```

Required IAM roles: run.admin, iam.serviceAccountUser, cloudbuild.builds.editor, artifactregistry.writer, secretmanager.secretAccessor
