---
title: "Retrieval-Augmented Generation (RAG) Agents: How to Build Grounded, Tool-Using GenAI Systems"
url: https://dev.to/suraj_khaitan_f893c243958/retrieval-augmented-generation-rag-agents-how-to-build-grounded-tool-using-genai-systems-fhf
author: Suraj Khaitan
category: rag
---

# Retrieval-Augmented Generation (RAG) Agents: How to Build Grounded, Tool-Using GenAI Systems

**Author:** Suraj Khaitan
**Published:** December 28, 2025

---

## Summary

This article distinguishes between basic RAG (retrieve -> answer) and production-grade RAG agents capable of multi-step reasoning, tool execution, and safety controls. The author presents a vendor-agnostic reference architecture with concrete patterns for building systems that are grounded in evidence, observable, and maintainable.

---

## Core Distinctions

**RAG (Single-Shot):**
1. Accept a question
2. Retrieve relevant passages
3. Generate an answer

**RAG Agents (Iterative):**
1. Understand the goal
2. Decide next steps
3. Retrieve evidence (multiple times if needed)
4. Call tools (search, ticketing, database lookups)
5. Verify results
6. Respond with citations

---

## Reference Architecture

```
User
  |
Orchestrator (routing + policy)
  |-- Retriever (vector/keyword/hybrid)
  |-- Reranker (optional)
  |-- Context Builder (dedupe, trim, cite)
  |-- LLM Reasoner (constrained)
  |-- Tool Runner (allowlist + authz)
  |-- Memory (session + long-term summary)
  |-- Guardrails (input/output moderation)
  |-- Observability (traces, logs, evals)
  |
Answer + Citations + Actions
```

---

## End-to-End Request Handler (Python)

```python
from dataclasses import dataclass
from typing import Any

@dataclass
class AgentRequest:
    user_id: str
    session_id: str | None
    message: str
    metadata: dict[str, Any]

@dataclass
class AgentResponse:
    session_id: str
    answer: str
    citations: list[dict[str, Any]]
    actions: list[dict[str, Any]]
    metadata: dict[str, Any]

def handle_request(req: AgentRequest) -> AgentResponse:
    # 1) Establish session
    session_id = req.session_id or new_session_id()

    # 2) Apply INPUT guardrails
    filtered_message, gr_in = apply_guardrails(
        guardrails_client(), req.message, source="INPUT"
    )
    if gr_in.get("intervened"):
        return AgentResponse(
            session_id=session_id,
            answer="Your request can't be processed due to safety policies.",
            citations=[],
            actions=[],
            metadata={"guardrails": {"input": gr_in}},
        )

    # 3) Initialize tool session
    tool_session_id = initialize_tool_session()

    # 4) Hydrate long-term memory summary
    summary = load_agent_summary(store(), req.user_id, session_id)
    if summary:
        filtered_message += "\n\nAgent memory (summary): " + summary

    # 5) Retrieve evidence and run agent loop
    loop_budget = 3
    citations: list[dict[str, Any]] = []
    actions: list[dict[str, Any]] = []

    for _ in range(loop_budget):
        query = rewrite_query(filtered_message)
        retrieved = retrieve(query, filters=req.metadata)
        context = build_context(retrieved)

        step = reasoner_llm().next_step(
            user_message=filtered_message,
            context=context,
            allowed_tools=tool_allowlist(),
        )

        if step.type == "final":
            citations = step.citations
            answer = step.answer
            break

        if step.type == "tool_call":
            validate_tool_call(step.tool_name, step.arguments, req.user_id)
            tool_result = tool_call(
                step.tool_name, step.arguments, session_id=tool_session_id
            )
            actions.append({"tool": step.tool_name, "result": tool_result})
            filtered_message += "\n\nTool result: " + safe_json(tool_result)

    # 6) Persist updated memory summary
    new_summary = summarize_for_memory(filtered_message, answer)
    write_agent_summary(
        store(), req.user_id, session_id, new_summary, updated_at=iso_now()
    )

    # 7) Apply OUTPUT guardrails
    answer, gr_out = apply_guardrails(guardrails_client(), answer, source="OUTPUT")

    return AgentResponse(
        session_id=session_id,
        answer=answer,
        citations=citations,
        actions=actions,
        metadata={"guardrails": {"input": gr_in, "output": gr_out}},
    )
```

---

## Retrieval Best Practices

### Hybrid Retrieval
Vector search captures semantic similarity but misses exact identifiers, error codes, product strings, and proper nouns. Combine keyword (BM25) and vector approaches for robustness.

### Metadata Filtering
Filter early by product/version, region, document type, effective date, and access control labels to ensure retrieval accuracy.

### Query Rewriting
User questions often need reformulation for effective searching. Agents should generate optimized search queries before retrieval.

### Reranking
When retrieving 20 passages where many are marginally relevant, apply a reranker to reduce token bloat and context dilution.

---

## Context Engineering

Retrieved content requires careful processing:
- Deduplicate near-identical chunks
- Preserve section titles and timestamps
- Extract relevant spans (not entire pages)
- Maintain stable source IDs for citations
- Enforce strict token budgets

**Citation-Friendly Format Example:**
```
[Source: doc-17 | "Refund Policy" | Section: Eligibility | Updated: 2025-01-10]
"Refunds are available within 30 days if ..."

[Source: doc-23 | "Exceptions" | Section: Digital goods | Updated: 2024-11-02]
"Digital purchases are non-refundable unless ..."
```

---

## Tool-Calling Pattern (JSON-RPC Style)

```python
import os
import uuid
import httpx

TOOL_SERVER_URL = os.environ["TOOL_SERVER_URL"]

def call_tool_server(
    method: str, params: dict | None = None, session_id: str | None = None
) -> tuple[dict, dict]:
    headers = {
        "Content-Type": "application/json",
        "Tool-Protocol-Version": "2024-01-01",
    }
    if session_id:
        headers["Tool-Session-Id"] = session_id

    body = {
        "jsonrpc": "2.0",
        "id": str(uuid.uuid4()),
        "method": method,
        "params": params or {},
    }

    resp = httpx.post(TOOL_SERVER_URL, json=body, headers=headers, timeout=30)
    resp.raise_for_status()
    return resp.json(), dict(resp.headers)

def initialize_tool_session() -> str | None:
    _, headers = call_tool_server("initialize")
    return headers.get("Tool-Session-Id")

def tool_call(name: str, arguments: dict, session_id: str) -> dict:
    result, _ = call_tool_server(
        "tools/call",
        params={"name": name, "arguments": arguments},
        session_id=session_id,
    )
    return result
```

**Tool Safety Validation:**
- Confirm tool name is in allowlist
- Validate arguments against schema
- Check user authorization
- Enforce call budgets and latency limits

---

## Memory Management

**Short-term:** Last N conversation turns (high-fidelity, recent)
**Long-term:** Periodically updated summary (compact, durable)

### Summary Storage Pattern

```python
from dataclasses import asdict, dataclass
from typing import Any

@dataclass
class AgentSummaryRecord:
    user_id: str
    session_id: str
    updated_at: str
    summary: str

class KeyValueStore:
    def put(self, key: dict[str, str], item: dict[str, Any]) -> None: ...
    def get(self, key: dict[str, str]) -> dict[str, Any] | None: ...

def write_agent_summary(
    store: KeyValueStore, user_id: str, session_id: str, summary: str, updated_at: str
) -> None:
    record = AgentSummaryRecord(
        user_id=user_id,
        session_id=session_id,
        updated_at=updated_at,
        summary=summary,
    )
    store.put({"user_id": user_id, "session_id": session_id}, asdict(record))

def load_agent_summary(
    store: KeyValueStore, user_id: str, session_id: str
) -> str | None:
    item = store.get({"user_id": user_id, "session_id": session_id})
    if not item:
        return None
    return str(item.get("summary") or "")
```

**What Belongs in Summaries:**
- Explicit user preferences
- Confirmed factual knowledge
- Open tasks
- Important constraints

**Avoid Storing:**
- Secrets
- Raw documents
- Unnecessary PII

---

## Guardrails & Safety

### Input/Output Guardrails

```python
import json
from typing import Any

class GuardrailsClient:
    def apply(self, *, content: str, source: str) -> dict[str, Any]:
        """source is typically 'INPUT' or 'OUTPUT'."""
        raise NotImplementedError

def apply_guardrails(
    guardrails: GuardrailsClient, payload: str | dict[str, Any], source: str
) -> tuple[str | dict[str, Any], dict[str, Any]]:
    is_structured = isinstance(payload, dict)
    text = json.dumps(payload) if is_structured else payload

    resp = guardrails.apply(content=text, source=source)

    action = str(resp.get("action", "NONE")).upper()
    filtered = resp.get("filtered_content", text)
    intervened = action in {"BLOCK", "INTERVENED"}

    resp["intervened"] = intervened

    if is_structured:
        try:
            return json.loads(filtered), resp
        except Exception:
            return {"raw_output": filtered}, resp

    return filtered, resp
```

**Key Principles:**
- Treat retrieved content as untrusted input
- Block early rather than explain violations
- Apply guardrails to tool outputs containing sensitive data
- Maintain server-side authorization for tool calls

---

## Verification & Trust

### Enforce Citation Requirements
"No citation -> no claim" is a core rule. Statements without source backing must be labeled as uncertain or require follow-up questions.

### Quote-First Answering
1. Extract supporting quotes from sources
2. Author original prose
3. Attach citations

### Structured Response Contract

```json
{
  "answer": "...",
  "citations": [
    {
      "source_id": "doc-17",
      "title": "Refund Policy",
      "section": "Eligibility",
      "quote": "..."
    }
  ],
  "actions": [
    {
      "type": "create_ticket",
      "status": "success",
      "ticket_id": "INC-456"
    }
  ],
  "confidence": "medium",
  "follow_ups": ["What was the purchase date?"]
}
```

---

## Observability & Evaluation

### Key Logs/Traces
- Rewritten search queries
- Retrieval results (source IDs + scores)
- Reranking results
- Final context token count
- Tool calls (name, arguments hash, latency, status)
- Guardrails metadata
- Citations returned

### Starter Metrics
- **Citation coverage:** % of answers with >=1 citation
- **Groundedness:** evaluator score or ratio of supported claims
- **Retrieval precision:** relevance of top citations
- **Escalation rate:** frequency of "I don't know" or handoffs
- **Tool failure rate:** calls that fail or timeout
- **Latency:** p50/p95 end-to-end and component breakdowns

### Offline Evaluation Set
Build a small dataset (50-200 questions) with expected sources, disallowed sources, required follow-ups, and red-team prompts for injection testing.

---

## Shipping Checklist

1. Ship RAG with citations (even if answers are brief)
2. Add hybrid retrieval + metadata filtering
3. Add reranking if top-k results are noisy
4. Add context builder (deduplication + span extraction)
5. Add guardrails (input + output)
6. Add tool runner (allowlist + schema + authorization)
7. Implement tight agent loop (max 2-3 iterations)
8. Enforce verification (no citation -> no claim)
9. Add tracing + offline evaluations

---

## Key Takeaways

- "A RAG agent is best thought of as a retrieval system with an LLM interface -- not the other way around."
- Invest in retrieval quality, context building, tool safety, and verification before focusing on prompt engineering.
- System constraints (budgets, allowlists, authorization) should govern agent behavior, not prompts alone.
- Observable, traceable systems build user trust and simplify debugging.
