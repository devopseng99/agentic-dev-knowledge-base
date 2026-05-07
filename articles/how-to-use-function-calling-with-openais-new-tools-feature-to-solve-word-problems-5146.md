---
title: "How to Use Function Calling with OpenAI's new Tools Feature to Solve Word Problems"
url: https://dev.to/ajones_codes/how-to-use-function-calling-with-openais-new-tools-feature-to-solve-word-problems-5146
author: Andrew Jones
category: function-calling
---

# How to Use Function Calling with OpenAI's new Tools Feature to Solve Word Problems

**Author:** Andrew Jones
**Published:** January 5, 2024

## Overview

OpenAI's Assistants API replaced the deprecated Function Calling system with a new `tools` parameter. This guide demonstrates how to leverage function calling with the Tools system by building an AI application that solves word problems.

## Goals

The tutorial creates a three-step solution:

1. Use GPT to understand word problems and generate mathematical expressions via function calls
2. Execute the expression using a JavaScript math library
3. Have the LLM generate a complete sentence answer with proper units

## Setup Instructions

Initialize your project:

```bash
mkdir word-problem-solver && cd word-problem-solver
npm init
npm i openai math-expression-evaluator
```

## Core Implementation

### Initialize Client and Libraries

```javascript
const OpenAI = require("openai");
const MathExp = require("math-expression-evaluator");
const mathExp = new MathExp();

const openai = new OpenAI({
  apiKey: "sk-...", //replace with your API key
});
```

### Define Function Schema

```javascript
const GPT_TOOLS = [
  {
    type: "function",
    function: {
      name: "calculate",
      description:
        "Use math-expression-evaluator to simplify an expression to solve the word problem",
      parameters: {
        type: "object",
        properties: {
          expression: {
            type: "string",
            description:
              "the mathematical expression to simplify to solve the word problem. DO NOT include any units.",
          },
          answerUnit: {
            type: "string",
            description:
              "unit for the answer to the word problem, if applicable",
          },
        },
        required: ["expression", "answerUnit"],
      },
    },
  },
];
```

### Main Function Flow

```javascript
const main = async () => {
  const messages = [
    {
      role: "user",
      content: "13 candy bars weigh 26 oz. How much would 35 candy bars weigh?",
    },
  ];

  const chatCompletionForFunction = await openai.chat.completions.create({
    messages,
    model: "gpt-4",
    tools: GPT_TOOLS,
    tool_choice: "auto",
    temperature: 0.25,
  });

  messages.push(chatCompletionForFunction.choices[0].message);

  const tool_call_id =
    chatCompletionForFunction.choices[0].message.tool_calls[0].id;
  const function_to_call =
    chatCompletionForFunction.choices[0].message.tool_calls[0].function.name;

  if (function_to_call === "calculate") {
    const generatedParams = JSON.parse(
      chatCompletionForFunction.choices[0].message.tool_calls[0].function
        .arguments
    );

    const expression = generatedParams.expression;
    const answerUnit = generatedParams.answerUnit;

    const lexed = mathExp.lex(expression);
    const postfixed = mathExp.toPostfix(lexed);
    const answer = mathExp.postfixEval(postfixed);

    messages.push(
      {
        role: "tool",
        tool_call_id,
        name: function_to_call.name,
        content: `${answer} ${answerUnit}`,
      },
      {
        role: "user",
        content: `Given the expression ${expression}, the answer is ${answer} ${answerUnit}. Write a complete sentence to answer the word problem.`,
      }
    );

    const chatCompletion = await openai.chat.completions.create({
      messages,
      model: "gpt-3.5-turbo-1106",
      temperature: 0.4,
    });

    messages.push(chatCompletion.choices[0].message);
    console.log(chatCompletion.choices[0].message.content);
  }
};

main();
```

## Key Differences from Legacy Function Calling

The new Tools system requires tracking the `tool_call_id`, which provides proper context for subsequent messages. Messages must include a `"tool"` role with the corresponding `tool_call_id` to maintain conversation context.

## Expected Output

Running the example produces: "35 candy bars would weigh 70 oz."

## Next Steps

- Extend with additional word problems
- Build an interactive CLI using Node's `readline` module
- Add more custom functions to the tools array
- Implement function calling in other projects
