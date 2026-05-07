---
title: "What is Google Agents CLI? Full Beginner Guide"
url: "https://dev.to/proflead/what-is-google-agents-cli-full-beginner-guide-mnk"
author: "Vladislav Guzey"
category: "cloud-agents"
---

# What is Google Agents CLI? Full Beginner Guide
**Author:** Vladislav Guzey
**Published:** April 29, 2026

## Overview
Guide to Google's Agents CLI -- an official tool for creating, evaluating, and deploying ADK agents. Covers the Agent Development Lifecycle (ADLC), seven bundled skills, installation, core commands, and deployment to Cloud Run or Agent Runtime.

## Key Concepts

### Installation

```bash
sudo apt install python3 python3-pip
sudo apt install nodejs npm
pip install uv

python -m venv agent-env
source agent-env/bin/activate
uvx google-agents-cli setup
```

### Core Commands

```bash
agent-cli create my-first-agent
agent-cli install
agent-cli playground
agents-cli eval run
agents-cli deploy
agents-cli publish gemini-enterprise
```

### Key Features
- Web-based playground for local testing
- Automatic credential inheritance from gcloud CLI
- Deployment: Cloud Run or Agent Runtime
- Integration with coding assistants (Claude, Copilot, Gemini)
- macOS and Linux supported; Windows requires WSL 2
