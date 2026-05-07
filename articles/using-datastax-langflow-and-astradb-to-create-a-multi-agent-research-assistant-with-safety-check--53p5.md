---
title: "Using Datastax Langflow and AstraDB to Create a Multi-Agent Research Assistant with Safety Check - Part 1"
url: "https://dev.to/aknox/using-datastax-langflow-and-astradb-to-create-a-multi-agent-research-assistant-with-safety-check--53p5"
author: "Alan Knox"
category: "langflow-agent"
---

# Using Datastax Langflow and AstraDB to Create a Multi-Agent Research Assistant with Safety Check - Part 1

**Author:** Alan Knox
**Published:** December 12, 2024

## Overview

Part 1 of a 5-part series introducing a multi-agent research assistant designed to help researchers find and analyze websites on specific topics through three sequential steps: safety validation, web discovery, and content summarization.

## Key Concepts

### Safety Check Component

The implementation begins with basic safety validation using a Langflow flow, then enhances it with expanded safety parameters. The optimized version addresses multiple risk categories including harmful content, illegal activities, personal data exposure, and prompt injection attempts.

### Web Search Agent

An agent using OpenAPI models demonstrates Langflow's flexibility. The agent retrieves URLs matching user queries while minimizing extraneous output through careful prompt engineering.

Two prompt versions are iterated -- a simple baseline and an optimized variant with examples -- demonstrating how incremental refinement of instructions produces progressively better agent performance.

### Key Takeaway

Observability and safety represent critical design priorities from inception through deployment in multi-agent systems.
