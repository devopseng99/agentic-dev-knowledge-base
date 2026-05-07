---
title: "How To Use LLMs: Tool Use/Function Call with OpenAI"
url: "https://dev.to/dinakajoy/build-ai-that-does-more-using-function-calling-with-openai-i0g"
author: "Odinaka Joy"
category: "tool calling LLM"
---

# How To Use LLMs: Tool Use/Function Call with OpenAI

**Author:** Odinaka Joy
**Published:** July 22, 2025

## Overview

Explains how LLMs can extend beyond text generation to execute external tasks through function calling, enabling structured data extraction, logic triggering, and API/database interactions.

## Key Concepts

### Currency Converter Tool Definition

```javascript
const convert_currency = {
  "name": "convert_currency",
  "description": "Converts an amount from one currency to another",
  "parameters": {
    "type": "object",
    "properties": {
      "amount": { "type": "number" },
      "from": { "type": "string", "description": "Currency code, e.g., USD" },
      "to": { "type": "string", "description": "Currency code, e.g., EUR" }
    },
    "required": ["amount", "from", "to"]
  }
}
```

### Job Description Analyzer - Schema

```javascript
const jobInsightFunction = {
  name: "extract_job_insights",
  description: "Extracts skills, responsibilities, and experience from a job description.",
  parameters: {
    type: "object",
    properties: {
      skills: {
        type: "array",
        items: { type: "string" },
        description: "List of skills required for the job",
      },
      responsibilities: {
        type: "array",
        items: { type: "string" },
        description: "Job responsibilities",
      },
      experience: {
        type: "array",
        items: { type: "string" },
        description: "Qualifications or experience needed",
      },
    },
    required: ["skills", "responsibilities", "experience"],
  },
};
```

### Calling the Model with Tool

```javascript
const response = await openai.chat.completions.create({
  model: "gpt-4-0613",
  messages: [
    { role: "system", content: "You are a helpful AI job assistant." },
    {
      role: "user",
      content: `Extract the key skills, responsibilities, and required experience from the following job description:\n\n${jobDescription}`,
    },
  ],
  tools: [
    {
      type: "function",
      function: jobInsightFunction,
    },
  ],
  tool_choice: "auto",
});
```

### Parsing Results

```javascript
const toolCall = response.choices?.[0]?.message?.tool_calls?.[0];
const args = JSON.parse(toolCall?.function?.arguments ?? "{}");
// args = { skills: [...], responsibilities: [...], experience: [...] }
```
