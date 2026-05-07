---
title: "Easily Build a UI for Your AI Agent in Minutes (LangGraph + CopilotKit)"
url: "https://dev.to/copilotkit/easily-build-a-ui-for-your-langgraph-ai-agent-in-minutes-with-copilotkit-1khj"
author: "Bonnie"
category: "agent-ui-frameworks"
---

# Easily Build a UI for Your AI Agent in Minutes (LangGraph + CopilotKit)
**Author:** Bonnie
**Published:** March 20, 2025

## Overview
Tutorial demonstrating an agent-native research canvas application combining human-in-the-loop capabilities using LangGraph, CopilotKit, and Tavily search.

## Key Concepts

### Shared State with useCoAgent

```typescript
import { useCoAgent } from "@copilotkit/react-core";

const { state: coAgentState, setState: setCoAgentsState, run } = useCoAgent<ResearchState>({
  name: 'agent',
  initialState: {},
});
```

### Backend State Emission

```python
async def tool_node(self, state: ResearchState, config: RunnableConfig):
    config = copilotkit_customize_config(config, emit_messages=False)
    # ... tool execution ...
    await copilotkit_emit_state(config, tool_state)
```

### CopilotKit Provider Setup

```typescript
import { CopilotKit } from "@copilotkit/react-core";

<CopilotKit
  publicApiKey={process.env.NEXT_PUBLIC_COPILOT_CLOUD_API_KEY}
  showDevConsole={false}
  agent="agent"
>
  <TooltipProvider>
    <ResearchProvider>{children}</ResearchProvider>
  </TooltipProvider>
</CopilotKit>
```

### Chat Component

```typescript
import { CopilotChat } from "@copilotkit/react-ui";

export default function Chat(props: CopilotChatProps) {
  return (
    <CopilotChat
      instructions={MAIN_CHAT_INSTRUCTIONS}
      labels={{ title: MAIN_CHAT_TITLE, initial: INITIAL_MESSAGE }}
      className="h-full w-full font-noto"
      {...props}
    />
  );
}
```

### Human-in-the-Loop
HITL allows agents to request human input or approval during execution, enabled by marking "Interrupt After" on workflow nodes in LangGraph Studio.
