---
title: "Build an AI-Powered QA Agent with Agent Browser, Vercel AI SDK, and LLM Gateway"
url: "https://dev.to/smakosh/build-an-ai-powered-qa-agent-with-agent-browser-vercel-ai-sdk-and-llm-gateway-2om0"
author: "smakosh"
category: "voice-agents"
---

# Build an AI-Powered QA Agent with Agent Browser, Vercel AI SDK, and LLM Gateway

**Author:** smakosh
**Published:** March 2, 2026
**Tags:** #ai #testing #webdev #javascript

## Overview

The article presents a framework for automated QA testing using natural language instructions. Rather than writing traditional test scripts, users describe tests in plain English, and an AI agent navigates a real browser to execute them.

## Key Concept

"What if you could test your web app by just describing what to test in plain English? No Selenium scripts, no Cypress configs -- just tell an AI agent 'test the signup flow' and watch it navigate, click, type, and verify results in a real browser."

## Architecture

**Five-step process:**

1. User describes test in natural language
2. Vercel AI SDK sends prompt to LLM via LLM Gateway with browser tools
3. LLM decides which browser actions to execute
4. Agent Browser performs actions on headless Chromium
5. Results stream back as NDJSON with real-time updates

## Tech Stack

- Next.js 16 (App Router)
- Vercel AI SDK v6
- @llmgateway/ai-sdk-provider
- agent-browser
- Zod for schema validation

## Core Browser Tools

The implementation defines seven main tools:

```javascript
import { tool } from "ai";
import { BrowserManager } from "agent-browser/dist/browser.js";
import { z } from "zod";

function createBrowserTools(browser: BrowserManager) {
  return {
    browser_navigate: tool({
      description: "Navigate the browser to a URL",
      inputSchema: z.object({
        url: z.string().describe("The URL to navigate to"),
      }),
      execute: async ({ url }) => {
        const page = browser.getPage();
        await page.goto(url, { waitUntil: "domcontentloaded" });
        return { url, title: await page.title() };
      },
    }),

    browser_snapshot: tool({
      description:
        "Get an accessibility snapshot of the current page. Returns a text tree with element refs (e.g. [ref=e1]) that you can use with browser_click and browser_type.",
      inputSchema: z.object({}),
      execute: async () => {
        const snapshot = await browser.getSnapshot({ interactive: true });
        const tree =
          typeof snapshot.tree === "string"
            ? snapshot.tree
            : JSON.stringify(snapshot.tree);
        const maxChars = 30_000;
        if (tree.length > maxChars) {
          return { snapshot: tree.slice(0, maxChars) + "\n... (truncated)" };
        }
        return { snapshot: tree };
      },
    }),

    browser_click: tool({
      description: "Click an element using its ref from a snapshot (e.g. @e1)",
      inputSchema: z.object({
        ref: z.string().describe("The ref of the element to click"),
      }),
      execute: async ({ ref }) => {
        const locator = browser.getLocator(ref);
        await locator.click();
        return { clicked: ref };
      },
    }),

    browser_type: tool({
      description: "Type text into an input field using its ref",
      inputSchema: z.object({
        ref: z.string().describe("The ref of the input element"),
        text: z.string().describe("The text to type"),
        clear: z.boolean().optional().describe("Clear first (default: true)"),
      }),
      execute: async ({ ref, text, clear = true }) => {
        const locator = browser.getLocator(ref);
        if (clear) {
          await locator.fill(text);
        } else {
          await locator.pressSequentially(text);
        }
        return { typed: text, into: ref };
      },
    }),

    browser_press_key: tool({
      description: "Press a keyboard key (e.g. Enter, Tab, Escape)",
      inputSchema: z.object({
        key: z.string().describe("The key to press"),
      }),
      execute: async ({ key }) => {
        const page = browser.getPage();
        await page.keyboard.press(key);
        return { pressed: key };
      },
    }),

    browser_scroll: tool({
      description: "Scroll the page in a direction",
      inputSchema: z.object({
        direction: z.enum(["up", "down", "left", "right"]),
        amount: z.number().optional().describe("Pixels (default: 500)"),
      }),
      execute: async ({ direction, amount = 500 }) => {
        const page = browser.getPage();
        const deltaX =
          direction === "left" ? -amount : direction === "right" ? amount : 0;
        const deltaY =
          direction === "up" ? -amount : direction === "down" ? amount : 0;
        await page.mouse.wheel(deltaX, deltaY);
        return { scrolled: direction, amount };
      },
    }),

    browser_hover: tool({
      description: "Hover over an element using its ref",
      inputSchema: z.object({
        ref: z.string().describe("The ref of the element to hover"),
      }),
      execute: async ({ ref }) => {
        const locator = browser.getLocator(ref);
        await locator.hover();
        return { hovered: ref };
      },
    }),

    browser_go_back: tool({
      description: "Go back to the previous page",
      inputSchema: z.object({}),
      execute: async () => {
        const page = browser.getPage();
        await page.goBack();
        return { url: page.url() };
      },
    }),
  };
}
```

## API Route Implementation

```javascript
import { createLLMGateway } from "@llmgateway/ai-sdk-provider";
import { generateText, stepCountIs } from "ai";
import { BrowserManager } from "agent-browser/dist/browser.js";

export const maxDuration = 120;

export async function POST(request: Request) {
  const { instruction, model, targetUrl } = await request.json();

  const llmgateway = createLLMGateway({
    apiKey: process.env.LLMGATEWAY_API_KEY,
  });

  const browser = new BrowserManager();
  const encoder = new TextEncoder();
  let stepCount = 0;

  const stream = new ReadableStream({
    async start(controller) {
      const emit = (data: Record<string, unknown>) =>
        controller.enqueue(encoder.encode(JSON.stringify(data) + "\n"));

      try {
        emit({ type: "status", message: "Launching headless browser..." });

        await browser.launch({
          id: "qa",
          action: "launch",
          headless: true,
        });

        await browser.startScreencast(
          (frame) => {
            emit({ type: "screenshot", imageData: frame.data });
          },
          {
            format: "jpeg",
            quality: 50,
            maxWidth: 1280,
            maxHeight: 720,
            everyNthFrame: 2,
          }
        );

        emit({ type: "status", message: "Browser ready. Running test..." });

        const tools = createBrowserTools(browser);

        const result = await generateText({
          model: llmgateway(model || "anthropic/claude-sonnet-4-5"),
          tools,
          stopWhen: stepCountIs(25),
          system: `You are a QA testing agent. Your task is to test a web application by interacting with it through a browser.

INSTRUCTIONS:
1. First, navigate to: ${targetUrl}
2. Use browser_snapshot to read the current page state before interacting
3. Execute the test described by the user step by step
4. Use browser_click to click elements (use the ref attribute from snapshots, e.g. @e1)
5. Use browser_type to type text into input fields
6. After completing the test, provide a clear summary of results -- what passed, what failed, and why

Be methodical: always snapshot the page before acting so you know what elements are available.`,
          prompt: instruction,
          onStepFinish({ toolCalls, text }) {
            if (toolCalls?.length) {
              for (const call of toolCalls) {
                stepCount++;
                emit({
                  type: "action",
                  step: stepCount,
                  tool: call.toolName,
                  args: call.input,
                  status: "done",
                });
              }
            }
            if (text) {
              emit({ type: "text", content: text });
            }
          },
        });

        emit({ type: "result", summary: result.text });
      } catch (err) {
        const message =
          err instanceof Error ? err.message : String(err);
        emit({ type: "error", message });
      } finally {
        await browser.stopScreencast();
        await browser.close();
        controller.close();
      }
    },
  });

  return new Response(stream, {
    headers: {
      "Content-Type": "application/x-ndjson",
      "Transfer-Encoding": "chunked",
    },
  });
}
```

## Model Switching

The LLM Gateway abstraction enables easy provider switching:

```javascript
// Anthropic Claude
model: llmgateway("anthropic/claude-sonnet-4-5")

// OpenAI GPT-4o
model: llmgateway("openai/gpt-4o")

// Google Gemini
model: llmgateway("google/gemini-2.5-pro")
```

## Response Stream Format

Results return as newline-delimited JSON:

```json
{"type":"status","message":"Launching headless browser..."}
{"type":"status","message":"Browser ready. Running test..."}
{"type":"action","step":1,"tool":"browser_navigate","args":{"url":"http://localhost:3000"},"status":"done"}
{"type":"action","step":2,"tool":"browser_snapshot","args":{},"status":"done"}
{"type":"action","step":3,"tool":"browser_click","args":{"ref":"@e5"},"status":"done"}
{"type":"screenshot","imageData":"base64..."}
{"type":"text","content":"I can see the signup form with email and password fields."}
{"type":"result","summary":"Test passed: signup flow works correctly."}
```

## Key Architectural Advantages

1. **Semantic understanding:** "Accessibility snapshots provide text-based element trees rather than screenshots, reducing cost and improving reliability"
2. **Real-time feedback:** NDJSON streaming reveals each agent action immediately
3. **Provider flexibility:** Swap LLMs without code changes
4. **Safety guardrails:** `stepCountIs(25)` limits iterations; 120-second timeout prevents runaway agents

## Future Extensions

- Test suites for sequential execution
- Visual regression testing
- CI/CD integration
- Custom assertion tools
- API response checking

## Resources

- [GitHub Repository](https://github.com/theopenco/llmgateway-templates/tree/main/templates/qa-agent)
- [Agent Browser npm](https://www.npmjs.com/package/agent-browser)
- [Vercel AI SDK Documentation](https://ai-sdk.dev)
- [LLM Gateway API Key](https://llmgateway.io/signup)
