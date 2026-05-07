---
title: "Build Your Own AI Agent in Minutes with Eliza: A Complete Guide"
url: "https://dev.to/nodeshiftcloud/build-your-own-ai-agent-in-minutes-with-eliza-a-complete-guide-263l"
author: "Aditi Bindal"
category: "web3-blockchain-agents"
---

# Build Your Own AI Agent in Minutes with Eliza: A Complete Guide
**Author:** Aditi Bindal
**Published:** January 12, 2025

## Overview
Step-by-step tutorial for building and deploying AI agents using the Eliza framework (ai16z) on cloud infrastructure, with Twitter integration and multiple AI model support.

## Key Concepts

### Installation

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install 23
npm install -g pnpm
git clone https://github.com/ai16z/eliza.git
cd eliza
git checkout $(git describe --tags --abbrev=0)
pnpm install && pnpm build
```

### Character Configuration

```typescript
import { Character, ModelProviderName, defaultCharacter, Clients } from "ai16z/eliza"

export const agentCharacter: Character = {
    ...defaultCharacter,
    clients: [Clients.TWITTER],
    modelProvider: ModelProviderName.GAIANET,
    name: "justachillagent",
    system: `<PUT YOUR CHARACTER DESCRIPTION HERE>`
}
```

### Launch

```bash
npm start
```

### Supported Models
Claude, Grok, LLAMA, OpenAI, and Gaianet (no API key required). Features autonomous tweet posting and real-time response generation with memory system.
