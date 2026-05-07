---
title: "Building a Real-Time Conversational AI Agent with LiveKit, Gemini & Express"
url: https://dev.to/danny_odii/building-a-real-time-conversational-ai-agent-with-livekit-gemini-express-3ho4
author: Daniel Odii
category: ai-agents-voice
---

# Building a Real-Time Conversational AI Agent with LiveKit, Gemini & Express

**Author:** Daniel Odii
**Published:** December 28, 2025
**Last Modified:** December 30, 2025

## Overview

This tutorial guides developers through creating a native multimodal conversational AI voice agent using LiveKit, Google's Gemini 2.5 model, and Express.js. Unlike traditional voice bots that chain separate speech-to-text, language model, and text-to-speech components, this approach achieves near-human conversational latency by processing audio directly through Gemini's native audio capabilities.

## Key Prerequisites

- Active Gemini API key with Speech-to-Text and Text-to-Speech APIs enabled
- Google Cloud service account JSON credentials
- LiveKit account with environment credentials (URL, API key, API secret)

## Project Setup

### Initialize Project Structure

```bash
mkdir voice-ai-agent && cd voice-ai-agent
npm init -y
```

### Configure TypeScript

Update `package.json` with ES module support:

```json
{
  "name": "voice-ai-agent",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "tsx watch src/index.ts"
  }
}
```

Create `tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*"]
}
```

### Install Dependencies

**Development dependencies:**
```bash
npm install -D typescript tsx @types/node @types/express @types/cors
```

**Core dependencies:**
```bash
npm install @livekit/agents @livekit/agents-plugin-google @livekit/rtc-node \
  livekit-server-sdk express cors dotenv
```

## Environment Configuration

Create `.env` file:

```
LIVEKIT_URL=wss://your-livekit-server.livekit.cloud
LIVEKIT_API_KEY=your_livekit_api_key
LIVEKIT_API_SECRET=your_livekit_api_secret
GOOGLE_API_KEY=your_gemini_api_key
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
```

## Core Implementation

### Agent Personality Prompt

Create `src/prompt.ts` to define agent behavior:

```typescript
export const prompt = `
You are Leo, a friendly, general-purpose AI voice assistant.
Keep responses under 45 words.
Sound natural, relaxed, and human — like a smart friend, not a robot.
Avoid buzzwords. Use light, casual language when appropriate.
Always end with a question or invite the user to speak.
Keep the conversation flowing.
If it fits, use casual phrases like "gotcha," "makes sense," or "no worries."
`;
```

**Design principles for voice interactions:**
- Limit responses to under 45 words for natural conversational flow
- Employ turn-taking patterns by concluding with questions
- Use relatable language and contemporary phrases

### Agent Worker Implementation

Create `src/agent.ts` with the conversational engine:

```typescript
import { voice, defineAgent, type JobContext } from '@livekit/agents';
import * as google from '@livekit/agents-plugin-google';
import { prompt } from './prompt.js';

export default defineAgent({
  entry: async (ctx: JobContext) => {
    await ctx.connect();

    const session = new voice.AgentSession({
      llm: new google.beta.realtime.RealtimeModel({
        model: "gemini-2.5-flash-native-audio-preview",
        voice: "Puck",
        inputAudioTranscription: {},
        outputAudioTranscription: {},
      }),
    });

    const agent = new voice.Agent({
      instructions: prompt
    });

    await session.start({ agent, room: ctx.room });
    await session.generateReply();

    (session as any).on('agent_state_changed', (ev: any) => {
      console.log(`Agent is now: ${ev.newState}`);
    });

    let lastActivity = Date.now();
    (session as any).on('user_input_transcribed', () =>
      lastActivity = Date.now()
    );

    setInterval(() => {
      if (Date.now() - lastActivity > 10 * 60 * 1000) {
        ctx.shutdown();
      }
    }, 30000);
  }
});
```

### Express Server

Create `src/index.ts` to handle token generation and worker orchestration:

```typescript
import 'dotenv/config';
import express from 'express';
import { initializeLogger, Worker, WorkerOptions } from '@livekit/agents';
import { AccessToken } from 'livekit-server-sdk';
import path from 'path';
import cors from 'cors';
import fs from 'fs';
import os from 'os';

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());

initializeLogger({ level: 'debug', pretty: true });

// Handle Google credentials flexibly
if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
  const creds = process.env.GOOGLE_APPLICATION_CREDENTIALS;
  if (creds.startsWith('{')) {
    const tempPath = path.join(os.tmpdir(), `google-creds-${Date.now()}.json`);
    fs.writeFileSync(tempPath, creds);
    process.env.GOOGLE_APPLICATION_CREDENTIALS = tempPath;
    console.log(`Using credentials from JSON string, saved to ${tempPath}`);
  } else {
    process.env.GOOGLE_APPLICATION_CREDENTIALS = path.resolve(creds);
    console.log(`Using credentials from file: ${process.env.GOOGLE_APPLICATION_CREDENTIALS}`);
  }
} else if (fs.existsSync(path.resolve('./service-account.json'))) {
  process.env.GOOGLE_APPLICATION_CREDENTIALS = path.resolve('./service-account.json');
  console.log(`Using local service-account.json: ${process.env.GOOGLE_APPLICATION_CREDENTIALS}`);
}

// Token endpoint
app.get('/get-token', async (req, res) => {
  const roomName = (req.query.room as string) || 'voice-chat';
  const participantName = (req.query.user as string) || 'user';

  const token = new AccessToken(
    process.env.LIVEKIT_API_KEY!,
    process.env.LIVEKIT_API_SECRET!,
    { identity: participantName }
  );

  token.addGrant({
    roomJoin: true,
    room: roomName,
    canPublish: true,
    canSubscribe: true
  });

  res.json({ token: await token.toJwt() });
});

// Start worker
const worker = new Worker(
  new WorkerOptions({
    agent: path.resolve('./src/agent.ts'),
    wsURL: process.env.LIVEKIT_URL!,
    apiKey: process.env.LIVEKIT_API_KEY!,
    apiSecret: process.env.LIVEKIT_API_SECRET!,
  })
);

worker.run();

app.listen(port, () =>
  console.log(`Server live at http://localhost:${port}`)
);
```

## Frontend Implementation

Create `client/agent.html` for user interaction:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Real-Time Voice Chat with Leo</title>
  <script src="https://cdn.jsdelivr.net/npm/livekit-client@2.0.4/dist/livekit-client.umd.min.js"></script>
  <style>
    body { font-family: sans-serif; padding: 20px; }
    #transcript { margin-top: 20px; max-height: 400px; overflow-y: auto; border: 1px solid #ccc; padding: 10px; background: #f9f9f9; }
    .message { margin: 8px 0; }
    .user { color: blue; }
    .agent { color: green; }
    .interim { opacity: 0.6; font-style: italic; }
    #agentStatus { font-weight: bold; margin-top: 10px; }
  </style>
</head>
<body>
  <h1>Voice Chat with Leo</h1>
  <button id="joinBtn">Join Chat</button>
  <button id="leaveBtn" disabled>Leave Chat</button>
  <audio id="audioOutput" autoplay controls></audio>
  <div id="agentStatus">Agent status: not connected</div>
  <div id="transcript"></div>
</body>
</html>
```

## Key Architectural Benefits

The native multimodal approach eliminates chained processing steps, significantly reducing latency compared to traditional voice bot architectures. By leveraging "Gemini 2.5 Flash with native audio," the system handles speech input and output simultaneously within a single model, creating a more fluid conversational experience.

## Next Steps

This tutorial establishes the foundational infrastructure. Developers can further enhance the system by:
- Building a production-grade frontend using React or Vue
- Implementing persistent conversation history
- Adding custom audio processing and effects
- Deploying to cloud infrastructure for scalability
