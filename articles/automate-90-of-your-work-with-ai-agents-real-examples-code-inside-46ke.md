---
title: "Automate 90% of Your Work with AI Agents (Real Examples & Code Inside)"
url: https://dev.to/copilotkit/automate-90-of-your-work-with-ai-agents-real-examples-code-inside-46ke
author: Anmol Baranwal
category: ai-agent-development
---

# Automate 90% of Your Work with AI Agents (Real Examples & Code Inside)

**Author:** Anmol Baranwal
**Published:** April 1, 2025
**Last Modified:** April 14, 2025

---

## Overview

"In 2025, agents can handle 90% of your workflow, freeing you and your team to focus on what truly matters." The article explores CoAgents through CopilotKit, a full-stack framework for building interactive agents and copilots integrated with LangGraph and CrewAI.

## What is Covered

1. CoAgents with core components
2. CrewAI integration (Crews + Flows)
3. Workflow automation fundamentals and misconceptions
4. Real-world examples with source code
5. Common pitfalls and best practices

---

## Part 1: Understanding Agents and CoAgents

### AI Agents Defined

AI agents function as intelligent assistants that determine how to accomplish tasks. The LLM serves as the system's brain, utilizing tools and external APIs to interact with the external world and execute specific functions.

### CoAgents Concept

CoAgents represents the fusion of "Copilot + Agents," designed to decompose tasks into smaller steps, coordinate actions, and maintain human involvement throughout workflows. The framework emphasizes "Human-in-the-Loop" capabilities, allowing intervention at critical moments.

**Example Use Case:** When a sales professional Dan submits travel reimbursement in the wrong currency, CoAgents can request human input to correct mistakes before escalation.

### Core Components

**1. Shared State (Agent <-> Application)**

Maintains synchronized state between AI agent and application for real-time information access.

```javascript
const { state, setState } = useCoAgent("the agent name");
```

**2. Agentic Generative UI**

Renders the agent's real-time state in chat UI, displaying ongoing agent activities.

```python
useCoagentStateRender({
  name: "research_agent",
  node: "download_progress",
  render: ({ state, nodeName, status }) => {
    return Progress logs = { state.logs } / ;
  }
});
```

**3. Human-in-the-Loop**

Establishes breakpoints requiring human approval or input, enhancing safety and performance.

```javascript
useCopilotAction({
  name: "ApprovePlan",
  parameters: [
    { name: "planSteps", type: "string[]" }
  ],
  renderAndWait: ({ args, handler }) => (
    <ConfirmPlan
      planSteps={args.planSteps}
      onApprove={(approvedSteps) => handler({ ... })}
      onDeny={() => handler({ ... })}
    />
  )
});
```

**4. Realtime Frontend Actions**

Sends frontend actions to LangGraph agents as they become available, enabling agents to interact with application interfaces in real-time.

```javascript
useCopilotAction({
  name: "InsertItemInList",
  parameters: [
    { name: "city", type: "string" },
    { name: "country", type: "string" }
  ],
  handler: ({ args, status }) => {
    // ...
  }
});
```

---

## Part 2: CrewAI Integration

### What is CrewAI?

CrewAI is an orchestration framework for role-playing AI agents, enabling developers to create crews with specific responsibilities that collaborate on complex tasks.

### Crews vs. Flows

- **Crews:** Define "who" (agents collaborating). Choose for autonomous problem-solving and creative collaboration
- **Flows:** Define "how" (process followed). Choose for deterministic outcomes and structured workflows

### CopilotKit + CrewAI Integration

Installation requires:
```bash
npm install @copilotkit/react-ui @copilotkit/react-core
```

Register your crew on `cloud.copilotkit.ai` with API endpoint and bearer token.

**Setup Provider:**

```typescript
import { CopilotKit } from "@copilotkit/react-core";

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body>
        <CopilotKit
          publicApiKey="<your-copilot-cloud-public-api-key>"
          agent="sample_agent"
        >
          {children}
        </CopilotKit>
      </body>
    </html>
  );
}
```

**Setup Chat UI:**

```typescript
import { CopilotPopup } from "@copilotkit/react-ui";

export function YourApp() {
  return (
    <>
      <YourMainContent />
      <CopilotPopup
        instructions="You are assisting the user as best as you can. Answer in the best way possible given the data you have."
        labels={{
          title: "Popup Assistant",
          initial: "Need any help?"
        }}
      />
    </>
  );
}
```

**Starter Templates:**
- CrewAI Crews: `coagents-starter-crewai-crews`
- CrewAI Flows: `coagents-starter-crewai-flows`

---

## Part 3: Workflow Automation Fundamentals

### Core Principle

"WHEN something happens, DO a specific action" -- automation follows this basic pattern regardless of complexity.

### Process vs. Workflow

- **Process:** What needs accomplishing (sending an invoice)
- **Workflow:** How to accomplish it (create invoice -> upload to DocuSign -> email for signature -> follow up for payment)

### Common Misconceptions

- **"It's just scripting"** -- Modern automation tools connect apps, handle complex workflows, and adapt to situations
- **"Only developers can use it"** -- No-code tools like Zapier and n8n enable non-technical users
- **"Expensive and complex"** -- Many automation tools are affordable and easy to implement for small teams

---

## Part 4: Real-World Examples with Source Code

### Example 1: Research Agent Native Application

**Overview:** Automated research with human approval gates prevents AI hallucinations while maintaining workflow speed.

**How it works:**
1. User provides research prompt
2. Agent suggests structured sections for approval
3. User approves/rejects each topic
4. Agent generates detailed content for approved topics

**Implementation using `useLangGraphInterrupt`:**

```typescript
import { useLangGraphInterrupt } from "@copilotkit/react-core";

export default function HomePage() {
  const { state: researchState, setResearchState } = useResearch();
  const streamingSection = useStreamingContent(researchState);

  useLangGraphInterrupt<Proposal>({
    render: ({ resolve, event }) => {
      return <ProposalViewer
        proposal={event.value}
        onSubmit={(approved, proposal) => resolve(
          JSON.stringify({
            ...proposal,
            approved,
          })
        )}
      />
    }
  })
  // ...
}
```

**State Synchronization:**

```javascript
const { state, setState, run } = useCoAgent<ResearchState>({
  name: 'agent',
  initialState: {},
});
```

### Example 2: AI Travel App

**Overview:** Automated travel planning using location preferences, integrating Google Maps API for accuracy.

**Streaming Search Progress:**

```python
from copilotkit.langgraph import copilotkit_emit_state, copilotkit_customize_config

async def search_node(state: AgentState, config: RunnableConfig):
  """
  The search node is responsible for searching for places.
  """
  ai_message = cast(AIMessage, state["messages"][-1])

  config = copilotkit_customize_config(
    config,
    emit_intermediate_state=[{
      "state_key": "search_progress",
      "tool": "search_for_places",
      "tool_argument": "search_progress",
    }],
  )

  state["search_progress"] = state.get("search_progress", [])
  queries = ai_message.tool_calls[0]["args"]["queries"]

  for query in queries:
    state["search_progress"].append({
      "query": query,
      "results": [],
      "done": False
    })

    await copilotkit_emit_state(config, state)
    # ...
```

---

## Key Takeaways

1. **CoAgents bridge autonomy and control** by automating 90% of work while keeping humans in the loop for critical decisions
2. **Shared state synchronization** between agent and UI enables real-time transparency and user oversight
3. **Human-in-the-Loop integration** prevents costly mistakes by requiring approval at strategic checkpoints
4. **CrewAI + CopilotKit combination** simplifies building production-ready agentic applications
5. **Workflow automation misconceptions** obscure its accessibility -- tools exist for all technical skill levels
6. **Real-world implementations** demonstrate practical value in research, travel planning, and beyond

## Resources

- [CopilotKit GitHub](https://go.copilotkit.ai/copilotkit)
- [CoAgents Documentation](https://www.copilotkit.ai/coagents)
- [Copilot Cloud](https://cloud.copilotkit.ai/)
- [CrewAI Documentation](https://docs.crewai.com/introduction)
