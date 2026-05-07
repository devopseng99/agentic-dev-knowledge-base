---
title: "The Supervisor Pattern: Stop Writing Monolithic Agents and Start Orchestrating Teams"
url: "https://dev.to/programmingcentral/the-supervisor-pattern-stop-writing-monolithic-agents-and-start-orchestrating-teams-2olk"
author: "Programming Central"
category: "supervisor-agent-pattern"
---

# The Supervisor Pattern: Stop Writing Monolithic Agents and Start Orchestrating Teams

**Author:** Programming Central
**Published:** March 14, 2026

## Overview

Introduces the Supervisor Pattern for scalable multi-agent AI systems using LangGraph.js with TypeScript. A central Supervisor node orchestrates specialized Worker Agents in a hub-and-spoke topology, similar to how an API Gateway routes requests to microservices.

## Key Concepts

### Complete TypeScript Implementation

```typescript
import { StateGraph, Annotation, END, START } from "@langchain/langgraph";
import { ChatOpenAI } from "@langchain/openai";

// Define shared state interface
const StateAnnotation = Annotation.Root({
  userRequest: Annotation<string>({
    reducer: (curr, update) => update,
    default: () => "",
  }),
  nextAgent: Annotation<string>({
    reducer: (curr, update) => update,
    default: () => "",
  }),
  finalResponse: Annotation<string>({
    reducer: (curr, update) => curr + "\n" + update,
    default: () => "",
  }),
});

const llm = new ChatOpenAI({ model: "gpt-3.5-turbo", temperature: 0 });

// Supervisor node - routes requests to appropriate workers
const supervisorNode = async (state: typeof StateAnnotation.State) => {
  const systemPrompt = `
    You are a supervisor managing a SaaS customer support team.
    Available Agents:
    1. billing: Handles refunds, invoices, and payments.
    2. tech_support: Handles login errors, bugs, and features.
    3. FINISH: Use for general greetings.

    Respond with JSON: { "nextAgent": "agent_name" }
  `;

  const response = await llm.invoke(systemPrompt);
  let content = response.content as string;

  try {
    const jsonMatch = content.match(/\{.*\}/s);
    if (jsonMatch) {
      const decision = JSON.parse(jsonMatch[0]);
      return { nextAgent: decision.nextAgent };
    }
    return { nextAgent: "FINISH" };
  } catch (e) {
    console.error("Supervisor parsing failed:", e);
    return { nextAgent: "FINISH" };
  }
};

// Worker nodes
const billingNode = async (state: typeof StateAnnotation.State) => {
  const response = `[Billing System]: Processed refund. TX-9921.`;
  return { finalResponse: response };
};

const techSupportNode = async (state: typeof StateAnnotation.State) => {
  const response = `[Tech Support]: Clear cache and retry login.`;
  return { finalResponse: response };
};

// Conditional routing logic
const routeSupervisorDecision = (state: typeof StateAnnotation.State) => {
  if (state.nextAgent === "billing") return "billing_agent";
  if (state.nextAgent === "tech_support") return "tech_support_agent";
  return END;
};

// Graph construction
const workflow = new StateGraph(StateAnnotation);
workflow.addNode("supervisor", supervisorNode);
workflow.addNode("billing_agent", billingNode);
workflow.addNode("tech_support_agent", techSupportNode);

workflow.addEdge(START, "supervisor");
workflow.addConditionalEdges("supervisor", routeSupervisorDecision, {
  "billing_agent": "billing_agent",
  "tech_support_agent": "tech_support_agent",
  [END]: END
});

workflow.addEdge("billing_agent", END);
workflow.addEdge("tech_support_agent", END);

const app = workflow.compile();

// Execution
async function runSaaSWorkflow(userInput: string) {
  const initialState = {
    userRequest: userInput,
    nextAgent: "",
    finalResponse: "",
  };

  const stream = await app.streamEvents(initialState, { version: "v2" });
  for await (const event of stream) {
    const eventType = event.event;
    const nodeName = event.metadata?.langgraph_node;
    if (nodeName === "supervisor" && eventType === "on_chain_end") {
      console.log(`[Supervisor]: Route to -> ${event.data.output.nextAgent}`);
    }
  }
}

runSaaSWorkflow("I want a refund for order #12345");
```

### Common Production Pitfalls

1. **LLM JSON Parsing**: Models wrap JSON in Markdown; use regex extraction before parsing
2. **Serverless Timeouts**: Use streaming instead of blocking awaits
3. **Event Loop Deadlocks**: Return plain objects, not Promises with class instances
4. **State Mutation**: Return new objects rather than mutating state directly
