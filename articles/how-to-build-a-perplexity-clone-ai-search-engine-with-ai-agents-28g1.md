---
title: "Build your own AI search engine similar to Perplexity"
url: "https://dev.to/shayy/how-to-build-a-perplexity-clone-ai-search-engine-with-ai-agents-28g1"
author: "Shayan"
category: "enterprise-clones"
---

# Build your own AI search engine similar to Perplexity
**Author:** Shayan
**Published:** January 22, 2025

## Overview
A guide to building a Perplexity-like AI search engine that combines DuckDuckGo web search with Google Gemini LLM to answer questions with web-sourced information.

## Key Concepts

### Dependencies
```bash
npm install duck-duck-scrape agentmarkdown ai zod @ai-sdk/google
```

### Implementation
```javascript
import * as DDG from "duck-duck-scrape";
import { AgentMarkdown } from "agentmarkdown";
import { generateText, tool } from "ai";
import { z } from "zod";
import { createGoogleGenerativeAI } from "@ai-sdk/google";

const google = createGoogleGenerativeAI({
  apiKey: process.env.GEMINI_API_KEY,
});

async function fetchAndConvertToMarkdown(url) {
  try {
    const response = await fetch(url);
    const html = await response.text();
    const markdown = await AgentMarkdown.render({ html });
    return markdown.markdown;
  } catch (error) {
    console.error(`Error fetching ${url}:`, error);
    return "";
  }
}

const search = tool({
  description: "Search the web for information",
  parameters: z.object({
    query: z.string(),
  }),
  execute: async ({ query }) => {
    const count = 3;
    const searchResults = await DDG.search(query, {
      safeSearch: DDG.SafeSearchType.STRICT,
    });
    const result = searchResults.results.slice(0, count);
    const urls = result.map((r) => r.url);
    const markdownResults = await Promise.all(
      urls.map(async (url) => {
        const markdown = await fetchAndConvertToMarkdown(url);
        return markdown;
      })
    );
    return markdownResults.join("\n\n");
  },
});

const main = async () => {
  const { text } = await generateText({
    model: google("gemini-2.0-flash-exp"),
    tools: { search },
    maxSteps: 10,
    system: "You are a helpful assistant that can search the web for information.",
    prompt: "What's the current weather in Tokyo?",
  });
  console.log(text);
};

main();
```

### Architecture
- Web search integration + HTML-to-markdown conversion + LLM synthesis
- Technologies: DuckDuckGo API, Google Gemini 2.0 Flash, Vercel AI SDK
- Workflow: User query -> DuckDuckGo search -> Web page fetching -> Markdown conversion -> LLM processing -> Formatted response
