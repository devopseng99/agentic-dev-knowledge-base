---
title: "How to Upload Your Project to Hugging Face Spaces: A Beginner's Step-by-Step Guide"
url: "https://dev.to/koolkamalkishor/how-to-upload-your-project-to-hugging-face-spaces-a-beginners-step-by-step-guide-1pkn"
author: "KAMAL KISHOR"
category: "huggingface-llm-agents"
---
# How to Upload Your Project to Hugging Face Spaces: A Beginner's Step-by-Step Guide
**Author:** KAMAL KISHOR  **Published:** May 2, 2025

## Overview
This beginner-focused tutorial explains deploying machine learning applications to Hugging Face Spaces using two authentication methods. The guide covers prerequisites, step-by-step instructions for both HTTPS (token-based) and SSH (key-based) approaches, troubleshooting, and includes a sample Gradio temperature converter project.

## Key Concepts
- Hugging Face Spaces — free ML deployment platform for Gradio, Streamlit, and FastAPI
- HTTPS method recommended for most users; SSH preferred by advanced developers
- Automatic redeployment on code pushes
- Project structure requirements: README.md, requirements.txt, app.py

## Code Examples

### Python - Gradio App (app.py)
```python
import gradio as gr

def convert(temp_f):
    return (float(temp_f) - 32) * 5/9

gr.Interface(fn=convert, inputs="text", outputs="text",
             title="F to C Converter").launch()
```

### Requirements File
```
gradio
```

### HTTPS Git Setup
```bash
cd your-project-folder
git init
git remote add origin https://<your-username>:<your-token>@huggingface.co/spaces/<your-username>/<your-space-name>
git add .
git commit -m "Initial commit"
git push -u origin main
```

### SSH Key Generation
```bash
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
```

### SSH Git Configuration
```bash
git remote set-url origin git@huggingface.co:spaces/your-username/your-space-name.git
git add .
git commit -m "Initial SSH push"
git push
```
