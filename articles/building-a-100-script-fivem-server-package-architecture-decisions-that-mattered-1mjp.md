---
title: "Building a 100+ Script FiveM Server Package: Architecture Decisions That Mattered"
url: "https://dev.to/meteostudios/building-a-100-script-fivem-server-package-architecture-decisions-that-mattered-1mjp"
author: "meteostudios"
category: "gaming-agents"
---
# Building a 100+ Script FiveM Server Package: Architecture Decisions That Mattered
**Author:** Meteo Studios  **Published:** May 7, 2026

## Overview
Examines architectural patterns used to manage over 100 interconnected Lua scripts in a FiveM server package while maintaining performance (0.42ms total client CPU) and security. Documents the shift from an "assembled" approach to intentional engineering.

## Key Concepts
- **Centralized Configuration**: Single source of truth via `meteo.cfg` — scripts read globals using `GetConvar()` rather than hardcoding values. Enables rapid rebranding without code changes
- **Event-Driven Architecture**: Replacement of polling loops with event-based patterns using `lib.points` for proximity detection and `lib.onCache` for state change reactions
- **Integrated Game Systems**: Crime ecosystem connected through unified tablet interface — territory control, drug turf, heists, and economy all interconnected
- **Security-First Design**: Server-side authority for critical actions, validated net events with permission checks, NUI callback strict mode enabled, rate limiting on sensitive operations
- **Internationalization**: Multi-language support via `ox_lib` locale system — 14+ languages included by default
- **Performance Testing**: Client-side resmon (target: under 0.05ms per script) + server profiler data in JSON for Chrome DevTools analysis

```lua
-- Configuration Reading via GetConvar
local currency = GetConvar('meteo:currency', '$')
local serverName = GetConvar('meteo:servername', 'My Server')
```

```lua
-- Proximity-Based Loading with lib.points
local point = lib.points.new({
    coords = vec3(x, y, z),
    distance = 15,
})

function point:onEnter()
    -- Load targets, spawn entities
end

function point:onExit()
    -- Cleanup
end
```

```lua
-- Locale Implementation
lib.locale('crime_tablet_title')
lib.locale('job_level_up', { level = newLevel })
```

```cfg
# meteo.cfg — Single config file for entire server
set meteo:currency "$"
set meteo:servername "My Server"
set meteo:discord_enabled true
set meteo:discord_app_id "YOUR_APPLICATION_ID"
```

## Resources
- Documentation: https://docs.meteofivem.net
