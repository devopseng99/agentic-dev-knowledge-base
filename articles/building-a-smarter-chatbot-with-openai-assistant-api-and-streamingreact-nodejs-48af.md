---
title: "Building a Smarter Chatbot with OpenAI Assistant API and Streaming (React & Node.js)"
url: "https://dev.to/blakecodes03/building-a-smarter-chatbot-with-openai-assistant-api-and-streamingreact-nodejs-48af"
author: "Nenlap Jahota"
category: "ai-assistant-api"
---

# Building a Smarter Chatbot with OpenAI Assistant API and Streaming (React & Node.js)

**Author:** Nenlap Jahota
**Published:** February 8, 2025

## Overview
Tutorial demonstrating an intelligent chatbot leveraging OpenAI's Assistant API with File Search capabilities, featuring real-time streaming responses using React frontend and Node.js backend via Server-Sent Events.

## Code Examples

### Server-Sent Events Endpoint (JavaScript)

```javascript
app.get("/api/streamUserRequest", (req, res) => {
  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Connection': 'keep-alive',
    'Cache-Control': 'no-cache'
  });
  const newClient = { res };
  clients.push(newClient);
  req.on("close", () => {
    console.log("Client disconnected");
  });
});
```

### Chatbot API Endpoint with Streaming (JavaScript)

```javascript
app.post("/api/openai/chatbot", async (req, res) => {
  const { query } = req.body;
  const newThread = await openai.beta.threads.create();

  const message = await openai.beta.threads.messages.create(newThread.id, {
    role: "user",
    content: query,
  });

  const stream = openai.beta.threads.runs
    .createAndStream(newThread.id, {
      assistant_id: assistant_id,
    })
    .on("textCreated", (text) => {
      sendEventsToAll(streamedResponse, "textCreated")
    })
    .on("textDelta", (textDelta) => {
      streamedResponse += textDelta.value
      sendEventsToAll(streamedResponse, "textDelta")
    })
    .on("end", () => {
      clients = []
      streamedResponse = ''
    });
});
```

### Event Broadcasting Function (JavaScript)

```javascript
function sendEventsToAll(streamedResponse, textEvent) {
  const responseObject = {
    role: "assistant",
    content: streamedResponse,
    textEvent: textEvent
  };
  clients.forEach((client) => {
    client.res.write(`data: ${JSON.stringify(responseObject)}\n\n`);
  });
}
```
