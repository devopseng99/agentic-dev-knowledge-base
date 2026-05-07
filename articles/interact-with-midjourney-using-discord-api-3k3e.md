---
title: "Interact with Midjourney using Discord API - Part I"
url: "https://dev.to/useapi/interact-with-midjourney-using-discord-api-3k3e"
author: "useapi.net"
category: "ai-media-generation"
---
# Interact with Midjourney using Discord API - Part I
**Author:** useapi.net  **Published:** September 14, 2023

## Overview
This guide demonstrates how to automate the Midjourney `/imagine` command through Discord API endpoints. It requires an active Midjourney subscription ($10 Basic Plan minimum) and provides step-by-step instructions for integrating image generation into custom applications.

## Key Concepts

- **Discord API Authorization:** Uses HTTP Authorization headers with user tokens
- **Application Commands:** Retrieves Midjourney command metadata via GET requests
- **Interactions:** Submits image generation requests through POST endpoints
- **Message Polling:** Monitors Discord channels for generated image results
- **Processing Timeline:** Images typically generate in 20 seconds (fast mode) to 10 minutes (relax mode)

Required Setup Values:
- `server_id` — Discord server identifier
- `channel_id` — Discord channel identifier
- `discord_token` — User authentication token

```
GET https://discord.com/api/v10/channels/channel_id/application-commands/search?type=1&include_applications=true&query=imagine
```

```json
{
    "type": 2,
    "application_id": "936929561302675456",
    "guild_id": "server_id",
    "channel_id": "channel_id",
    "session_id": "random_number",
    "data": {
        "version": "1118961510123847772",
        "id": "938956540159881230",
        "name": "imagine",
        "type": 1,
        "options": [{
            "type": 3,
            "name": "prompt",
            "value": "YOUR_PROMPT_HERE"
        }]
    }
}
```

- Postman Collection: https://www.postman.com/useapinet/workspace/useapi-net
- Setup Documentation: https://useapi.net/docs/start-here/setup-midjourney
