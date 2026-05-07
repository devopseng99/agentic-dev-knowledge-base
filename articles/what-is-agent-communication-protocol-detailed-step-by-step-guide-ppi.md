---
title: "What is Agent Communication Protocol: Detailed Step by Step Guide"
url: "https://dev.to/vishalmysore/what-is-agent-communication-protocol-detailed-step-by-step-guide-ppi"
author: "vishalmysore"
category: "a2a-protocols"
---

# What is Agent Communication Protocol: Detailed Step by Step Guide
**Author:** vishalmysore
**Published:** August 31, 2025

## Overview
Comprehensive guide to ACP (Agent Communication Protocol), an open standard from Linux Foundation AI and IBM for dynamic multi-agent environments.

## Key Concepts

### ACP Endpoints
- `GET /ping` - Health check
- `GET /agents` - List available agents
- `GET /agents/{name}` - Get agent manifest
- `POST /runs` - Create/start agent runs
- `GET /runs/{run_id}` - Get run status
- `POST /runs/{run_id}/cancel` - Cancel running processes
- `GET /runs/{run_id}/events` - Event chronology
- `GET /session/{session_id}` - Session details

### Technical Specs
- Version: 0.2.0
- License: Apache 2.0
- Built for: multi-agent AI systems, chatbots, agent marketplaces, enterprise workflow orchestration
