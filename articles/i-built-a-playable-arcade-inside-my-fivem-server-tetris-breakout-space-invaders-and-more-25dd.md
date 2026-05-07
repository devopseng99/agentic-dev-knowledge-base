---
title: "I Built a Playable Arcade Inside My FiveM Server — Tetris, Breakout, Space Invaders and More"
url: "https://dev.to/tackk3/i-built-a-playable-arcade-inside-my-fivem-server-tetris-breakout-space-invaders-and-more-25dd"
author: "tackk3"
category: "gaming-agents"
---
# I Built a Playable Arcade Inside My FiveM Server — Tetris, Breakout, Space Invaders and More
**Author:** Tack k  **Published:** March 18, 2026

## Overview
Created a fully functional arcade system (exs-arcade) for a QBCore FiveM roleplay server. Players interact with decorative arcade cabinets to play four classic games with persistent leaderboards. Three-layer architecture: Lua scripting, TypeScript/Svelte UI, Node.js backend with MySQL database. Developed collaboratively with Claude Opus AI.

## Key Concepts
- **Three-Layer Architecture**: Lua client → Svelte NUI → Node.js server — clear separation of concerns
- **Four Playable Games**: Block Puzzle (Tetris), Alien Shooter (Space Invaders), Brick Breaker (Breakout), Racing (time-attack)
- **Prop-Based and Location-Based Detection**: Two cabinet interaction modes — proximity to 3D prop or fixed coordinates
- **Server-Side Score Validation**: Personal-best deduplication, ascending sort for time-attack vs. descending for score-based games
- **Persistent Leaderboards**: MySQL via oxmysql — per-game and overall combined rankings
- **AI-Assisted Development**: Built with Claude Opus for UI scaffolding and game logic implementation

```lua
-- Prop-Based Cabinet Detection
local obj = GetClosestObjectOfType(
    coords.x, coords.y, coords.z,
    Config.InteractDistance,
    Config.CabinetModel,
    false, false, false
)

if obj ~= 0 then
    DrawText3D(objCoords.x, objCoords.y, objCoords.z + 1.0, '[E] Play Arcade')

    if IsControlJustReleased(0, 38) then -- E key
        FreezeEntityPosition(PlayerPedId(), true)
        openArcade()
    end
end
```

```javascript
// Score Sorting Logic
var TIME_ATTACK_GAMES = ['racing'];
var SCORE_GAMES = ['tetris', 'invaders', 'breakout'];

var order = isTimeAttack(gameId) ? 'ASC' : 'DESC';
```

```lua
-- Configuration
Config.UseLocations = false  -- true = coordinate mode, false = prop detection
```

## Tech Stack
| Component | Technology |
|-----------|-----------|
| Client | Lua (QBCore) |
| UI | Svelte 5 + TypeScript |
| Build | Vite |
| Server | Node.js |
| Database | MySQL (oxmysql) |
