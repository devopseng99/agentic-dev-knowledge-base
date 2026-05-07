---
title: "How to Deploy an Eliza AI Agent on Railway"
url: "https://dev.to/brolag/how-to-deploy-eliza-starter-on-railway-2pbn"
author: "Alfredo Bonilla"
category: "web3-blockchain-agents"
---

# How to Deploy an Eliza AI Agent on Railway
**Author:** Alfredo Bonilla
**Published:** January 24, 2025

## Overview
Quick guide for deploying Eliza Starter (lightweight open-source conversational AI agent framework) on Railway cloud platform from GitHub.

## Key Concepts

### Critical Environment Variable

```
DAEMON_PROCESS=true
```

Cloud platforms like Railway do not support interactive terminals. This setting disables terminal chat functionality, preventing build failures.

### Deployment Steps
1. Clone the Eliza Starter repository
2. Create Railway instance, select "New Project"
3. Connect GitHub, choose "Deploy from GitHub"
4. Configure environment variables (copy .env, add DAEMON_PROCESS=true)
5. Click Deploy
