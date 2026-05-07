---
title: "Setting Up Discord Rich Presence for FiveM Servers: QBox, QBCore, and Custom servers"
url: "https://dev.to/meteostudios/setting-up-discord-rich-presence-for-fivem-servers-qbox-qbcore-and-custom-servers-5a0o"
author: "meteostudios"
category: "gaming-agents"
---
# Setting Up Discord Rich Presence for FiveM Servers: QBox, QBCore, and Custom servers
**Author:** Meteo Studios  **Published:** May 5, 2026

## Overview
Technical guide for implementing Discord Rich Presence on FiveM roleplay servers. Explains how to replace generic "Playing FiveM" statuses with customized server branding including server names, logos, and player counts. Three implementation approaches across popular server frameworks.

## Key Concepts
- **Discord Rich Presence**: Displays detailed game status information to a player's Discord friend list — passive server marketing
- **Application ID**: Unique identifier from Discord Developer Portal required for RPC functionality
- **Art Assets**: Custom logos and icons uploaded to Discord for display in presence status
- **Framework-Specific Implementations**: Different configuration methods for QBox, QBCore, and custom servers
- **Server Marketing Value**: Passive brand exposure through player status displays to their friend networks

```lua
-- QBox Implementation
-- qbx_core/config/client.lua
discord = {
    appId = 'YOUR_APPLICATION_ID',
    largeIcon = { icon = 'server_logo_large', text = 'My Server' },
    smallIcon = { icon = 'server_logo_small', text = 'FiveM' },
}
```

```lua
-- QBCore Implementation
-- qb-smallresources/config.lua
Config.Discord = {
    appId = 'YOUR_APPLICATION_ID',
    largeIcon = { icon = 'server_logo_large', text = 'My Server' },
    smallIcon = { icon = 'server_logo_small', text = 'FiveM' },
}
```

```cfg
# Config-Based Approach (Meteo Server)
set meteo:discord_enabled true
set meteo:discord_player_count true
set meteo:discord_app_id "YOUR_APPLICATION_ID"
set meteo:discord_icon_large "server_logo_large"
set meteo:discord_icon_small "server_logo_small"
```

## Resources
- Discord Developer Portal: https://discord.com/developers/applications
- QBox Documentation: https://docs.qbox.re/resources/qbx_core/discord
- Meteo Documentation: https://docs.meteofivem.net/servers/meteo-fivem-server/documentation
