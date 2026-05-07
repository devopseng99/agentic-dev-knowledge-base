---
title: "Step-by-Step: Building an AI Agent with Flowise, Qdrant and Qubinets"
url: "https://dev.to/nix_25/step-by-step-building-an-ai-agent-with-flowise-qdrant-and-qubinets-4jg5"
author: "Nix"
category: "flowise-agent"
---

# Step-by-Step: Building an AI Agent with Flowise, Qdrant and Qubinets

**Author:** Nix
**Published:** October 9, 2024

## Overview

A comprehensive guide comparing traditional AI agent development with a simplified approach using Qubinets as an intermediary platform to bridge Flowise and Qdrant.

## Key Concepts

### Traditional Development Challenges

- Tool and library selection (workflow management, vector databases)
- Complex development environment setup on cloud platforms
- Dependency installation and configuration
- Network and security configuration
- Packaging, deployment, and ongoing monitoring

### Components Used

- **Flowise** -- workflow/flow builder
- **Qdrant** -- vector database
- **OpenAI Embeddings** -- text-embedding-ada-002 model
- **Recursive Character Text Splitter** -- default 3000 character chunks

### Step-by-Step Implementation

1. **Project Creation** -- Choose environment type (prototype, own cloud, or existing infrastructure)
2. **Configuration** -- Select templates and "qubs" (Qdrant and Flowise components)
3. **Cloud Instantiation** -- Provide cloud provider credentials (5-7 minutes)
4. **Component Synchronization** -- Sync selected qubs to cloud environment (5-10 minutes)
5. **FlowiseAI Setup** -- Create flows using blank canvas or templates, add nodes for Conversational Retrieval QA Chain, text splitters, embeddings
6. **Qdrant Integration** -- Connect Flowise to Qdrant instance, create collections with matching names
7. **Vector Upload and Testing** -- Upload processed vectors, verify document counts, test agent through chat interface

### Practical Example

The tutorial demonstrates building an AI agent answering questions about Qubinets itself, resulting in successful vector storage of 17 documents about the platform's functionality.
