---
title: "Building a real-time multiplayer hub on Nakama in 4 weeks: socket events to Zustand, what I'd do differently"
url: "https://dev.to/itai_zeilig_bb4920bda5007/building-a-real-time-multiplayer-hub-on-nakama-in-4-weeks-socket-events-to-zustand-what-id-do-17cp"
author: "itai_zeilig_bb4920bda5007"
category: "gaming-agents"
---
# Building a real-time multiplayer hub on Nakama in 4 weeks: socket events to Zustand, what I'd do differently
**Author:** Itai Zeilig  **Published:** April 27, 2026

## Overview
Documents a four-week project to add real-time multiplayer features to SQL Protocol, a browser-based SQL query game. The work involved integrating Nakama for WebSocket-based realtime functionality while maintaining existing single-player code. Shares lessons learned on architecture, state management, and what the author would do differently.

## Key Concepts
- **Nakama**: Open-source game server providing WebSocket-based real-time multiplayer functionality
- **Architecture Pattern**: Separated HTTP/RPC (for reads/writes) from WebSocket (for persistent push state)
- **State Management with Zustand**: Socket handlers write directly to Zustand stores rather than managing state in React components
- **Server Authority**: Player positions determined server-side, clients send inputs only — prevents cheating
- **Chat System**: Dual-channel approach — global channel plus per-map channels for scoped communication
- **Position Interpolation**: Linear interpolation toward server positions prevents visual choppiness on the client

```javascript
// Nakama socket state handler writing to Zustand
socket.onmatchdata = (data) => {
  const current = useGameStore.getState().players;
  useGameStore.setState({
    players: { ...current, [data.userId]: data.pos },
  });
};

const players = useGameStore((s) => s.players);
```

## Retrospective Recommendations
- Integrate speech bubbles and chat panel as unified feature from start
- Implement position lerping immediately rather than post-launch
- Include chat in initial multiplayer prototype for liveliness from day one
