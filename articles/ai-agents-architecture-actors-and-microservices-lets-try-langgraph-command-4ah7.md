---
title: "AI Agents Architecture, Actors and Microservices: Let's Try LangGraph Command"
url: "https://dev.to/dbolotov/ai-agents-architecture-actors-and-microservices-lets-try-langgraph-command-4ah7"
author: "Dmitrii"
category: "agent-microservices"
---

# AI Agents Architecture, Actors and Microservices: Let's Try LangGraph Command

**Author:** Dmitrii
**Published:** December 23, 2024

## Overview
This article draws parallels between distributed systems (SOA, microservices, actor models) and AI agent development, exploring how LangGraph's Command feature bridges the gap between agent and actor concepts.

## Key Concepts

### Definitions
- **AI Agent:** A software entity powered by AI designed to perform tasks autonomously
- **Actor:** A finer-grained, lightweight, isolated entity that encapsulates state and communicates via message passing
- **Microservice:** Independently deployable, communicates over network using HTTP/REST or gRPC

### Comparison Table

| Aspect | Actor | Service/Microservice |
|--------|-------|---------------------|
| Granularity | Fine-grained | Coarse-grained |
| State | Internal, encapsulated | External, often stateless |
| Communication | Messages | APIs over network |
| Concurrency | Built-in | Depends on design |
| Scaling | Within/distributed system | Horizontal, per service |

## LangGraph Command Example

```javascript
import { Annotation, START } from "@langchain/langgraph";
import { ChatOpenAI } from "@langchain/openai";
import { Command } from "@langchain/langgraph";
import { HumanMessage, SystemMessage } from "@langchain/core/messages";
import { StateGraph } from "@langchain/langgraph";
import dotenv from 'dotenv';

dotenv.config();

const StateAnnotation = Annotation.Root({
    customerInquiry: Annotation<string>({
        value: (_prev, newValue) => newValue,
        default: () => "",
    }),
    route: Annotation<string>({
        value: (_prev, newValue) => newValue,
        default: () => "",
    })
});

const model = new ChatOpenAI({
    modelName: "gpt-4o-mini"
});

const routeUserRequest = async (state: typeof StateAnnotation.State) => {
    const response = await model.withStructuredOutput<{ route: "quotation" | "refund" }>({
        schema: {
            type: "object",
            properties: {
                route: { type: "string", enum: ["quotation", "refund"] }
            },
            required: ["route"]
        }
    }).invoke([
        new SystemMessage('Please categorize the user request'),
        new HumanMessage(state.customerInquiry)
    ]);

    const routeToFunctionName = {
        "quotation": "quotationAgent",
        "refund": "refundAgent"
    };

    return new Command({
        update: { route: response.route },
        goto: routeToFunctionName[response.route],
    });
};

const quotationAgent = (state) => { return {}; };
const refundAgent = (state) => { return {}; };

const graph = new StateGraph(StateAnnotation)
    .addNode("routeUserRequest", routeUserRequest, { ends: ["quotationAgent", "refundAgent"] })
    .addNode("quotationAgent", quotationAgent)
    .addNode("refundAgent", refundAgent)
    .addEdge(START, "routeUserRequest")
    .compile();

async function main() {
  try {
    await graph.invoke({ customerInquiry: 'Hi, I need refund' });
    console.log("Done");
  } catch (error) {
    console.error("Error in main function:", error);
  }
}

main();
```

## Future Outlook
LangGraph could evolve beyond graph-based structure by incorporating a message broker, actor addresses, and autodiscovery similar to Microsoft Orleans.
