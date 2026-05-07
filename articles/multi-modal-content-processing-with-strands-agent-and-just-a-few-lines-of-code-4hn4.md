---
title: "Multi-Modal Content Processing with Strands Agents"
url: "https://dev.to/aws/multi-modal-content-processing-with-strands-agent-and-just-a-few-lines-of-code-4hn4"
author: "Elizabeth Fuentes L"
category: "multimodal"
---

# Multi-Modal Content Processing with Strands Agents

**Author:** Elizabeth Fuentes L
**Published:** July 15, 2025
**Organization:** AWS

## Overview

This article demonstrates building AI agents capable of processing diverse content types -- images, PDFs, videos, and documents -- using the Strands Agent framework with minimal code.

## Key Concepts

The tutorial explains how to create agents that "move beyond text-only interactions to understand and process diverse content types" using tools that extend agent capabilities.

## Core Implementation

### Basic Agent Setup

```python
from strands import Agent
from strands.models import BedrockModel
from strands_tools import image_reader, file_read

bedrock_model = BedrockModel(
    model_id=bedrock-model-id,
    temperature=0.3
)

agent = Agent(
    system_prompt=MULTIMODAL_SYSTEM_PROMPT,
    tools=[image_reader, file_read, video_reader],
    model=bedrock_model
)
```

### System Prompt

The agent uses a custom prompt directing it to handle PNG, JPEG, GIF, WebP images; PDF, CSV, DOCX, XLS documents; and MP4, MOV, AVI, MKV, WebM videos with appropriate tools.

## Custom Tools

Since video processing wasn't available pre-built, the author created a custom `video_reader` tool leveraging existing code from previous projects, using the Strands Agent Builder for development.

## Testing Examples

```python
# Image analysis
response = multimodal_agent("Analyze this image: data-sample/image.jpg")

# Document summarization
response = multimodal_agent("Summarize data-sample/Welcome-Strands-Agents-SDK.pdf")

# Video processing
response = multimodal_agent("Summarize data-sample/video.mp4")
```

## Advanced Deployment

The article includes AWS CDK instructions for Lambda deployment, covering environment setup, dependency installation, and serverless deployment.

## Series Context

This is part one of a four-part series exploring Strands Agent capabilities, with upcoming articles covering memory management and knowledge base integration.
