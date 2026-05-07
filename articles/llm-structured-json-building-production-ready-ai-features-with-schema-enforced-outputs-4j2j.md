---
title: "Stop Parsing LLMs with Regex: Build Production-Ready AI Features with Schema-Enforced Outputs"
url: "https://dev.to/dthompsondev/llm-structured-json-building-production-ready-ai-features-with-schema-enforced-outputs-4j2j"
author: "Danny Thompson"
category: "structured-output"
---

# Stop Parsing LLMs with Regex: Build Production-Ready AI Features with Schema-Enforced Outputs

**Author:** Danny Thompson
**Published:** October 16, 2025
**Tags:** #ai #webdev #programming #api

---

## Overview

The article argues against using regex to parse LLM outputs in production systems, advocating instead for schema-enforced JSON outputs validated at runtime with Zod.

## Key Problem Statement

When LLMs update their response format slightly, regex-based parsers fail catastrophically. Example: "billing issue" becomes "payment problem" and routing breaks. The root cause isn't the model -- it's relying on unstructured text parsing.

## Core Solution

Use JSON Schema enforcement at generation time combined with Zod validation at runtime. Modern LLM APIs (OpenAI, Azure) support structured outputs that constrain model responses to match your schema.

**Key distinction:** JSON Mode guarantees valid JSON syntax; Structured Outputs enforces your specific schema including required properties and enums.

---

## Four Compounding Benefits

1. **Zero parsing logic** -- API constrains output to your schema
2. **End-to-end type safety** -- Define once with Zod, validate at runtime
3. **Operational reliability** -- Schema adherence reduces retries and format drift
4. **Maintainable codebase** -- Predictable response structure enables stable dashboards and alerts

---

## Implementation Pattern

### Step 1: Define Schema with Zod

```typescript
import { z } from "zod";
import { zodToJsonSchema } from "zod-to-json-schema";

export const SupportTicketSchema = z.object({
  schemaVersion: z.literal("v1")
    .describe("Schema version for analytics and migrations"),
  language: z.string()
    .describe("BCP-47 language code of the input, for example en-US"),
  sentiment: z.enum(["positive", "neutral", "negative"])
    .describe("Overall sentiment of the customer's message"),
  department: z.enum([
    "customer_support",
    "online_ordering",
    "product_quality",
    "shipping_and_delivery",
    "other_off_topic"
  ]).describe("Primary routing category for this ticket"),
  priority: z.enum(["low", "medium", "high"])
    .describe("Urgency level based on content and tone"),
  confidence: z.number().min(0).max(1)
    .describe("Model confidence in this classification from 0 to 1"),
  suggestedReply: z.string().min(1).max(500).describe(
    "Friendly, professional tone. 60 to 120 words. Acknowledge the issue. " +
    "Give the next step and a contact. No emojis. No internal policy text. " +
    "Write in the same language as the user."
  )
});

export type SupportTicket = z.infer<typeof SupportTicketSchema>;
export const SupportJSONSchema = zodToJsonSchema(SupportTicketSchema);
```

### Step 2: Configure LLM Call

```typescript
import OpenAI from "openai";

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

export async function classifyMessage(message: string): Promise<SupportTicket> {
  const completion = await openai.chat.completions.create({
    model: "gpt-4o-2024-08-06",
    messages: [
      {
        role: "system",
        content: "Classify customer support messages and suggest appropriate replies. Return structured JSON only."
      },
      { role: "user", content: message }
    ],
    response_format: {
      type: "json_schema",
      json_schema: {
        name: "support_ticket_classification",
        schema: SupportJSONSchema
      }
    }
  });

  const content = completion.choices[0]?.message?.content ?? "";
  let parsed: unknown;
  try {
    parsed = JSON.parse(content);
  } catch (err) {
    throw new Error("Model returned non JSON. Verify response_format and schema.", { cause: err });
  }
  return SupportTicketSchema.parse(parsed);
}
```

### Step 3: Use Typed Data

```typescript
const result = await classifyMessage("Order #8841 is two weeks late!");

console.log(result.sentiment);        // "negative"
console.log(result.department);       // "shipping_and_delivery"
console.log(result.priority);         // "high"
console.log(result.confidence);       // 0.94
console.log(result.suggestedReply);   // Ready to use

if (result.confidence >= 0.8) {
  await sendAutomatedReply(result.suggestedReply);
} else {
  await flagForHumanReview(result);
}
```

---

## Resilience Pattern

```typescript
async function withRetry<T>(op: () => Promise<T>, tries = 3, baseMs = 300): Promise<T> {
  let last: unknown;
  for (let i = 1; i <= tries; i++) {
    try { return await op(); }
    catch (e) {
      last = e;
      if (i < tries) await new Promise(r => setTimeout(r, baseMs * i));
    }
  }
  throw last;
}

const safeResult = await withRetry(() => classifyMessage(msg));
```

---

## GraphQL Integration

```graphql
type Mutation {
  enrichLead(rawInquiry: String!): EnrichedLead!
}

type EnrichedLead {
  companyName: String!
  inquiryType: InquiryType!
  urgency: Urgency!
  potentialValue: DealSize!
}
```

```typescript
const resolvers = {
  Mutation: {
    enrichLead: async (_: unknown, { rawInquiry }: { rawInquiry: string }) => {
      const structured = await llmService.enrichWithSchema(rawInquiry);
      return {
        companyName: structured.companyName,
        inquiryType: structured.inquiryType,
        urgency: structured.urgency,
        potentialValue: structured.potentialValue
      };
    }
  }
};
```

---

## Framework Considerations

For managing multiple LLM integrations, **BAML (Boundary AI Markup Language)** provides a dedicated abstraction layer. `.baml` files define LLM functions separately from application code, enabling provider-agnostic swaps (OpenAI to Anthropic) and structured collaboration between engineers and prompt designers.

**LangChain alternative:** Use `.withStructuredOutput()` to abstract provider specifics while maintaining streaming support.

---

## Streaming Guidance

Accumulate the entire stream in a buffer before parsing. Never parse partial JSON.

---

## Real-World Applications

- **Customer support triage:** Route high-confidence results automatically; queue remainder for human review
- **Lead enrichment:** Transform free text into CRM-ready fields
- **Document processing:** Convert OCR output to database records

---

## Production Best Practices

- Constrain routing/classification fields with enums; avoid free text
- Add short, specific `.describe()` annotations -- providers use these for generation guidance
- Keep schemas relatively flat; deep nesting reduces adherence
- Always validate with Zod at runtime, even when API enforces schema
- Include confidence scores to gate automation
- Version schemas intentionally with `schemaVersion` field
- For streaming, accumulate then parse -- never partial JSON
- Consider framework abstraction for provider independence

---

## Security Notes

- Delimit user input with triple quotes to reduce prompt injection risk
- Repeat key guard rails after dynamic text
- Add `containsPii: boolean` field and redact before logging
- Use confidence thresholds; automate only above threshold

---

## Micro-Benchmark Template

Test schema enforcement effectiveness:

- **Task:** Classify 100 real tickets into schema
- **Metrics:** Schema validity rate (Zod), latency, tokens, manual accuracy spot-check
- **Settings:** Temperature 0, identical prompt and schema
- **Goal:** Demonstrate higher valid rate and fewer retries versus prose parsing

---

## Complete Working Example

```typescript
// npm install zod zod-to-json-schema openai

import { z } from "zod";
import { zodToJsonSchema } from "zod-to-json-schema";
import OpenAI from "openai";

const ProductReviewSchema = z.object({
  rating: z.number().min(1).max(5)
    .describe("Star rating from 1 to 5"),
  pros: z.array(z.string())
    .describe("List of positive aspects mentioned"),
  cons: z.array(z.string())
    .describe("List of negative aspects mentioned"),
  wouldRecommend: z.boolean()
    .describe("Whether the reviewer would recommend this product"),
  summary: z.string().max(200)
    .describe("Brief summary suitable for display in UI")
});

type ProductReview = z.infer<typeof ProductReviewSchema>;
const ReviewJSONSchema = zodToJsonSchema(ProductReviewSchema);

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

async function analyzeReview(reviewText: string): Promise<ProductReview> {
  const completion = await openai.chat.completions.create({
    model: "gpt-4o-2024-08-06",
    messages: [
      {
        role: "system",
        content: "Extract structured insights from product reviews. Return JSON only."
      },
      { role: "user", content: reviewText }
    ],
    response_format: {
      type: "json_schema",
      json_schema: {
        name: "product_review_analysis",
        schema: ReviewJSONSchema,
        strict: true
      }
    }
  });

  const content = completion.choices[0]?.message?.content ?? "";
  let data: unknown;
  try {
    data = JSON.parse(content);
  } catch (err) {
    throw new Error("Model returned non JSON. Verify response_format and schema.", { cause: err });
  }
  return ProductReviewSchema.parse(data);
}

const result = await analyzeReview(
  "Battery life is incredible, easily lasts two days. The screen is crisp and bright. " +
  "The camera sometimes hunts for focus in low light. Overall, very happy. 4/5 stars."
);

console.log(result);
// {
//   rating: 4,
//   pros: ["Long battery life", "High-quality display"],
//   cons: ["Camera autofocus issues in low light"],
//   wouldRecommend: true,
//   summary: "Excellent battery and screen, minor camera issues"
// }
```

---

## Key Takeaway

Schema enforcement transforms LLM integration from fragile text parsing into reliable, typed data processing. Start with your most brittle endpoint, measure error rates over two weeks, and let metrics guide broader rollout.

---

## References

- [OpenAI Structured Outputs](https://platform.openai.com/docs/guides/structured-outputs)
- [Microsoft Learn: Azure Structured Outputs](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/structured-outputs)
- [Zod Documentation](https://zod.dev/)
- [LangChain JS Structured Outputs](https://js.langchain.com/docs/concepts/structured_outputs/)
