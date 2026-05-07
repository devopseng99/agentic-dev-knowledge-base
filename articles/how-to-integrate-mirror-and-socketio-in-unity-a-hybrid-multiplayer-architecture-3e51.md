---
title: "How to Integrate Mirror and SocketIO in Unity — A Hybrid Multiplayer Architecture"
url: "https://dev.to/magithar/how-to-integrate-mirror-and-socketio-in-unity-a-hybrid-multiplayer-architecture-3e51"
author: "magithar"
category: "gaming-agents"
---
# How to Integrate Mirror and SocketIO in Unity — A Hybrid Multiplayer Architecture
**Author:** Magithar Sridhar  **Published:** April 23, 2026

## Overview
Rather than choosing between Mirror (Unity in-scene networking) or Socket.IO (backend WebSocket), demonstrates how to architect a production-grade multiplayer system using both technologies in complementary roles. Socket.IO handles server-brokered functions; Mirror handles real-time in-scene synchronization.

## Key Concepts
- **Architecture Separation**: "Socket.IO is the pipe" for server-brokered functions; "Mirror never validates — it only synchronises"
- **Socket.IO responsibilities**: Matchmaking, lobby management, session identity, reconnection recovery, authoritative game state (scores, kills, rounds), host migration
- **Mirror responsibilities**: Real-time transform synchronization, physics and animation state, in-scene player lifecycle, frame-rate dependent updates
- **Four Session Phases**: Lobby (Socket.IO only) → Match Start Handoff → In-Game (both active) → Teardown
- **ServerMode enum**: Supports PeerToPeer, DedicatedKCP, DedicatedWebSocket deployment patterns
- **Teardown Sequence**: Stop Mirror → Clean event handlers → Clear mappings → Signal leave (order matters)

```csharp
// Core GameEventBridge
public class GameEventBridge : MonoBehaviour
{
    private Action<string> _scoreHandler;
    private Action<string> _killHandler;

    public void Subscribe()
    {
        var game = lobbyNetworkManager.Socket.Of("/game");

        _scoreHandler = (string json) =>
        {
            var obj = JObject.Parse(json);
            string playerId = obj["playerId"]?.ToString();
            int score = obj.Value<int>("score");

            var identity = GameIdentityRegistry.GetNetworkObject(playerId);
            if (identity != null)
                identity.GetComponent<PlayerScore>()?.SetScore(score);
        };

        game.On("score_update", _scoreHandler);
        game.On("player_killed", _killHandler);
    }

    public void Cleanup()
    {
        var game = lobbyNetworkManager.Socket.Of("/game");
        game.Off("score_update", _scoreHandler);
        game.Off("player_killed", _killHandler);
    }

    void OnDestroy() => Cleanup();
}
```

```csharp
// Proper Teardown Sequence
// Step 1 — Mirror first
if (NetworkServer.active) mirrorNetworkManager.StopHost();
else mirrorNetworkManager.StopClient();

// Step 2 — Clean /game namespace handlers
gameEventBridge.Cleanup();

// Step 3 — Clear netId <-> playerId mappings
GameIdentityRegistry.Clear();

// Step 4 — Signal intentional leave
lobbyNetworkManager.LeaveRoom();
```

```
# Package Installation
# socketio-unity:
https://github.com/Magithar/socketio-unity.git?path=/package

# NativeWebSocket (required):
https://github.com/endel/NativeWebSocket.git#upm
```

## GitHub Repository
https://github.com/Magithar/socketio-unity (MIT, zero paid dependencies)
- Live Demo: https://magithar.github.io/socketio-unity/
