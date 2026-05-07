---
title: "Why My Model Wouldn't Deploy to Hugging Face Spaces (and What Git LFS Actually Does)"
url: "https://dev.to/czhoudev/why-my-model-wouldnt-deploy-to-hugging-face-spaces-and-what-git-lfs-actually-does-9kf"
author: "Chloe Zhou"
category: "huggingface-llm-agents"
---
# Why My Model Wouldn't Deploy to Hugging Face Spaces (and What Git LFS Actually Does)
**Author:** Chloe Zhou  **Published:** January 11, 2026

## Overview
The author shares her debugging journey after attempting to deploy a fastai-trained image classification model to Hugging Face Spaces. A 10 MiB file size limit triggered rejection errors, and initial troubleshooting attempts failed until she understood how Git LFS functions and Git's commit history mechanics.

## Key Concepts
- Git LFS — replaces large files with pointer files instead of storing full binary content in Git's object database
- The 10 MiB limit — Hugging Face enforces pre-receive hooks scanning for oversized files in any commit
- Orphan Branch Trick — creating an orphan branch with `git checkout --orphan` provides a clean commit history
- `git rm --cached` only affects future commits, not existing history

## Code Examples

### Git LFS Installation and Setup
```bash
brew install git-lfs    # Install Git LFS (macOS via Homebrew)
git lfs install         # Initialize Git LFS and register Git hooks
git lfs version         # Confirm Git LFS installation
```

### Initial Tracking Attempt
```bash
git lfs track "model.pkl"
git add model.pkl
git commit -m "Track model file with Git LFS"
git push
```

### Failed Troubleshooting
```bash
git rm --cached model.pkl
```

### Successful Resolution (Orphan Branch)
```bash
git checkout --orphan clean-main
git add .
git commit -m "Initial deployment with Git LFS model"
git branch -M main
git push -f origin main
```

### Git Attributes Configuration
```
*.pkl filter=lfs diff=lfs merge=lfs -text
```
