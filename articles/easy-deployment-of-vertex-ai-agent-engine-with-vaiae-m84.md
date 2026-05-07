---
title: "Easy Deployment of Vertex AI Agent Engine with vaiae"
url: "https://dev.to/toyama0919/easy-deployment-of-vertex-ai-agent-engine-with-vaiae-m84"
author: "Hiroshi Toyama"
category: "cloud-agents"
---

# Easy Deployment of Vertex AI Agent Engine with vaiae
**Author:** Hiroshi Toyama
**Published:** November 29, 2025

## Overview
Introduction to vaiae, a CLI tool that simplifies Vertex AI Agent Engine deployment through YAML configuration and profile management. Supports multi-environment deployments, dry-run mode, and Python API usage.

## Key Concepts

### Installation

```bash
pip install vaiae
```

### YAML Configuration (.agent-engine.yml)

```yaml
default:
  vertex_ai:
    project: "my-gcp-project"
    location: "asia-northeast1"
    staging_bucket: "my-staging-bucket"
  display_name: "my-agent-engine"
  agent_engine:
    instance_path: "my_package.agents.main_agent"
  env_vars:
    API_KEY: "your-api-key"
  requirements:
    - "google-cloud-aiplatform[adk,agent_engines]==1.96.0"
```

### Agent Implementation

```python
from google.adk.agents import Agent

def get_weather(location: str) -> str:
    return f"The weather in {location} is sunny, 22C"

main_agent = Agent(
    name="my_agent",
    model="gemini-2.0-flash-exp",
    tools=[get_weather],
)
```

### Core CLI Commands

```bash
vaiae deploy
vaiae deploy --dry-run
vaiae list
vaiae send -m "message"
vaiae delete
```

### Multi-Environment Profiles

```bash
vaiae --profile development deploy
vaiae --profile production deploy
```

### Python API

```python
from vaiae.core import Core
core = Core(yaml_file_path=".agent-engine.yml", profile="default")
core.create_or_update_from_yaml(dry_run=False)
```
