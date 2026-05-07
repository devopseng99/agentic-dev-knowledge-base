---
title: "ADK Agents with Amazon Bedrock"
url: "https://dev.to/aws-builders/adk-agents-with-amazon-bedrock-2j8c"
author: "xbill"
category: "bedrock-agent-aws"
---

# ADK Agents with Amazon Bedrock

**Author:** xbill
**Published:** May 5, 2026

## Overview

Guide demonstrating how to configure an ADK (Agent Development Kit) agent to use Amazon Bedrock models through LiteLLM integration. Part 31 of a 32-part AWS development series covering cross-cloud agent development.

## Key Concepts

### Setup

```bash
cd ~
git clone https://github.com/xbill9/gemini-cli-aws
cd adk-litellm
source init.sh
```

### AWS Credentials

```bash
source save-aws-creds.sh
```

### Install Dependencies

```bash
cd adk-litellm
make install
```

### Verify ADK

```bash
adk --version
adk, version 1.32.0
```

### Run Agent Locally

```bash
adk run agents/bedrock
```

### Launch Web Interface

```bash
adk web --host 0.0.0.0
```

For Google Cloud Shell:

```bash
adk web --host 0.0.0.0 --allow_origins 'regex:.*'
```

### Model Details

The implementation uses `amazon.nova-micro-v1:0` as the default Bedrock model via LiteLLM fallback configuration. LiteLLM provides a "Python SDK, Proxy Server (AI Gateway) to call 100+ LLM APIs in OpenAI (or native) format."
