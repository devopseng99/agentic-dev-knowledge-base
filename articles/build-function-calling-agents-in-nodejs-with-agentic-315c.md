---
title: "Build Function-Calling Agents in Node.js with Agentic"
url: https://dev.to/obaydmerz/build-function-calling-agents-in-nodejs-with-agentic-315c
author: Abderrahmene Merzoug
category: ai-agents-nodejs
---

# Build Function-Calling Agents in Node.js with Agentic

**Author:** Abderrahmene Merzoug
**Published:** April 11, 2025 (Updated April 13, 2025)
**Tags:** #ai #llm #node #agents

---

## Overview

This article introduces `@obayd/agentic`, a lightweight Node.js framework for building LLM agents with function-calling capabilities. The library streamlines the complex interaction layer between applications and Large Language Models.

## Key Challenges Addressed

Traditional LLM integration requires manual handling of:
- Tool definition and documentation
- Prompt formatting with tool specifications
- Parsing LLM tool-call requests
- Parameter extraction and validation
- Function execution with error handling
- Result formatting for the LLM
- Conversation history management
- Streaming response handling

## Core Features

**Framework Highlights:**
- "Fluent Tool Definition" using a chainable API
- **Toolpacks** for grouping related tools
- Built for streaming responses via async generators
- LLM-agnostic integration through simple callbacks
- Automatic conversation and message history management
- TypeScript support with zero external dependencies
- Pure JavaScript implementation

## Quick Start Implementation

### 1. Installation
```bash
npm install @obayd/agentic
```

### 2. LLM Connection (Callback Function)
```javascript
import { Conversation, Tool, fetchResponseToStream } from '@obayd/agentic';

async function* llmCallback(messages, options) {
    const YOUR_LLM_API_ENDPOINT = "YOUR_LLM_API_ENDPOINT";
    const YOUR_API_KEY = "YOUR_API_KEY";
    const YOUR_MODEL_NAME = "YOUR_MODEL_NAME";

    try {
        const response = await fetch(YOUR_LLM_API_ENDPOINT, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${YOUR_API_KEY}`,
            },
            body: JSON.stringify({
                model: YOUR_MODEL_NAME,
                messages: messages,
                stream: true,
            }),
        });

        yield* fetchResponseToStream(response);
    } catch (error) {
        console.error("LLM Callback Error:", error);
        yield `[Error connecting to LLM: ${error.message}]`;
    }
}
```

### 3. Define Tools
```javascript
const getCurrentWeather = Tool.make("get_current_weather")
    .description("Gets the current weather for a specified location.")
    .param("location", "The city and state, e.g., San Francisco, CA", { required: true })
    .param("unit", "Temperature unit", { enum: ["celsius", "fahrenheit"] })
    .action(async (params) => {
        console.log(`[TOOL ACTION] Getting weather for: ${params.location}`);
        await new Promise(resolve => setTimeout(resolve, 75));
        const location = params.location.toLowerCase();
        const unit = params.unit || "celsius";
        let temp = location.includes("tokyo") ? 15 : 12;
        if (unit === "fahrenheit") temp = (temp * 9/5) + 32;

        return JSON.stringify({ temperature: temp, unit: unit, condition: "Cloudy" });
    });
```

### 4. Setup Conversation
```javascript
const conversation = new Conversation(llmCallback);

conversation.content([
    "You are a helpful weather assistant.",
    "Use the available tools to answer user questions.",
    getCurrentWeather,
]);
```

### 5. Run the Agent Loop
```javascript
async function runAgent(userInput) {
    console.log(`\nUSER: ${userInput}`);
    console.log("\nASSISTANT:");

    let fullResponse = "";
    try {
        const stream = conversation.send(userInput);

        for await (const event of stream) {
            switch (event.type) {
                case 'assistant':
                    process.stdout.write(event.content);
                    fullResponse += event.content;
                    break;
                case 'tool.calling':
                    process.stdout.write(`\n[Calling Tool: ${event.name}(${JSON.stringify(event.params)})]`);
                    break;
                case 'tool':
                    console.log(`\n[Tool Result (${event.name})]: ${JSON.stringify(event.result)}`);
                    console.log("\nASSISTANT (Processing result...):");
                    break;
                case 'error':
                    console.error(`\n[CONVERSATION ERROR]: ${event.content}`);
                    break;
            }
        }
        console.log('\n--- Turn End ---');
        return fullResponse;

    } catch (error) {
        console.error("\n[Critical Agent Error]:", error);
    }
}

runAgent("What's the weather in Tokyo like today?");
```

## Example Output

```
USER: What's the weather in Tokyo like today?

ASSISTANT:
[Calling Tool: get_current_weather({"location":"Tokyo"})]

ASSISTANT (Processing result...):
The current weather in Tokyo is 15C and Cloudy.
--- Turn End ---
```

## Additional Capabilities

Beyond the basics, the framework supports:
- **Toolpacks** for grouping and enabling tool sets dynamically
- **Raw Tool Input** for free-form text parameters
- **Dynamic Content** for runtime system prompt modifications
- **Argument Passing** to tool actions via `conversation.send()`

## Why Use This Framework?

- **Simplicity:** Focuses on core agent functionality without unnecessary abstraction
- **Flexibility:** Integrates with any LLM supporting streaming responses
- **Streaming-Native:** Designed for responsive user experiences
- **Intuitive Tool Definition:** Fluent API for clean tool specifications
- **Lightweight:** No heavy external dependencies

## Resources

- **GitHub:** github.com/obaydmerz/agentic
- **Documentation:** https://agentic.gitbook.io/agentic
- **NPM Package:** `@obayd/agentic`

---

**Key Takeaway:** This framework abstracts away boilerplate code for LLM function-calling, allowing developers to focus on defining tools and agent logic rather than managing the interaction flow.
