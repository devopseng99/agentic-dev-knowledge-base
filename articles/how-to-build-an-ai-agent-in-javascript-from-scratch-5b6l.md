---
title: "How to Build an AI Agent in Javascript from Scratch"
url: https://dev.to/anandrmedia/how-to-build-an-ai-agent-in-javascript-from-scratch-5b6l
author: Anand Sukumaran
category: ai-agent-javascript
---

# How to Build an AI Agent in Javascript from Scratch

**Author:** Anand Sukumaran
**Published:** January 20, 2025
**Tags:** #javascript #llm #agents #ai

## Overview

This tutorial demonstrates building an appointment scheduler AI agent from scratch in JavaScript without using agentic AI frameworks, allowing developers to understand agent mechanics without abstractions.

## Architecture

An AI agent combines three components:

1. **LLM** - The decision-making component (like a brain)
2. **External Tools** - Functions the agent can execute
3. **Coordinator** - A system process managing LLM-tool interactions

The Node.js program acts as the controller, interfacing the LLM with tools and users.

## Prerequisites

- JavaScript and TypeScript knowledge
- OpenAI API Key
- Readline library for command-line input

## Implementation Steps

### 1. Initialize Dependencies

```javascript
import OpenAI from "openai";
import readline from "readline";

const client = new OpenAI({
    apiKey: ""
});

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});
```

### 2. Create Messages Array

```javascript
const messages = [] as any;
```

Maintains conversation history for LLM context.

### 3. Define System Prompt

The prompt instructs the LLM to:
- Respond in JSON format with `to`, `message`, and `function_call` fields
- Specify target (user or system)
- Declare available functions with parameters

Available functions include:
- `check_appointment_availability` (datetime)
- `schedule_appointment` (datetime, name, email)
- `delete_appointment` (datetime, name, email)

### 4. Implement Core Functions

**send_to_llm()** - Sends user input to OpenAI, receives response:

```javascript
async function send_to_llm(content: string){
    messages.push({
        role: 'user',
        content
    });

    const response = await client.chat.completions.create({
        messages,
        model: 'gpt-4o'
    });

    messages.push(response.choices[0].message);
    return response.choices[0].message.content;
}
```

**process_llm_response()** - Parses responses and either displays messages to users or executes function calls:

```javascript
async function process_llm_response(response: any){
    const parsedJson = JSON.parse(response);

    if(parsedJson.to == 'user'){
        console.log(parsedJson.message);
    } else if(parsedJson.to == 'system'){
        const fn = parsedJson.function_call.function;
        const args = parsedJson.function_call.arguments;
        const functionResponse = function_map[fn](...args);

        await process_llm_response(
            await send_to_llm('response is ' +
                (functionResponse ? 'true' : 'false'))
        );
    }
}
```

### 5. Main Loop

```javascript
async function main(){
    while(true){
        const input = await new Promise((resolve)=>{
            rl.question("Say something: ", resolve);
        });

        const response = await send_to_llm(input);
        await process_llm_response(response);
    }
}

main();
```

## Key Concepts

- **JSON Responses** - LLM returns structured data indicating whether to message users or call functions
- **Recursive Processing** - Function responses feed back into the LLM for continued processing
- **Conversation Context** - All messages stored for maintaining dialogue history
- **Dynamic Function Calling** - Function map enables string-based function invocation

## Takeaway

"Building an agent is not rocket science. It's just instructing the LLM to coordinate with a system program...to execute function or API calls and return responses accordingly!"

The tutorial emphasizes that agent architecture fundamentally relies on prompt engineering, structured responses, and iterative LLM-system communication loops.
