---
title: "Eliza, AI agents, and Fleek"
url: "https://dev.to/tobysolutions/eliza-ai-agents-and-fleek-5e1p"
author: "Tobiloba Adedeji"
category: "web3-blockchain-agents"
---

# Eliza, AI agents, and Fleek
**Author:** Tobiloba Adedeji
**Published:** January 11, 2025

## Overview
Deep dive into the Eliza AI agent framework (ai16z), its architecture, characterfile configuration system, and deployment via Fleek's verifiable cloud platform with TEE support.

## Key Concepts

### Characterfile Configuration

```json
{
  "name": "TechAI",
  "modelProvider": "openai",
  "clients": ["twitter"],
  "bio": "AI researcher and educator focused on practical applications",
  "settings": {
    "secrets": {
      "TWITTER_USERNAME": "john-doe-2",
      "OPENAI_API_KEY": "sk"
    }
  },
  "lore": ["Pioneer in open-source AI development"],
  "messageExamples": [
    [
      {"user": "{{user1}}", "content": {"text": "Can you explain how AI models work?"}},
      {"user": "TechAI", "content": {"text": "Think of AI models like pattern recognition systems..."}}
    ]
  ],
  "style": {
    "all": ["explain complex topics simply"],
    "chat": ["be cool, don't act like an assistant"],
    "post": ["be concise", "use engaging language"]
  }
}
```

### Launch Command

```shell
pnpm start --characters="characters/techai.characters.json"
```

### Eliza Architecture
- Input Processing: NLU with intent classification, entity recognition
- Cognitive Engine: Planning, goal decomposition, strategy selection
- Memory Systems: Short-term (current) and long-term (historical)
- 8 client platforms: Discord, GitHub, Twitter, Telegram, Direct API, Farcaster, Lens, Slack
- Flexible AI models: local inference, OpenAI, Claude, Nous Hermes Llama 3.1B

### Fleek Deployment
One-click agent deployment with TEEs for verifiability, auto-scaling, and 3-minute deploy times.
