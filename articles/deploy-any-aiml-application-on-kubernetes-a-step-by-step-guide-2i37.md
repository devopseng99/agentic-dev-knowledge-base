---
title: "Deploy Any AI/ML Application On Kubernetes: A Step-by-Step Guide"
url: "https://dev.to/pavanbelagatti/deploy-any-aiml-application-on-kubernetes-a-step-by-step-guide-2i37"
author: "Pavan Belagatti"
category: "k8s-native-agents"
---

# Deploy Any AI/ML Application On Kubernetes: A Step-by-Step Guide
**Author:** Pavan Belagatti
**Published:** October 2, 2023

## Overview
Step-by-step guide for deploying an OpenAI-powered Node.js application on Kubernetes using Docker, Minikube, and SingleStore database.

## Key Concepts

### Dockerfile
```dockerfile
FROM node:14-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:14-alpine as run
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/package*.json ./
EXPOSE 3000
CMD ["npm", "start"]
```

### Kubernetes Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: genai-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: genai-app
  template:
    metadata:
      labels:
        app: genai-app
    spec:
      containers:
        - name: genai-app
          image: pavansa/generativeai-node-app:latest
          ports:
            - containerPort: 3000
```

### Service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: genai-app-service
spec:
  selector:
    app: genai-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: LoadBalancer
```
