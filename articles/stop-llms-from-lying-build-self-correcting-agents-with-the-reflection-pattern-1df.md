---
title: "Stop LLMs from Lying: Build Self-Correcting Agents with the Reflection Pattern"
url: "https://dev.to/programmingcentral/stop-llms-from-lying-build-self-correcting-agents-with-the-reflection-pattern-1df"
author: "Programming Central"
category: "agent-reflection"
---

# Stop LLMs from Lying: Build Self-Correcting Agents with the Reflection Pattern

**Author:** Programming Central
**Published:** March 19, 2026

## Overview
Introduces the Reflection Pattern, an architectural approach for building self-correcting AI agents that iteratively refine outputs through critique and regeneration cycles. Transforms agents from "generate-and-return" pipelines into "generate-critique-refine" cycles.

## Key Concepts

### Architecture Components
1. **Generator Node:** Creates initial drafts
2. **Evaluator/Critic Node:** Assesses drafts against quality criteria
3. **Router Node:** Makes conditional decisions based on evaluation results
4. **Final Output Node:** Returns validated responses

The pattern loops back to the Generator when critiques identify failures, enabling iterative improvement.

## Code Examples

### Complete Reflection Agent (TypeScript)
```typescript
interface AgentState {
    request: string;
    draftSummary: string;
    critique: string;
    shouldRefine: boolean;
    finalOutput: string;
}

const mockLLMCall = async (prompt: string): Promise<string> => {
    await new Promise(resolve => setTimeout(resolve, 100));

    if (prompt.includes("Critique the following summary")) {
        if (prompt.includes("Buy milk and eggs")) {
            return "The summary is too vague. It lacks context on why the items are needed or the deadline.";
        }
        return "The summary is clear and actionable.";
    } else {
        if (prompt.includes("Buy milk and eggs for dinner tonight")) {
            return "Task: Purchase groceries. Items: Milk, Eggs. Deadline: Tonight.";
        }
        return "Buy milk and eggs";
    }
};

async function generateDraft(state: AgentState): Promise<AgentState> {
    console.log("[Node] Generating initial draft...");
    const prompt = `Summarize this request concisely: "${state.request}"`;
    const draft = await mockLLMCall(prompt);
    return { ...state, draftSummary: draft };
}

async function reflectOnDraft(state: AgentState): Promise<AgentState> {
    console.log("[Node] Reflecting on draft quality...");
    const prompt = `Critique the following summary for clarity and specificity: "${state.draftSummary}"`;
    const critique = await mockLLMCall(prompt);
    const needsRefinement = critique.toLowerCase().includes("vague");
    return { ...state, critique: critique, shouldRefine: needsRefinement };
}

async function refineDraft(state: AgentState): Promise<AgentState> {
    console.log("[Node] Refining draft based on critique...");
    const prompt = `Original Request: "${state.request}". Previous Summary: "${state.draftSummary}". Critique: "${state.critique}". Please rewrite the summary to address the critique.`;
    const refinedDraft = await mockLLMCall(prompt);
    return { ...state, draftSummary: refinedDraft, critique: "" };
}

async function finalizeOutput(state: AgentState): Promise<AgentState> {
    console.log("[Node] Finalizing output...");
    return { ...state, finalOutput: `Final Summary: ${state.draftSummary}` };
}

function router(state: AgentState): "refine" | "finalize" {
    return state.shouldRefine ? "refine" : "finalize";
}

async function runReflectionAgent(userRequest: string) {
    let state: AgentState = {
        request: userRequest,
        draftSummary: "",
        critique: "",
        shouldRefine: false,
        finalOutput: "",
    };

    // 1. Generate
    state = await generateDraft(state);
    // 2. Reflect
    state = await reflectOnDraft(state);
    // 3. Conditional Loop
    const decision = router(state);
    if (decision === "refine") {
        state = await refineDraft(state);
        state = await reflectOnDraft(state);
    }
    // 4. Finalize
    state = await finalizeOutput(state);
    console.log(`Final Result: ${state.finalOutput}`);
}

runReflectionAgent("Buy milk and eggs for dinner tonight");
```

## Production Considerations
- Async timeout constraints on serverless platforms
- Infinite loop prevention through iteration counters
- State immutability requirements (always return new objects, not mutate)
