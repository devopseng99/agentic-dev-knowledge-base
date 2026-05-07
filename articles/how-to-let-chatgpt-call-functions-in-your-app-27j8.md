---
title: "How to let ChatGPT call functions in your app"
url: "https://dev.to/encore/how-to-let-chatgpt-call-functions-in-your-app-27j8"
author: "Simon Johansson"
category: "function-calling-gpt"
---

# How to let ChatGPT call functions in your app

**Author:** Simon Johansson (for Encore)
**Published:** August 14, 2024

## Overview
This article explains OpenAI's function calling feature, enabling developers to grant ChatGPT access to external APIs. Users can interact with applications through natural language instead of complex API calls. The AI doesn't execute the functions itself -- instead the model generates parameters that can be used to call your function.

## Key Concepts

### How It Works
The model receives function descriptions and automatically decides which functions to invoke. The AI generates parameters that your code can then choose how to handle.

### Use Cases
1. Fetching data (customer orders, internal systems)
2. Taking action (scheduling meetings via calendar APIs)
3. Natural language API conversion
4. Structured data extraction pipelines

## Code Examples

### Create API Functions (TypeScript)

```typescript
import { api } from "encore.dev/api";

export interface Book {
  id: string;
  name: string;
  genre: Genre;
  description: string;
}

export enum Genre {
  mystery = "mystery",
  nonfiction = "nonfiction",
  memoir = "memoir",
  romance = "romance",
  historical = "historical",
}

const db: Book[] = [
  {
    id: "a1",
    name: "To Kill a Mockingbird",
    genre: Genre.historical,
    description: `Compassionate, dramatic, and deeply moving...`
  }
];

export const list = api(
  {expose: true, method: 'GET', path: '/book'},
  async ({genre}: { genre: string }): Promise<{ books: { name: string; id: string }[] }> => {
    const books = db.filter((item) => item.genre === genre)
      .map((item) => ({name: item.name, id: item.id}));
    return {books}
  },
);

export const get = api(
  {expose: true, method: 'GET', path: '/book/:id'},
  async ({id}: { id: string }): Promise<{ book: Book }> => {
    const book = db.find((item) => item.id === id)!;
    return {book}
  },
);

export const search = api(
  {expose: true, method: 'GET', path: '/book/search'},
  async ({name}: { name: string }): Promise<{ books: { name: string; id: string }[] }> => {
    const books = db.filter((item) => item.name.includes(name))
      .map((item) => ({name: item.name, id: item.id}));
    return {books}
  },
);
```

### Define Functions for the Model (TypeScript)

```typescript
import {api} from "encore.dev/api";
import {book} from "~encore/clients";
import OpenAI from "openai";
import {secret} from "encore.dev/config";

const apiKey = secret("OpenAIAPIKey");

const openai = new OpenAI({
  apiKey: apiKey(),
});

export const gpt = api(
  {expose: true, method: "GET", path: "/gpt"},
  async ({prompt}: { prompt: string }): Promise<{ message: string | null }> => {

    const runner = openai.beta.chat.completions
      .runTools({
        model: "gpt-3.5-turbo",
        messages: [
          {
            role: "system",
            content: "Please use our book database, which you can access using functions..."
          },
          {
            role: "user",
            content: prompt,
          },
        ],
        tools: [
          {
            type: "function",
            function: {
              name: "list",
              strict: true,
              description: "list queries books by genre, returns list of names",
              parameters: {
                type: "object",
                properties: {
                  genre: {
                    type: "string",
                    enum: [
                      "mystery",
                      "nonfiction",
                      "memoir",
                      "romance",
                      "historical",
                    ],
                  },
                },
                additionalProperties: false,
                required: ["genre"],
              },
              function: async (args: { genre: string }) => await book.list(args),
              parse: JSON.parse,
            },
          },
        ],
      })

    const result = await runner.finalChatCompletion();
    const message = result.choices[0].message.content;
    return {message};
  },
);
```

### Important Considerations
- Setting `strict: true` in function definitions ensures parameter accuracy
- Large function returns increase API costs; limit returned data or use `max_tokens`
- Avoid exceeding 20 functions per tool call to maintain accuracy
