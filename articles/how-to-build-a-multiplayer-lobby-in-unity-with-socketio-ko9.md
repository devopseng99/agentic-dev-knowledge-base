---
title: "How to Build a Multiplayer Lobby in Unity with Socket.IO"
url: "https://dev.to/magithar/how-to-build-a-multiplayer-lobby-in-unity-with-socketio-ko9"
author: "magithar"
category: "gaming-agents"
---
# How to Build a Multiplayer Lobby in Unity with Socket.IO
**Author:** Magithar Sridhar  **Published:** April 9, 2026

## Overview
Production-level guide to building multiplayer lobbies in Unity using socketio-unity. Rather than covering basic connectivity, focuses on real-world scenarios: player disconnections, host migration, reconnection with credential restoration, and state synchronization. Three-layer architecture: networking (LobbyNetworkManager), state management (LobbyStateStore), UI (LobbyUIController).

## Key Concepts
- **Three-Layer Architecture**: Networking, state management, and UI separated — prevents tightly coupled code that breaks during unexpected server events
- **Namespace sockets (`/lobby`)**: Clean event scoping separates lobby from game events
- **Version-based deduplication**: Prevents double-processing during reconnection
- **Session token persistence via PlayerPrefs**: Enables resuming interrupted games
- **10-second grace window**: Disconnected player slots held for reconnection before removal
- **Host migration**: Logic for when original host leaves — seamless transition to next player
- **Diff-based UI updates**: Only changed rows updated, not full list rebuild
- **IL2CPP gotcha**: `[Preserve]` and `[JsonProperty]` attributes required to prevent field stripping in WebGL builds

```csharp
// Namespace Socket Connection
private SocketIOClient _root;
private NamespaceSocket _lobby;

private void Start()
{
    _root = new SocketIOClient(TransportFactoryHelper.CreateDefault());
    _root.ReconnectConfig = new ReconnectConfig { autoReconnect = false };
    _lobby = _root.Of("/lobby");
    _root.Connect("http://localhost:3001");
}
```

```csharp
// Data Models with IL2CPP-safe Serialization Attributes
[Serializable, Preserve]
public class RoomState
{
    [Preserve, JsonProperty("roomId")]   public string roomId;
    [Preserve, JsonProperty("hostId")]   public string hostId;
    [Preserve, JsonProperty("version")]  public int version;
    [Preserve, JsonProperty("players")]  public List<LobbyPlayer> players;
}

[Serializable, Preserve]
public class LobbyPlayer
{
    [Preserve, JsonProperty("id")]     public string id;
    [Preserve, JsonProperty("name")]   public string name;
    [Preserve, JsonProperty("ready")]  public bool ready;
    [Preserve, JsonProperty("status")] public string status; // "connected" | "disconnected"
}
```

```csharp
// State Store with Version Deduplication
public void ApplyRoomState(RoomState newState)
{
    if (newState == null) return;
    if (newState.version > 0 && newState.version <= _lastRoomVersion)
        return; // dedupe

    _lastRoomVersion = newState.version;
    DiffAndFirePlayerEvents(CurrentRoom, newState);
    CurrentRoom = newState;
    OnRoomStateChanged?.Invoke(CurrentRoom);
}
```

```csharp
// Session Persistence for Reconnection
private const string PREF_ROOM_ID = "Lobby_LastRoomId";
private const string PREF_PLAYER_ID = "Lobby_PlayerId";
private const string PREF_SESSION_TOKEN = "Lobby_SessionToken";

// On reconnect — attempt restoration
private void HandleConnected()
{
    string pid = PlayerPrefs.GetString(PREF_PLAYER_ID, "");
    string room = PlayerPrefs.GetString(PREF_ROOM_ID, "");
    string token = PlayerPrefs.GetString(PREF_SESSION_TOKEN, "");

    if (!string.IsNullOrEmpty(pid) && !string.IsNullOrEmpty(token))
    {
        networkManager.ReconnectSession(pid, room, token);
        StartCoroutine(RejoinTimeout(5f));
    }
}
```

## GitHub Repository
https://github.com/Magithar/socketio-unity
- Lobby sample: `Samples~/Lobby/` in the repository
