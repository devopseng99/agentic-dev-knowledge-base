---
title: "What is ACP?"
url: "https://dev.to/sreeni5018/what-is-acp--3hh1"
author: "Seenivasa Ramadurai"
category: "a2a-protocols"
---

# What is ACP?
**Author:** Seenivasa Ramadurai
**Published:** September 3, 2025

## Overview
ACP (Agent Communication Protocol) is an open REST-native standard for AI agent interaction, enabling interoperable low-latency communication regardless of framework or runtime.

## Key Concepts

### Architecture Patterns
1. Single-agent server
2. Multi-agent server with metadata-based routing
3. Distributed multi-server deployments
4. Router agent pattern for task delegation

### Key Endpoints
- `/runs` - Manage agent execution lifecycle
- `/agents` - Discovery and metadata
- `/agents/{agent_id}/messages` - Message exchange

### Features
- Standardizes communication across LangChain, CrewAI, BeeAI
- Multimodal messaging and streaming
- Local-first orchestration without cloud dependencies
- Agent discovery and collaboration
