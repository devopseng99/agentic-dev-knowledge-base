---
title: "Mistral Basic AI Agent Using NextJS with TypeScript"
url: "https://dev.to/arfatapp/mistral-basic-ai-agent-using-nextjs-with-typescript-2315"
author: "Arfatur Rahman"
category: "mistral-ai-agent"
---

# Mistral Basic AI Agent Using NextJS with TypeScript

**Author:** Arfatur Rahman
**Published:** March 14, 2025

## Overview
Step-by-step tutorial on using Mistral AI's `mistral-large-latest` model to build a custom agent that tracks and responds to payment statuses and transaction dates using Next.js and TypeScript with function calling (tool use).

## Key Concepts

### Setup

```bash
npx create-next-app@latest arfat
cd arfat
npm i @mistralai/mistralai zod
```

### Mistral Free Tier Limitations
- 1 request per second
- 500,000 tokens per minute
- 1 billion tokens per month

### Schema and Input Validation

```typescript
const inputSchema = z.object({
  inputText: z
    .string({
      invalid_type_error: "Input text must be a string",
      required_error: "Input text is required",
    })
    .min(1, { message: "Input text cannot be empty" }),
});
```

### Defining Mistral Messages

```typescript
export interface MistralMessage {
  role: "system" | "user" | "assistant" | "tool";
  content: string;
  name?: string;
  toolCallId?: string;
}
```

### Setting Up the Mistral Client

```typescript
import { Mistral } from "@mistralai/mistralai";

const apiKey = process.env.MISTRAL_API_KEY;
export const mistralClient = new Mistral({ apiKey: apiKey });
```

### Helper Functions for Payment Data

```typescript
const transactionData = [
  {
    transaction_id: "T1001",
    customer_id: "C001",
    payment_amount: 125.5,
    payment_date: "2021-10-05",
    payment_status: "Paid",
  },
];

export function getPaymentStatus({ transactionId }: { transactionId: string }) {
  const transaction = transactionData.find(
    (row) => row.transaction_id === transactionId
  );
  if (transaction) return JSON.stringify({ status: transaction.payment_status });
  return JSON.stringify({ error: "Transaction ID not found." });
}

export function getPaymentDate({ transactionId }: { transactionId: string }) {
  const transaction = transactionData.find(
    (row) => row.transaction_id === transactionId
  );
  if (transaction) return JSON.stringify({ date: transaction.payment_date });
  return JSON.stringify({ error: "Transaction ID not found." });
}
```

### Mistral Tools Definition

```typescript
import { Tool } from "@mistralai/mistralai/models/components";

const mistralTools: Tool[] = [
  {
    type: "function",
    function: {
      name: "getPaymentStatus",
      description: "Get the payment status of a transaction",
      parameters: {
        type: "object",
        properties: {
          transactionId: {
            type: "string",
            description: "The transaction ID.",
          },
        },
        required: ["transactionId"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "getPaymentDate",
      description: "Get the payment date of a transaction",
      parameters: {
        type: "object",
        properties: {
          transactionId: {
            type: "string",
            description: "The transaction ID.",
          },
        },
        required: ["transactionId"],
      },
    },
  },
];
```

### Main POST Handler with Tool Calling Loop

```typescript
export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { inputText } = inputSchema.parse(body);

    const messages: MistralMessage[] = [
      { role: "system", content: "You are a friendly assistant" },
      { role: "user", content: inputText },
    ];

    const response = await mistralClient.chat.complete({
      model: "mistral-large-latest",
      messages,
      toolChoice: "any",
      tools: mistralTools,
      temperature: 0.7,
      responseFormat: { type: "text" },
    });

    if (response?.choices && response.choices[0]?.message?.role === "assistant") {
      if (response?.choices[0].finishReason === "stop") {
        return formatResponse(
          { finalAnswer: response?.choices[0].message.content, ...response },
          "Data fetched successfully"
        );
      }

      if (response?.choices[0]?.finishReason === "tool_calls") {
        const toolCalls = response.choices[0]?.message?.toolCalls;
        if (toolCalls && toolCalls.length > 0) {
          const functionName = toolCalls[0]?.function?.name as keyof typeof availableFunctions;
          const functionArgs = JSON.parse(toolCalls[0]?.function?.arguments as string);

          const functionResponse = availableFunctions[functionName](functionArgs);

          messages.push({
            role: "tool",
            name: functionName,
            content: functionResponse,
            toolCallId: toolCalls[0].id,
          });

          await delay(3000);

          const functionREs = await mistralClient.chat.complete({
            model: "mistral-large-latest",
            messages,
          });

          return formatResponse(functionREs, "Data fetched successfully");
        }
      }
    }
  } catch (error) {
    console.log("Error", { error });
    return routeErrorHandler(error);
  }
}
```
