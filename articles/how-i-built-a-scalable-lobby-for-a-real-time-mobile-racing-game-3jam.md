---
title: "How I Built a Scalable Lobby for a Real-Time Mobile Racing Game"
url: "https://dev.to/firulais/how-i-built-a-scalable-lobby-for-a-real-time-mobile-racing-game-3jam"
author: "firulais"
category: "gaming-agents"
---
# How I Built a Scalable Lobby for a Real-Time Mobile Racing Game
**Author:** Diego Castares  **Published:** February 9, 2026

## Overview
Describes the architecture design for Rumble Racer, a four-player mobile racing game combining Subway Surfers-style controls with arcade racing mechanics. Focuses on overcoming scalability challenges in real-time multiplayer gaming by implementing a production-ready server infrastructure supporting worldwide players with low latency.

## Key Concepts
- **Regional Server Deployment**: Low-latency global matchmaking via geographically distributed servers
- **Hybrid Networking**: .NET lobby servers combined with Mirror game servers — separation of lobby management from match simulation
- **Separation of Concerns**: Lobby management (matchmaking, session management) vs. match simulation (physics, real-time positions) handled by different services
- **Docker Containerization**: Container-based deployment with future Kubernetes scalability path
- **Latency-Based Server Selection**: Client initialization selects nearest regional server based on ping
- **Load Balancing**: Lobby server routes to Mirror instances via REST API when match starts
- **Mirror**: Open-source Unity networking engine for game server simulation

## Tech Stack
- Lobby Server: .NET with SignalR
- Game Server: Mirror (open-source Unity networking)
- Transport: Docker containers, future Kubernetes
- Communication: REST API for lobby-to-game handoff

## Game Details
- Rumble Racer: 4-player mobile arcade racing
- Open Beta: Google Play (com.blyts.rumblerace)
