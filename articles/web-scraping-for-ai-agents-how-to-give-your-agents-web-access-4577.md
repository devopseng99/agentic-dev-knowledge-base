---
title: "Web Scraping for AI Agents: How to Give Your Agents Web Access"
url: "https://dev.to/asaoluelijah/web-scraping-for-ai-agents-how-to-give-your-agents-web-access-4577"
author: "Asaolu Elijah"
category: "web-scraping"
---

# Web Scraping for AI Agents: How to Give Your Agents Web Access

**Author:** Asaolu Elijah
**Published:** April 13, 2026

---

## Overview

This comprehensive guide addresses a fundamental challenge in AI agent development: large language models have knowledge cutoff dates, making them unable to access current information. Web scraping bridges this gap by enabling agents to fetch live data and make informed decisions based on real-time information.

## Why Agents Need Live Web Access

Modern LLMs are "trained once and frozen," creating problems for time-sensitive agent tasks:

- **Research agents** cannot access current competitor pricing
- **Lead generation agents** miss recently launched companies
- **News monitoring agents** cannot track breaking updates
- **Price tracking agents** cannot monitor real-time changes

The solution involves equipping agents with tools that fetch HTML, parse it intelligently, and return structured data.

## How Scraping Fits into Agent Workflows

Scraping integrates seamlessly into an agent's tool-use loop, similar to database queries or API calls:

```
Agent needs: "What's the current price of product X?"
-> calls scrapeUrl(url, prompt)
-> gets back: { "name": "Product X", "price": 49.99, "currency": "USD" }
-> continues: "The price is $49.99, which is $5 lower than last week..."
```

## Three Core Approaches

### Raw HTTP + HTML Parsing

Using libraries like Cheerio to fetch URLs and parse with CSS selectors represents the simplest approach but faces critical limitations:

> "Most modern websites don't return meaningful HTML on the first HTTP request...The above returns a shell. The content loads after JS executes."

This method also provides no protection against rate limiting or blocking.

### Headless Browsers

Tools like Playwright and Puppeteer launch actual browsers, wait for JavaScript execution, then extract content. Benefits include JavaScript rendering support, but drawbacks are significant:

> "This is expensive to run at scale. Infrastructure, browser pools, proxy management, and CAPTCHA handling all become your problem."

### Scraping APIs

Purpose-built APIs handle browser automation, proxy rotation, CAPTCHA solving, and data extraction in unified endpoints -- the recommended approach for agent implementations.

## Production Challenges

Real-world obstacles that matter for agents include:

- **Anti-bot detection:** IP rate limiting, CAPTCHAs, browser fingerprinting
- **JavaScript-rendered content:** Most modern sites require execution before content appears
- **Unstructured output:** Raw HTML or text requires parsing; agents prefer structured JSON
- **Async workflows:** Scraping takes seconds, requiring job submission and polling patterns
- **Scale:** Processing multiple leads simultaneously demands batch support

## Agent-Ready Scraping Requirements

The ideal scraping tool for agents should provide:

1. **Natural language prompts** instead of CSS selectors
2. **Structured JSON output** matching defined schemas
3. **Async with polling** for non-blocking operation
4. **Built-in proxy and anti-bot handling**
5. **Batch processing support**

## Practical Implementation Examples

### Basic Setup

API credentials are obtained from `app.spidra.io` -> Settings -> API Keys.

**Base URL:** `https://api.spidra.io/api`
**Authentication:** `x-api-key` header

### Example 1: Simple Scrape Tool

```javascript
const API_KEY = "your-api-key";
const BASE_URL = "https://api.spidra.io/api";
const HEADERS = {
  "x-api-key": API_KEY,
  "Content-Type": "application/json"
};

async function scrape(url, prompt, schema, options = {}) {
  const payload = {
    urls: [{ url }],
    prompt,
    output: "json",
    useProxy: true,
    ...(schema && { schema }),
    ...options,
  };

  const res = await fetch(`${BASE_URL}/scrape`, {
    method: "POST",
    headers: HEADERS,
    body: JSON.stringify(payload),
  });
  const { jobId } = await res.json();

  while (true) {
    const status = await fetch(`${BASE_URL}/scrape/${jobId}`, {
      headers: HEADERS,
    }).then((r) => r.json());

    if (status.status === "completed") return status.result.content;
    if (status.status === "failed") throw new Error(status.error);

    await new Promise((r) => setTimeout(r, 3000));
  }
}
```

### Example 2: Structured Output with JSON Schema

```javascript
const result = await scrape(
  "https://jobs.example.com/senior-engineer",
  "Extract all details about this job listing.",
  {
    type: "object",
    required: ["title", "company", "remote"],
    properties: {
      title: { type: "string" },
      company: { type: "string" },
      location: { type: ["string", "null"] },
      remote: { type: ["boolean", "null"] },
      salary_min: { type: ["number", "null"] },
      salary_max: { type: ["number", "null"] },
      employment_type: {
        type: ["string", "null"],
        enum: ["full_time", "part_time", "contract", null],
      },
      skills: {
        type: "array",
        items: { type: "string" },
      },
    },
  }
);
```

Schema rules:
- Fields in `required` always appear, as `null` if unavailable
- Optional fields are omitted if unavailable
- Mark potentially missing data as `["type", "null"]`

### Example 3: Site Crawling

```javascript
async function crawlSite(baseUrl, crawlInstruction, extractInstruction, maxPages = 20) {
  const res = await fetch(`${BASE_URL}/crawl`, {
    method: "POST",
    headers: HEADERS,
    body: JSON.stringify({
      baseUrl,
      crawlInstruction,
      transformInstruction: extractInstruction,
      maxPages,
      useProxy: true,
    }),
  });
  const { jobId } = await res.json();

  while (true) {
    const data = await fetch(`${BASE_URL}/crawl/${jobId}`, {
      headers: HEADERS,
    }).then((r) => r.json());

    if (data.status === "completed") return data.result;
    if (data.status === "failed") throw new Error("Crawl failed");

    console.log(data.progress?.message ?? "crawling...");
    await new Promise((r) => setTimeout(r, 5000));
  }
}

// Example: crawl competitor's blog
const posts = await crawlSite(
  "https://competitor.com/blog",
  "Find all blog post pages published in the last 6 months",
  "Extract the title, author, publish date, and a one-sentence summary",
  30
);
```

### Example 4: Geo-Targeted Scraping

```javascript
const result = await scrape(
  "https://www.amazon.de/gp/bestsellers/electronics",
  "List the top 10 bestselling electronics with name and price in EUR",
  {
    type: "object",
    required: ["products"],
    properties: {
      products: {
        type: "array",
        items: {
          type: "object",
          properties: {
            name: { type: "string" },
            price_eur: { type: ["number", "null"] },
            rank: { type: "number" },
          },
        },
      },
    },
  },
  { proxyCountry: "de" }
);
```

### Example 5: Authenticated Scraping

```javascript
const result = await scrape(
  "https://app.example.com/dashboard/reports",
  "Extract monthly revenue, active users, and conversion rate for last 3 months",
  {
    type: "object",
    required: ["months"],
    properties: {
      months: {
        type: "array",
        items: {
          type: "object",
          properties: {
            month: { type: "string" },
            revenue: { type: "number" },
            active_users: { type: "number" },
            conversion_rate: { type: "number" },
          },
        },
      },
    },
  },
  { cookies: "session=abc123; auth_token=xyz789; csrf=def456" }
);
```

### Example 6: Integration with AI Agents

```javascript
import { generateText, tool } from "ai";
import { anthropic } from "@ai-sdk/anthropic";
import { z } from "zod";

const result = await generateText({
  model: anthropic("claude-opus-4-6"),
  maxSteps: 5,
  tools: {
    scrapeUrl: tool({
      description:
        "Fetch and extract structured data from a URL. Use this when you need current information from a website.",
      parameters: z.object({
        url: z.string().describe("The URL to scrape"),
        prompt: z.string().describe("What to extract from the page, in plain English"),
      }),
      execute: async ({ url, prompt }) => {
        const data = await scrape(url, prompt);
        return JSON.stringify(data);
      },
    }),
  },
  prompt: "Research the top news stories and summarize them",
});
```

## Key Takeaways

- Web scraping solves the fundamental problem of LLM knowledge cutoff dates
- Modern sites require JavaScript rendering; raw HTTP fetches are insufficient
- Scraping APIs provide the most reliable agent-ready implementation
- Structured output with JSON schemas eliminates parsing complexity
- Async job submission with polling prevents blocking agent workflows
- Authentication, geo-targeting, and crawling are essential production features
