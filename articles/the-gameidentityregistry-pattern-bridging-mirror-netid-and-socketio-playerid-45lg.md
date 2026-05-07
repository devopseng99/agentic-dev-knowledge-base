---
title: "The Game Identity Registry Pattern — Bridging Mirror netId and Socket.IO playerId"
url: "https://dev.to/magithar/the-gameidentityregistry-pattern-bridging-mirror-netid-and-socketio-playerid-45lg"
author: "magithar"
category: "gaming-agents"
---
# The Game Identity Registry Pattern — Bridging Mirror netId and Socket.IO playerId
**Author:** Magithar Sridhar  **Published:** May 3, 2026

## Overview
Addresses a technical challenge when integrating Mirror (Unity networking) and Socket.IO (Node.js backend) in the same project. Mirror uses `netId` (uint) to identify players, while Socket.IO uses `playerId` (string). The `GameIdentityRegistry` pattern provides a solution through bidirectional lookup tables that bridge these incompatible ID schemes.

## Key Concepts
- **The ID Translation Problem**: Two networking systems generate player identifiers independently at different times — requires a bridge layer
- **Two-Dictionary Approach**: Maintains `_netIdToPlayerId` and `_playerIdToNetId` for O(1) bidirectional lookups
- **Registration Timing**: Happens in `PlayerIdentityBridge` (NetworkBehaviour) when `OnStartLocalPlayer` fires
- **Propagation Method**: Uses Mirror's Command/RPC system to synchronize mappings across server and clients
- **Lookup Safety**: Checks `NetworkServer.spawned` before `NetworkClient.spawned` for proper authority resolution
- **Cleanup Protocol**: Clear registry on normal match end AND unexpected disconnections

```csharp
public static class GameIdentityRegistry
{
    private static readonly Dictionary<uint, string> _netIdToPlayerId = new();
    private static readonly Dictionary<string, uint> _playerIdToNetId = new();

    public static void Register(uint netId, string playerId)
    {
        _netIdToPlayerId[netId] = playerId;
        _playerIdToNetId[playerId] = netId;
    }

    public static NetworkIdentity GetNetworkObject(string playerId)
    {
        if (!_playerIdToNetId.TryGetValue(playerId, out uint netId))
            return null;

        if (NetworkServer.spawned.TryGetValue(netId, out var identity))
            return identity;
        if (NetworkClient.spawned.TryGetValue(netId, out identity))
            return identity;

        return null;
    }

    public static string GetPlayerId(uint netId)
    {
        return _netIdToPlayerId.TryGetValue(netId, out string playerId)
            ? playerId : null;
    }

    public static void Clear()
    {
        _netIdToPlayerId.Clear();
        _playerIdToNetId.Clear();
    }
}
```

```csharp
// Registration via Mirror Command/RPC
public class PlayerIdentityBridge : NetworkBehaviour
{
    public override void OnStartLocalPlayer()
    {
        var store = FindObjectOfType<LobbyStateStore>();
        CmdRegisterIdentity(store.LocalPlayerId);
    }

    [Command]
    private void CmdRegisterIdentity(string playerId)
    {
        GameIdentityRegistry.Register(netIdentity.netId, playerId);
        RpcRegisterIdentity(netIdentity.netId, playerId);
    }

    [ClientRpc]
    private void RpcRegisterIdentity(uint netId, string playerId)
    {
        GameIdentityRegistry.Register(netId, playerId);
    }
}
```

```csharp
// Event Routing Example
game.On("score_update", (string json) =>
{
    var obj = JObject.Parse(json);
    string playerId = obj["playerId"]?.ToString();
    int score = obj.Value<int>("score");

    var identity = GameIdentityRegistry.GetNetworkObject(playerId);
    if (identity == null) return;

    identity.GetComponent<PlayerScore>()?.SetScore(score);
});
```

## GitHub Repository
https://github.com/Magithar/socketio-unity (MIT license)
