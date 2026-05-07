---
title: "Create AI Agents and Tools Using GPT in NodeJS"
url: https://dev.to/etherlegend/create-ai-agents-and-tools-using-gpt-in-nodejs-4jfe
author: Anoop
category: ai-agents-nodejs
---

# Create AI Agents and Tools Using GPT in NodeJS

**Author:** Anoop
**Published:** June 21, 2023
**Updated:** June 22, 2023
**Tags:** #javascript #openai #webdev #typescript

---

## Overview

The article explains how to build autonomous AI agents using the `openai-agent` npm package. These agents can be equipped with various tools to accomplish predetermined goals, similar to giving a person tools to complete a task.

## Key Concepts

**What are AI agents?** The author describes them as "code or mechanisms which act to achieve predetermined goals." Users provide tools to agents, which then intelligently select and execute them to complete tasks.

The framework abstracts away complexity from OpenAI's Functions API, allowing developers to convert regular Node.js functions into agent tools.

## Setup Requirements

### Prerequisites
- Node.js and npm installed
- TypeScript compiler (recommended)
- OpenAI API key from https://openai.com
- SerpAPI key (optional, for internet searches)

### Configuration
Add to `tsconfig.json`:
```typescript
"experimentalDecorators": true,
"emitDecoratorMetadata": true,
"declaration": true
```

Create `.env` file:
```
OPENAI_API_KEY=your_openai_api_key
OPENAI_MODEL=gpt-3.5-turbo-0613
SERPAPI_API_KEY=your_serp_key
```

## Installation

```bash
npm install -g typescript
npm install openai-agent
```

## Core Implementation

### Creating an Agent

```typescript
import { OpenAIAgent } from 'openai-agent';

const myAgent = new OpenAIAgent(myApiKey, myModel);
```

If using `.env` file, no parameters are required.

### Creating Custom Functions

```typescript
import { OpenAIFunction } from 'openai-agent';

class MyFunctions {
  @OpenAIFunction(
    "Searches the internet using SerpApi to get search results",
    {
      query: {
        type: "string",
        description: "The search query",
        required: true,
      },
    }
  )
  async searchInternet(query: string): Promise<string> {
    // Implementation here
  }
}
```

### Basic Usage Example

```typescript
import { OpenAIAgent } from 'openai-agent';

const myAgent = new OpenAIAgent(myApiKey, myModel);

const result = await myAgent.runAgent(
  "search the internet for 'best AI tools'",
  [new MyFunctions()]
);

console.log(result.content);
```

## Advanced Examples

### Terminal-Based Agent

```typescript
const agent1 = new OpenAIAgent(
  process.env.OPENAI_API_KEY,
  process.env.OPENAI_MODEL
);

const osInfoResponse = await agent1.runAgent(
  [{ role: "user", content: "get my os info and write a poem about it" }],
  [new TerminalFunctions()],
  5
);

console.log(osInfoResponse?.content);
```

### Web Search Agent

```typescript
const agent2 = new OpenAIAgent(
  process.env.OPENAI_API_KEY,
  process.env.OPENAI_MODEL
);

const internetSearchResponse = await agent2.runAgent(
  [{
    role: "user",
    content: 'search internet for latest news on OpenAI functions and get me the titles & links to top 5 articles'
  }],
  [new InternetFunctions()],
  10
);

console.log(internetSearchResponse?.content);
```

### Interactive Terminal Agent

```typescript
const agent3 = new OpenAIAgent(
  process.env.OPENAI_API_KEY,
  process.env.OPENAI_MODEL
);

const taskResponse = await agent3.runAgent(
  [{
    role: "user",
    content: 'you are an expert ai assistant. Ask the user to give you inputs and do what she/he asks for, and do this in a loop, till he types exit'
  }],
  [new TerminalFunctions()],
  10
);

console.log(taskResponse?.content);
```

## Key Takeaways

1. **Simplification**: The framework abstracts away OpenAI Functions API complexity, making agent development more accessible.

2. **Function Decoration**: Use the `@OpenAIFunction` decorator to convert regular methods into agent-callable tools with specific parameters.

3. **Built-in Tools**: The framework provides `TerminalFunctions` and `InternetFunctions` for common use cases.

4. **Flexible Architecture**: Agents can perform various tasks -- from internet research to system commands -- based on their equipped tools.

5. **Warning**: Using terminal tools grants agents significant system access; the author recommends using Docker containers for safety.

## Resources

- **NPM Package:** [openai-agent](https://www.npmjs.com/package/openai-agent)
- **GitHub Repository:** https://github.com/etherlegend/openai-agent
- **OpenAI Functions Documentation:** https://openai.com/blog/function-calling-and-other-api-updates
- **Author Twitter:** @etherlegend
