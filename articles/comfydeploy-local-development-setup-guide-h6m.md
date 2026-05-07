---
title: "ComfyDeploy Local Development Setup Guide"
url: "https://dev.to/ogkai/comfydeploy-local-development-setup-guide-h6m"
author: "ogkai"
category: "ai-image-video-generation"
---
# ComfyDeploy Local Development Setup Guide
**Author:** ogkai  **Published:** 2025-11-15

## Overview
Step-by-step guide for setting up ComfyDeploy locally for development — a platform that simplifies deploying and managing ComfyUI workflows as production APIs.

## Key Concepts

### What is ComfyDeploy?
ComfyDeploy wraps ComfyUI workflows into production-ready REST APIs. You design your workflow in ComfyUI's visual editor, upload it to ComfyDeploy, and get an API endpoint you can call from any application.

### Prerequisites
- Node.js 18+ for the web dashboard
- Python 3.10+ for ComfyUI
- Docker (optional but recommended)
- GPU with 8GB+ VRAM (or CPU fallback)

### Local Setup

```bash
# Clone ComfyDeploy
git clone https://github.com/BennyKok/comfydeploy
cd comfydeploy

# Install dependencies
npm install

# Configure environment
cp .env.example .env.local
```

```bash
# .env.local configuration
COMFY_DEPLOY_API_KEY=your-api-key
COMFYUI_URL=http://localhost:8188
NEXT_PUBLIC_APP_URL=http://localhost:3000
DATABASE_URL=postgresql://localhost:5432/comfydeploy
```

### Starting the Development Stack

```bash
# Start PostgreSQL (via Docker)
docker run -d \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_DB=comfydeploy \
  -p 5432:5432 \
  postgres:15

# Run database migrations
npx prisma migrate dev

# Start ComfyUI (in separate terminal)
cd /path/to/ComfyUI
python main.py --port 8188

# Start ComfyDeploy dashboard
npm run dev
```

### Deploying a Workflow via API

```python
import requests

# Upload workflow JSON
with open("my_workflow_api.json", "r") as f:
    workflow_json = f.read()

# Create deployment
response = requests.post(
    "http://localhost:3000/api/deployments",
    headers={"Authorization": "Bearer YOUR_API_KEY"},
    json={
        "workflow": workflow_json,
        "name": "my-image-gen-workflow",
        "description": "Text-to-image with SDXL"
    }
)
deployment_id = response.json()["deployment_id"]
print(f"Deployed: {deployment_id}")
```

### Running a Generation

```python
# Run workflow via ComfyDeploy API
run_response = requests.post(
    f"http://localhost:3000/api/run",
    headers={"Authorization": "Bearer YOUR_API_KEY"},
    json={
        "deployment_id": deployment_id,
        "inputs": {
            "prompt": "A cyberpunk city at night",
            "negative_prompt": "blurry, low quality",
            "seed": 42
        }
    }
)
run_id = run_response.json()["run_id"]

# Poll for result
import time
while True:
    status_response = requests.get(
        f"http://localhost:3000/api/run/{run_id}",
        headers={"Authorization": "Bearer YOUR_API_KEY"}
    )
    status = status_response.json()
    if status["status"] == "success":
        print(f"Image URL: {status['outputs']['image_url']}")
        break
    elif status["status"] == "failed":
        print(f"Error: {status['error']}")
        break
    time.sleep(2)
```

### Key Benefits
- Version your workflows (git-trackable JSON)
- Share workflows as reusable API endpoints
- Monitor generation history and costs
- Scale from local development to cloud deployment without code changes
