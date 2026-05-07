---
title: "The Algorithm That Saved Online Gaming (Bomberman Clone Part 8)"
url: "https://dev.to/tomerl1/building-an-atomic-bomberman-clone-part-8-the-algorithm-that-saved-online-gaming-573e"
author: "tomerl1"
category: "gaming-agents"
---
# The Algorithm That Saved Online Gaming (Bomberman Clone Part 8)
**Author:** Tomer Levy  **Published:** April 13, 2026

## Overview
Explores implementing client-side prediction with server reconciliation — the networking algorithm John Carmack developed for QuakeWorld in 1996 — in a modern browser-based Bomberman clone. Demonstrates how this technique makes games feel responsive despite network latency.

## Key Concepts
- **The Core Problem**: Server-authoritative architectures introduce noticeable input lag. Pressing a key requires a full round-trip to the server (50-100ms) before visual feedback
- **The Carmack Model — Three Steps**: Predict (client immediately moves using server-matched physics) → Verify (server processes input and broadcasts authoritative state) → Reconcile (client compares prediction to reality; snaps if needed)
- **Sequence Numbers**: Every input gets a monotonically increasing ID. The server echoes back the highest confirmed sequence, allowing the client to discard confirmed inputs and replay unconfirmed ones
- **Input Loop Redesign**: Shifted from event-driven (keydown/keyup) to tick-based (60fps callback), maintaining held keys and sending input every frame
- **Array Mutation Bug**: Reassigning `pendingInputBuffer = []` creates a new array; shared references go stale. Must use `pendingInputBuffer.length = 0` to mutate in place
- **Accumulation vs Replacement**: Replay requires cumulative application of inputs, not property spreading

```javascript
// Stale Array Reference Bug (Incorrect):
pendingInputBuffer = [];

// Fix - Mutate in Place:
pendingInputBuffer.length = 0;
```

```javascript
// Reconciliation Bug (Incorrect - Last Input Only):
pendingInputs.forEach((input) => {
  setPlayerPosition({ ...playerData, ...input }, player);
});

// Fix - Accumulate Inputs:
myPlayerSprite.x = serverData.x;
myPlayerSprite.y = serverData.y;
for (const input of pendingInputs) {
  myPlayerSprite.x += input.dx * speed;
  myPlayerSprite.y += input.dy * speed;
}
```

```javascript
// Network Latency Simulation for testing:
wrap(ws.onmessage, (handler) => {
  return (event) => setTimeout(() => handler(event), 100);
});
```

## Key Technical Insights
- References vs. Values: Reassigning arrays creates new objects; shared references become stale
- Accumulation vs. Replacement: Replay requires cumulative application of inputs, not property spreading
- Single Rendering Authority: Local player position must come from one source (reconciliation) to prevent flicker
