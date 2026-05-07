---
title: "Deploy YOLOv5 + FastAPI with Custom Weights on Hugging Face Spaces (Step-by-Step)"
url: "https://dev.to/alienimnida/deploy-yolov5-fastapi-with-custom-weights-on-hugging-face-spaces-step-by-step-31ob"
author: "Alienimnida"
category: "huggingface-llm-agents"
---
# Deploy YOLOv5 + FastAPI with Custom Weights on Hugging Face Spaces (Step-by-Step)
**Author:** Alienimnida  **Published:** July 20, 2025

## Overview
A practical guide for deploying machine learning applications using YOLOv5 object detection combined with FastAPI on Hugging Face Spaces. The author explains why Hugging Face Spaces provides an ideal free deployment platform (16GB RAM, 30-minute idle timeout) and walks through the complete setup from creating a Space to pushing code via Git.

## Key Concepts
- Platform Choice — Hugging Face Spaces offers 16GB RAM and 30-minute idle timeout at no cost
- Required Project Structure — README.md with YAML frontmatter is mandatory
- File System Constraints — temporary files must use `/tmp` directory
- Model Loading — use `torch.hub` instead of `torch.load()` for YOLOv5 compatibility
- Port Configuration — FastAPI applications must run on port 7860

## Code Examples

### README.md Configuration
```yaml
---
title: "Your App Title"
emoji: 🚀
colorFrom: blue
colorTo: purple
sdk: docker
app_file: app.py
pinned: false
---

# Your App Title

A brief description of what your app does.
```

### YOLOv5 Model Loading
```python
model = torch.hub.load('ultralytics/yolov5', 'custom', path='best.pt', trust_repo=True)
```

### FastAPI Server Configuration
```python
uvicorn.run(app, host="0.0.0.0", port=7860)
```

### Git Workflow Commands
```bash
git init
git remote add hf https://huggingface.co/spaces/<your-username>/<your-space-name>
git add .
git commit -m "Initial commit for HF Space"
git push hf main
```
