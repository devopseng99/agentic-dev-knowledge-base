---
title: "Sync GitHub repo and Hugging Face Space Repo with GitHub Actions"
url: "https://dev.to/0xkoji/sync-github-repo-and-hugging-face-space-repo-with-github-actions-3ca1"
author: "0xkoji"
category: "huggingface-llm-agents"
---
# Sync GitHub repo and Hugging Face Space Repo with GitHub Actions
**Author:** 0xkoji  **Published:** January 15, 2024

## Overview
The article addresses a workflow challenge where developers maintain separate repositories on GitHub and Hugging Face Spaces. It demonstrates using GitHub Actions to automatically synchronize code between these platforms, eliminating manual updates. Hugging Face Spaces uses a custom "refs" system rather than traditional Git branches, making standard workflows incompatible.

## Key Concepts
- Problem — Hugging Face Spaces uses custom "refs" incompatible with standard developer Git workflows
- Solution — GitHub Actions with the nateraw/huggingface-sync-action
- Trigger — synchronization occurs automatically when code merges to the main branch
- Prerequisites — active accounts on both GitHub and Hugging Face platforms

## Code Examples

### GitHub Actions Workflow
```yaml
name: Sync with Hugging Face Hub

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Sync with Hugging Face
      uses: nateraw/huggingface-sync-action@v0.0.4
      with:
        github_repo_id: your_github_repo_id
        huggingface_repo_id: your_hugging_face_repo_id
        repo_type: space
        space_sdk: gradio
        hf_token: ${{ secrets.HF_TOKEN }}
```

### Sample Gradio Application
```python
import gradio as gr

def greet(name):
    return "Hello " + name + "!!"

iface = gr.Interface(fn=greet, inputs="text", outputs="text")
iface.launch()
```

### Hugging Face Space Configuration
```yaml
---
title: "Gh Action"
emoji: 🐨
colorFrom: blue
colorTo: red
sdk: gradio
sdk_version: 4.14.0
app_file: app.py
pinned: false
license: mit
---
```
