---
title: "Build a chatbot with the new OpenAI Assistant API and Function Calling"
url: "https://dev.to/esponges/build-the-new-openai-assistant-with-function-calling-52f5"
author: "Fernando Gonzalez Tostado"
category: "ai-assistant-api"
---

# Build a chatbot with the new OpenAI Assistant API and Function Calling

**Author:** Fernando Gonzalez Tostado
**Published:** November 14, 2023

## Overview
Tutorial for building an interactive math tutor assistant using the OpenAI Assistants API with function calling. The assistant administers an initial quiz through function calling, maintains conversation state using threads, and allows ongoing dialogue while preserving context.

## Key Concepts
Unlike traditional function calling where success was not guaranteed, this implementation allows developers to specify the desired function output, and the model will strive to provide a response aligning with the provided schema.

## Code Examples

### Initial Setup (TypeScript)

```typescript
require('dotenv').config();
const OpenAI = require('openai');
const readline = require('readline').createInterface({
  input: process.stdin,
  output: process.stdout,
});

const secretKey = process.env.OPENAI_API_KEY;
const openai = new OpenAI({
  apiKey: secretKey,
});
```

### Quiz Function Schema (TypeScript)

```typescript
const quizJson = {
  name: "display_quiz",
  description: "Displays a quiz to the student, and returns the student's response.",
  parameters: {
    type: "object",
    properties: {
      title: { type: "string" },
      questions: {
        type: "array",
        description: "An array of questions, each with a title and potentially options.",
        items: {
          type: "object",
          properties: {
            question_text: { type: "string" },
            question_type: {
              type: "string",
              enum: ["MULTIPLE_CHOICE", "FREE_RESPONSE"],
            },
            choices: { type: "array", items: { type: "string" } },
          },
          required: ["question_text"],
        },
      },
    },
    required: ["title", "questions"],
  },
};
```

### Assistant Creation (TypeScript)

```typescript
const assistant = await openai.beta.assistants.create({
  name: "Math Tutor",
  instructions: "You are a personal math tutor. Answer questions briefly, in a sentence or less.",
  tools: [
    { type: "code_interpreter" },
    { type: "function", function: quizJson },
  ],
  model: "gpt-4-1106-preview",
});
```

### Run Polling and Function Handling (TypeScript)

```typescript
while (
  actualRun.status === "queued" ||
  actualRun.status === "in_progress" ||
  actualRun.status === "requires_action"
) {
  if (actualRun.status === "requires_action") {
    const toolCall = actualRun.required_action?.submit_tool_outputs?.tool_calls[0];
    const name = toolCall?.function.name;
    const args = JSON.parse(toolCall?.function.arguments || "{}");
    const questions = args.questions;

    const responses = await displayQuiz(name || "cool quiz", questions);

    await openai.beta.threads.runs.submitToolOutputs(
      thread.id,
      run.id,
      {
        tool_outputs: [
          {
            tool_call_id: toolCall?.id,
            output: JSON.stringify(responses),
          },
        ],
      },
    );
  }
  await new Promise((resolve) => setTimeout(resolve, 2000));
  actualRun = await openai.beta.threads.runs.retrieve(thread.id, run.id);
}
```
