---
title: "Build AI Agent Connected to Unlimited APIs with Vercel's AI SDK & Pica's OneTool"
url: "https://dev.to/moekatib/build-ai-agent-connected-to-unlimited-apis-with-vercels-ai-sdk-picas-onetool-1mpi"
author: "Moe Katib"
category: "agent-sdks"
---

# Build AI Agent Connected to Unlimited APIs with Vercel's AI SDK & Pica's OneTool
**Author:** Moe Katib
**Published:** January 22, 2025

## Overview
Tutorial on building an AI agent that interfaces with multiple APIs using Express, Vercel's AI SDK, and Pica's infrastructure for automating workflows and handling complex queries.

## Key Concepts

### Prerequisites and Setup
```bash
npm install express @ai-sdk/openai ai @picahq/ai dotenv
```

Environment variables:
```
PICA_SECRET_KEY=your-pica-secret-key
OPENAI_API_KEY=your-openai-api-key
PORT=3000
```

### Server Implementation (server.js)
```javascript
import express from "express";
import { openai } from "@ai-sdk/openai";
import { generateText } from "ai";
import { Pica } from "@picahq/ai";
import * as dotenv from "dotenv";

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.post("/api/ai", async (req, res) => {
  try {
    const { message } = req.body;
    const pica = new Pica(process.env.PICA_SECRET_KEY);
    const systemPrompt = await pica.generateSystemPrompt();

    const { text } = await generateText({
      model: openai("gpt-4o"),
      system: systemPrompt,
      tools: { ...pica.oneTool },
      prompt: message,
      maxSteps: 5,
    });

    res.setHeader("Content-Type", "application/json");
    res.status(200).json({ text });
  } catch (error) {
    console.error("Error processing AI request:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

export default app;
```

### Testing
```bash
curl --location 'http://localhost:3000/api/ai' \
--header 'Content-Type: application/json' \
--data '{
    "message": "What connections do I have access to?"
}'
```
