---
title: "Everything about AI Function Calling and MCP, the keyword for Agentic AI"
url: "https://dev.to/samchon/everything-about-ai-function-calling-mcp-the-keyword-for-agentic-ai-2id7"
author: "Jeongho Nam"
category: "function-calling-gpt"
---

# Everything about AI Function Calling and MCP, the keyword for Agentic AI

**Author:** Jeongho Nam
**Published:** April 18, 2025

## Overview
The author argues that AI function calling remains underutilized due to insufficient understanding of JSON schema specifications and inadequate compiler-level support. Function schemas must be generated programmatically rather than manually. The LOC for AI function schema is 5.62 times larger than the source code in a shopping mall backend.

## Key Concepts
- Different AI vendors (OpenAI, Google Gemini, Claude) implement incompatible JSON schema specifications
- Function schemas must be generated programmatically rather than manually
- OpenAPI's 15-year ecosystem remains underexploited for function calling
- Never write AI function schemas manually -- use compiler-driven generators

## Code Examples

### Converting OpenAPI to Function Schemas (TypeScript)

```typescript
import { HttpLlm, IHttpLlmApplication } from "@samchon/openapi";

const app: IHttpLlmApplication<"chatgpt"> = HttpLlm.application({
  model: "chatgpt",
  document: await fetch(
    "https://shopping-be.wrtn.ai/editor/swagger.json"
  ).then((r) => r.json()),
});
console.log(app);
```

### Agentica Agent Setup (TypeScript)

```typescript
import { Agentica, assertHttpLlmApplication } from "@agentica/core";
import OpenAI from "openai";

const agent = new Agentica({
  model: "chatgpt",
  vendor: {
    model: "gpt-4o-mini",
    api: new OpenAI({ apiKey: "********" }),
  },
  controllers: [
    {
      protocol: "http",
      name: "shopping",
      application: assertHttpLlmApplication({
        model: "chatgpt",
        document: await fetch(
          "https://shopping-be.wrtn.ai/editor/swagger.json"
        ).then((res) => res.json()),
      }),
      connection: {
        host: "https://shopping-be.wrtn.ai",
        headers: {
          Authorization: "Bearer ********",
        },
      },
    },
  ],
});

await agent.convert("I wanna buy a Macbook.");
```

### Compiler-Level Schema Generation (TypeScript)

```typescript
import { ILlmApplication } from "@samchon/openapi";
import typia, { tags } from "typia";

const app: ILlmApplication<"chatgpt"> =
  typia.llm.application<BbsArticleService, "chatgpt">();
console.log(app);

class BbsArticleService {
  /**
   * Update an article.
   */
  update(props: {
    /**
     * Target article's {@link IBbsArticle.id}.
     */
    id: string & tags.Format<"uuid">;
    /**
     * New content to update.
     */
    input: IBbsArticle.IUpdate;
  }): void;
}
```

### JSON Schema with Constraint Properties

```typescript
{
  name: "divide",
  arguments: {
    x: {
      type: "number",
    },
    y: {
      anyOf: [
        {
          type: "number",
          exclusiveMaximum: 0,
        },
        {
          type: "number",
          exclusiveMinimum: 0,
        },
      ],
    },
  },
  description: "Calculate x / y",
}
```
