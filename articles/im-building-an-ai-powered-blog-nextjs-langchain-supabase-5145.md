---
title: "AI-Powered Blog Pt. II (Nextjs, GPT4, Supabase & CopilotKit)"
url: "https://dev.to/copilotkit/im-building-an-ai-powered-blog-nextjs-langchain-supabase-5145"
author: "Bonnie"
category: "ai-agent-supabase"
---

# AI-Powered Blog Pt. II (Nextjs, GPT4, Supabase & CopilotKit)

**Author:** Bonnie
**Published:** May 20, 2024

## Overview

Building an AI-powered blogging platform with research, autocomplete, and a Copilot using Next.js, Supabase, LangChain, OpenAI, Tavily AI for search, and CopilotKit as an open-source AI copilot framework.

## Key Concepts

### Tech Stack

- **Frontend:** Next.js with TypeScript and App Router
- **Rich Text Editor:** Quill
- **Backend/Database:** Supabase (PostgreSQL)
- **AI Framework:** LangChain
- **AI Model:** OpenAI API (ChatGPT)
- **Search/Research:** Tavily AI
- **AI Copilot:** CopilotKit

### Installation

```bash
npx create-next-app@latest aiblogapp
npm install quill react-quill @supabase/supabase-js @supabase/ssr @supabase/auth-helpers-nextjs @langchain/langgraph
npm install @copilotkit/react-ui @copilotkit/react-textarea @copilotkit/react-core @copilotkit/backend
```

### Components Built

1. **Header.tsx** -- Navigation bar with links
2. **Posts.tsx** -- Homepage displaying published articles in grid layout
3. **QuillEditor.tsx** -- Dynamically imported rich text editor
4. **Post.tsx** -- Article creation form with editor and publish functionality
5. **Comment.tsx** -- Comment submission form and display section

The project uses Supabase as a PostgreSQL hosting service and LangChain for AI agent capabilities to search the web and research topics.
