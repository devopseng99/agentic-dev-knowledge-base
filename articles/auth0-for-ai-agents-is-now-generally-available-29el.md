---
title: "Auth0 for AI Agents is now generally available!"
url: "https://dev.to/auth0/auth0-for-ai-agents-is-now-generally-available-29el"
author: "Jessica Temporal"
category: "agent-identity"
---

# Auth0 for AI Agents is now generally available!
**Author:** Jessica Temporal
**Published:** November 24, 2025

## Overview
Auth0's authentication solution for AI agents addresses the gap between prototype (hardcoded credentials) and production (multi-user permissions, token refresh, approval workflows).

## Key Concepts

### Four Core Capabilities
1. **User Authentication** - Identify who's talking to the agent, secure access to first-party APIs
2. **Token Vault** - OAuth with 30+ pre-integrated apps (GitHub, Slack, Google Workspace). SDK auto-detects when tool calls need auth, pauses execution, prompts user, stores token, resumes
3. **Asynchronous Authorization** - Client-Initiated Backchannel Authentication (CIBA) for email/Guardian approval
4. **Fine-Grained Authorization for RAG** - Users only access documents within their permission scope

### Framework Support
LangChain, LlamaIndex, Cloudflare AI, Firebase Genkit, Vercel AI SDK (Python and JavaScript).

### Pricing
Free tier includes two connected apps in Token Vault and async authorization.
