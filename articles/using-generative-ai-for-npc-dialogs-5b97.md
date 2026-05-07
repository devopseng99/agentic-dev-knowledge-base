---
title: "Using generative AI for NPC dialogs"
url: "https://dev.to/jacklehamster/using-generative-ai-for-npc-dialogs-5b97"
author: "jacklehamster"
category: "gaming-agents"
---
# Using generative AI for NPC dialogs
**Author:** Jack Le Hamster  **Published:** April 10, 2024

## Overview
Introduces an open-source gamedev project utilizing OpenAI's chat API to generate dynamic NPC dialogue in RPGs. Rather than relying on pre-scripted conversations, the system creates realistic, diverse interactions that can branch into unexpected topics, enabling emergent gameplay possibilities. Part 11 of the NAPL series.

## Key Concepts
- **Dynamic NPC Dialogue**: AI-generated conversations based on creature descriptions rather than predetermined scripts
- **Emergent Gameplay**: Unscripted conversations enable new gameplay branches designers hadn't planned — NPCs can discuss pizza, philosophy, or anything
- **API-Driven Architecture**: REST API returns JSON payloads with dialogue options and NPC attributes
- **Stateless Processing**: OpenAI API requires passing entire conversation history with each request — stateless on the server side
- **Cost Optimization**: Caching previously-made requests to minimize OpenAI API expenses
- **NPC Attributes**: System tracks anger, seduction, trust, and fear metrics affecting creature behavior and available actions
- **Contextual Actions**: NPC responses determine available actions (fight, trade, recruit, flee)

```json
[{
   "creature": "You see a graceful, glowing angel with magnificent white wings.",
   "player": {
      "A": "Hello there!",
      "B": "You look fascinating. What brings you here?",
      "C": "I challenge you to a duel!",
      "D": "Farewell for now."
   },
   "attributes": {
      "anger": 0,
      "seduced": 0,
      "trust": 0,
      "fear": 0
   },
   "actions": {
      "fight": false,
      "run away": false,
      "trade": false,
      "join party": false
   },
   "info": {
      "name": null
   }
}]
```

```
# API Usage Examples
# Initial request:
https://open-ai-npc.onrender.com/api

# Single choice response:
https://open-ai-npc.onrender.com/api?choice=A

# Custom topic:
https://open-ai-npc.onrender.com/api?choice=about%20pizza

# Multiple sequential choices:
https://open-ai-npc.onrender.com/api?choice=A|B|C
```

## GitHub Repositories
- Main: https://github.com/jacklehamster/open-ai-npc
- UI Library: https://github.com/jacklehamster/dokui-menu
- Live Demo: https://jacklehamster.github.io/open-ai-npc
