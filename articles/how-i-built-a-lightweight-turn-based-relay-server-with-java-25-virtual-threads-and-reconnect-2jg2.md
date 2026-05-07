---
title: "How I Built a Lightweight Turn-Based Relay Server with Java 25 Virtual Threads And Reconnect Handling"
url: "https://dev.to/turnkit-dev/how-i-built-a-lightweight-turn-based-relay-server-with-java-25-virtual-threads-and-reconnect-2jg2"
author: "turnkit-dev"
category: "gaming-agents"
---
# How I Built a Lightweight Turn-Based Relay Server with Java 25 Virtual Threads And Reconnect Handling
**Author:** Nenad Nikolić  **Published:** April 19, 2026

## Overview
Describes the design of TurnKit Relay, a backend system for turn-based multiplayer games. The author emphasizes a forward-only architecture that avoids complex state management, leveraging Java 25's virtual threads to handle thousands of concurrent matches efficiently while minimizing bandwidth costs and infrastructure overhead.

## Key Concepts
- **Forward-Only Design**: The server replays only missed moves since the client's last acknowledged move number, eliminating full state resync requirements — dramatic bandwidth savings
- **Java 25 Virtual Threads**: Enables handling thousands of concurrent connections with simplicity and low resource overhead, avoiding traditional thread pool or reactive programming complexity
- **Move-Based Delta Reconnects**: Clients send `RECONNECT { lastMoveNumber }`, and the server responds with only the missed `OnMoveMade` events rather than full state snapshots
- **Server-Managed Hidden State**: Hands, decks, and other sensitive information remain masked server-side, reducing payload sizes and data exposure
- **Egress & Memory Optimization**: Minimal JSON payloads and early termination of stale matches keep operational costs low at scale
- **Open-Source**: Available as TurnKit with documentation at turnkit.dev

## Architecture
- Reconnect message: `RECONNECT { lastMoveNumber }`
- Server response: stream of missed `OnMoveMade` events since that move number
- No full state resync — only the delta from last confirmed move
- Virtual threads: one per connection, no reactor/callback complexity

## Resources
- Documentation: https://turnkit.dev/docs/client-reconnection
