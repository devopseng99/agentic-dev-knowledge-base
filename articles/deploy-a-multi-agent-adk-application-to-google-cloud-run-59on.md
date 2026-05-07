---
title: "Deploy a Multi Agent ADK Application to Google Cloud Run"
url: "https://dev.to/gde/deploy-a-multi-agent-adk-application-to-google-cloud-run-59on"
author: "xbill"
category: "cloud-agents"
---

# Deploy a Multi Agent ADK Application to Google Cloud Run
**Author:** xbill (Google Developer Experts)
**Published:** March 24, 2026

## Overview
End-to-end guide for building a multi-agent ADK application in Python, testing locally with the ADK web tool, and deploying to Google Cloud Run. Covers Python version management with pyenv, Gemini CLI setup, ADK visual builder, multi-agent comic generation pipeline, and Cloud Run deployment.

## Key Concepts

### Environment Setup

```console
python --version
# Python 3.13.12

pyenv version
# 3.13.12
```

### Gemini CLI Installation

```shell
npm install -g @google/gemini-cli
```

### Clone and Initialize

```shell
cd ~
git clone https://github.com/xbill9/adkui
source init.sh
pip install -r requirements.txt
```

### Running ADK Web Interface

```console
adk web
# ADK Web Server started
# For local testing, access at http://127.0.0.1:8000.
```

### Multi-Agent Pipeline
- **Agent2**: Uses IMAGEN model for image generation
- **Agent3**: Multi-agent pipeline for comic book generation
- **Agent4**: Online viewer agent for browsing results

### Deploy to Cloud Run

```console
make deploy
# Returns endpoint like:
# https://adk-1056842563084.us-central1.run.app
```

### Reset Environment Variables

```shell
source set_env.sh
```

The ADK visual builder enables defining multi-agent pipelines visually, testing locally via CLI and web tools, then deploying the entire solution to Google Cloud Run.
