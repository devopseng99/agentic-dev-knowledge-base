---
title: "Switching my AI Voice Agent from WebSocket to WebRTC -- What Broke and What I Learned"
url: https://dev.to/aws-builders/switching-my-ai-voice-agent-from-websocket-to-webrtc-what-broke-and-what-i-learned-3dkn
author: Paul SANTUS
category: ai-agents-voice
---

# Switching my AI Voice Agent from WebSocket to WebRTC -- What Broke and What I Learned

**Author:** Paul SANTUS
**Organization:** AWS Community Builders
**Published:** March 27, 2026

---

## Overview

This article documents the migration of an AI voice agent from WebSocket to WebRTC transport, including deployment on Bedrock AgentCore Runtime. The author built upon Darryl Ruggles' bidirectional voice agent using Strands BidiAgent and Amazon Nova Sonic v2.

## Why WebRTC?

Three primary motivations drove the transition:

1. **Lower Latency:** WebRTC uses UDP instead of TCP, allowing streams to continue despite packet loss rather than stalling during retransmission.

2. **Browser Efficiency:** Native browser support eliminates manual audio capture, downsampling, base64 encoding, and custom playback buffering.

3. **Future-Proofing:** "Adding a video stream later is just a matter of adding a track" to the existing connection.

## WebRTC Architecture Primer

### Peer-to-Peer (P2P)
Direct connection between browser and agent without media servers. TURN relays handle NAT traversal but don't inspect traffic.

### Room-Based (SFU)
Media servers sit between participants, selectively forwarding tracks. Examples include LiveKit and Amazon Chime SDK.

**Choice:** The author selected P2P with Amazon Kinesis Video Streams (KVS) as the managed TURN relay, avoiding SFU infrastructure complexity.

## Implementation Architecture

### Local Development Mode
Browser and agent communicate peer-to-peer on the same network. Signaling flows through a Vite dev server proxy to FastAPI backend.

### Deployed Mode
Agent runs in Docker on Bedrock AgentCore in a private VPC. All signaling goes through AgentCore's HTTP `/invocations` endpoint (SigV4-authenticated). Media flows through KVS TURN relay.

---

## Key Technical Challenges & Solutions

### 1. VPC Availability Zone Compatibility
**Problem:** AgentCore only supports specific AZs in each region (us-east-1a, c, d in us-east-1).

**Solution:** Hardcode supported AZs instead of relying on automatic selection.

### 2. Session Affinity
**Problem:** "Multi-step WebRTC handshakes require the agent to remember connection state across requests."

**Solution:** Use `@aws-sdk/client-bedrock-agentcore` SDK with `runtimeSessionId` parameter to ensure all requests reach the same container instance.

### 3. SDP Candidate Filtering
**Problem:** Agent's aiortc generated ICE candidates for all interfaces, including unreachable VPC-internal IPs.

**Solution:** Strip non-relay candidates from SDP answers before returning to browser.

### 4. TURN-Only Mode
**Problem:** Agent wasted time trying host candidates that couldn't work from public internet.

**Solution:** Configure aiortc with `turn_only=True` to skip directly to working relay candidates.

### 5. Lazy KVS Initialization
**Problem:** Calling `kvs.init()` at module import crashed during container startup due to timing of IAM credential availability.

**Solution:** Move initialization to first actual request.

### 6. Cold Start Behavior
**Problem:** Initial WebRTC connections after idle periods sometimes failed despite successful signaling.

**Solution:** Set `--workers 1` in uvicorn command and implement 10-second retry with new session ID on frontend.

---

## Code Examples

### WebRTCBidiInput Adapter
```python
class WebRTCBidiInput:
    def __init__(self, track):
        self._track = track

    async def __call__(self):
        try:
            frame = await self._track.recv()
        except MediaStreamError:
            raise StopAsyncIteration
        resampled = _resampler.resample(frame)
        pcm = b"".join(f.planes[0] for f in resampled)
        return {
            "type": "bidi_audio_input",
            "audio": base64.b64encode(pcm).decode("utf-8"),
            "sample_rate": 16000,
        }
```

### WebRTCBidiOutput Adapter
```python
class WebRTCBidiOutput:
    def __init__(self, output_track):
        self._output_track = output_track

    async def __call__(self, event):
        if event.get("type") == "bidi_audio_stream":
            audio_bytes = base64.b64decode(event["audio"])
            self._output_track.add_audio(audio_bytes)
        elif event.get("type") == "bidi_interruption":
            self._output_track.clear()
```

### Frontend Signaling with AgentCore SDK
```javascript
const invoke = async (action, data = {}) => {
  const client = new BedrockAgentCoreClient({ region, credentials });
  const resp = await client.send(new InvokeAgentRuntimeCommand({
    agentRuntimeArn,
    runtimeSessionId: sessionId,
    contentType: 'application/json',
    payload: new TextEncoder().encode(JSON.stringify({ action, data })),
  }));
  return JSON.parse(new TextDecoder().decode(
    await resp.response.transformToByteArray()
  ));
};
```

---

## Key Takeaways

- **Transport Choice Matters:** UDP-based WebRTC provides superior real-time performance compared to TCP-based WebSocket for voice applications.

- **Session Management is Critical:** Distributed systems handling multi-step protocols require explicit session affinity mechanisms.

- **Network Topology Affects Performance:** In VPC deployments, filtering unreachable candidates and forcing relay-only connections significantly improves connection establishment speed.

- **Lazy Initialization Patterns:** Deferring cloud API calls until genuinely needed prevents startup race conditions.

- **Adapter Pattern for Protocol Bridging:** Cleanly separating transport concerns from agent logic enables the same agent code to work across multiple transports.

---

## Resources

- **GitHub Repository:** Full source code available at `github.com/psantus/strands-bidir-nova`
- **Local Branch:** `feat/webrtc` for development version
- **Deployed Branch:** `feat/webrtc-agentcore` with Terraform configuration
- **Original Reference:** Darryl Ruggles' WebSocket-based implementation
