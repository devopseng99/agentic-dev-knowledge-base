---
title: "Amazon Bedrock AgentCore Runtime - Part 1 Introduction"
url: "https://dev.to/aws-heroes/amazon-bedrock-agentcore-runtime-part-1-introduction-e5i"
author: "Vadym Kazulkin"
category: "aws-agents"
---

# Amazon Bedrock AgentCore Runtime - Part 1 Introduction
**Author:** Vadym Kazulkin
**Published:** August 22, 2025

## Overview
Introduction to Amazon Bedrock AgentCore Runtime, a fully managed serverless platform for deploying AI agents. Covers key components including Runtime, Memory, Identity, and Observability primitives. Agents built with Strands SDK are portable Python applications deployable across various compute options.

## Key Concepts

### AgentCore Runtime Key Benefits

- **Framework Agnostic:** Transform any local agent code to cloud-native deployments with a few lines of code
- **Model Flexibility:** Works with any LLM including Amazon Bedrock, Anthropic Claude, Google Gemini, and OpenAI
- **Protocol Support:** HTTP REST APIs and Model Context Protocol (MCP)
- **Extended Execution:** Supports workloads up to 8 hours
- **Session Isolation:** Each user session runs in a dedicated microVM with isolated CPU, memory, and filesystem
- **Built-in Authentication:** IAM SigV4 and OAuth-based JWT Bearer Token Authentication

### Key Components

- **Agent Runtime:** Foundational component hosting AI agent or tool code via AgentCore Python SDK or AWS SDKs
- **Endpoints:** Addressable access points (aliases) to specific agent versions with unique ARNs
- **Sessions:** Individual interaction contexts with complete session isolation and microVM sandboxing
- **Versions:** Immutable snapshots capturing complete configuration states for rollback capabilities

### State Persistence with AgentCore Memory

AgentCore Memory offers persistent storage capturing conversation history via `create_event` and `get_last_k_turns` APIs, with long-term memory accessible through `retrieve_memories` across different sessions.

### Update (October 2025)
AgentCore Runtime now supports Agent-to-Agent (A2A) servers in addition to MCP.
