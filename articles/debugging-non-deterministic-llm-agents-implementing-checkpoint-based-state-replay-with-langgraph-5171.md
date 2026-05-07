---
title: "Debugging Non-Deterministic LLM Agents: Implementing Checkpoint-Based State Replay with LangGraph Time Travel"
url: "https://dev.to/sreeni5018/debugging-non-deterministic-llm-agents-implementing-checkpoint-based-state-replay-with-langgraph-5171"
author: "Seenivasa Ramadurai"
category: "multi-cloud-durable"
---

# Debugging Non-Deterministic LLM Agents: Implementing Checkpoint-Based State Replay with LangGraph Time Travel
**Author:** Seenivasa Ramadurai
**Published:** December 30, 2025

## Overview
Addresses the fundamental challenge of LLM non-determinism in production systems requiring reproducibility and auditability. Demonstrates LangGraph's Time Travel feature through a loan approval agent with complete state checkpointing at every decision step, enabling replay for debugging and regulatory compliance.

## Key Concepts

Four-node workflow with checkpointing: Credit Assessment, Income Verification, Risk Analysis, and Decision.

```python
def create_loan_agent(api_key: str):
    model = ChatOpenAI(model="gpt-4o-mini", temperature=0, api_key=api_key)

    def assess_credit(state: LoanApplicationState) -> dict:
        prompt = f"Assess credit worthiness: Credit Score: {state.get('credit_score')}"
        response = model.invoke(prompt)
        try:
            credit_assessment = json.loads(response.content.strip())
        except:
            score = state.get('credit_score', 0)
            credit_assessment = {"assessment": "PASS" if score >= 700 else "FAIL"}
        return {"credit_assessment": credit_assessment}

    graph = StateGraph(LoanApplicationState)
    graph.add_node("assess_credit", assess_credit)
    graph.add_node("verify_income", verify_income)
    graph.add_node("analyze_risk", analyze_risk)
    graph.add_node("make_decision", make_decision)
    graph.add_edge(START, "assess_credit")
    graph.add_edge("assess_credit", "verify_income")
    graph.add_edge("verify_income", "analyze_risk")
    graph.add_edge("analyze_risk", "make_decision")
    graph.add_edge("make_decision", END)

    memory = InMemorySaver()
    return graph.compile(checkpointer=memory)
```

Teams can investigate rejected applications by replaying the exact sequence, identify errors, correct data and re-run from any checkpoint, and provide regulators with documented decision rationales. Potential costs without this: $500K-$2M per discrimination lawsuit, $1M-$10M in regulatory fines.
