---
title: "Here's How To Build Fullstack Agent Apps (Gemini, CopilotKit & LangGraph)"
url: "https://dev.to/copilotkit/heres-how-to-build-fullstack-agent-apps-gemini-copilotkit-langgraph-15jb"
author: "Anmol Baranwal"
category: "agent-ui-frameworks"
---

# Here's How To Build Fullstack Agent Apps (Gemini, CopilotKit & LangGraph)
**Author:** Anmol Baranwal
**Published:** September 16, 2025

## Overview
Demonstrates building two practical AI agents (Post Generator and Stack Analyzer) using Next.js 15, FastAPI, CopilotKit, LangGraph, and Google Gemini.

## Key Concepts

### Architecture
Frontend (Next.js) proxies requests through /api/copilotkit to FastAPI backend running LangGraph workflows with Google Gemini LLM.

### CopilotKit Wrapper
```typescript
import { CopilotKit } from "@copilotkit/react-core"
import { useLayout } from "./contexts/LayoutContext"

export default function Wrapper({ children }) {
  const { layoutState } = useLayout()
  return (
    <CopilotKit runtimeUrl="/api/copilotkit" agent={layoutState.agent}>
      {children}
    </CopilotKit>
  )
}
```

### Custom Actions for Rendering
```typescript
useCopilotAction({
  name: "generate_post",
  description: "Render a LinkedIn and X post",
  parameters: { tweet: {...}, linkedIn: {...} },
  render: ({ args }) => (
    <>
      <XPostCompact title={args.tweet.title} content={args.tweet.content} />
      <LinkedInPostCompact title={args.linkedIn.title} content={args.linkedIn.content} />
    </>
  ),
})
```

### Tool Logs Display
```typescript
useCoAgentStateRender({
  name: "post_generation_agent",
  render: (state) => <ToolLogs logs={state?.state?.tool_logs || []} />,
})
```

GitHub: https://github.com/CopilotKit/CopilotKit-Deepmind
