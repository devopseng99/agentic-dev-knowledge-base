---
title: "Five Agent Memory Types in LangGraph: A Deep Code Walkthrough (Part 2)"
url: https://dev.to/sreeni5018/five-agent-memory-types-in-langgraph-a-deep-code-walkthrough-part-2-17kb
author: Seenivasa Ramadurai
category: ai-agent-memory
---

# Five Agent Memory Types in LangGraph: A Deep Code Walkthrough (Part 2)

**Author:** Seenivasa Ramadurai
**Published:** April 3, 2026
**Tags:** #ai #agents #tutorial #python

---

## Overview

This article provides practical implementations of five memory architecture patterns for AI agents using LangGraph. Building on Part 1's conceptual foundation, it emphasizes that "the model only knows what is in the context window at inference time."

### Critical Distinction: Checkpointer vs. Store

The article highlights the most common architecture mistake: conflating LangGraph's two persistence mechanisms:

- **Checkpointer**: Per-thread state snapshots (resets with new thread_id)
- **Store**: Cross-thread, durable key-value records (survives thread boundaries)

---

## Memory Type 1: Short-Term Memory (STM)

**Pattern:** Rolling conversation transcript restored by checkpointer

```python
def chat(state: MessagesState) -> dict:
    return {"messages": [llm.invoke(state["messages"])]}

graph = StateGraph(MessagesState)
graph.add_node("model", chat)
app = graph.compile(checkpointer=InMemorySaver())

# Same thread_id reloads prior turns
app.invoke(
    {"messages": [HumanMessage("My codename is Bluejay.")]},
    {"configurable": {"thread_id": "session-stm-demo"}}
)
```

**Key insight:** Without checkpointer, each invoke starts blank. With it, prior messages auto-restore via add_messages reducer.

**Production challenge:** Context window fills as conversation grows. Solutions: truncation (drops oldest) or summarization (preserves gist).

---

## Memory Type 2: Long-Term Memory (LTM)

**Pattern:** Cross-thread persistence via Store

```python
def remember_node(state: MessagesState) -> dict:
    store = get_store()
    ns = ("users", "demo-user", "facts")

    if text.startswith("remember:"):
        fact = text.split(":", 1)[1].strip()
        store.put(ns, "profile", {"text": fact})
        return {"messages": [AIMessage(f"Stored: {fact}")]}

    item = store.get(ns, "profile")
    fact = item.value.get("text", "") if item else ""
    # Inject as SystemMessage for context without appearing user-sent
```

**Critical detail:** Retrieved LTM facts go into SystemMessage, not HumanMessage, to separate background context from conversation flow.

**Namespace pattern:** Tuples like `("users", user_id, "facts")` act as hierarchical paths. Different namespaces isolate different data.

---

## Memory Type 3: Working Memory

**Pattern:** Ephemeral scratchpad accumulating intermediate results

```python
class WorkingState(TypedDict):
    messages: Annotated[list[BaseMessage], add_messages]
    notes: Annotated[list[str], operator.add]  # Concatenates, not replaces

def research_step(_: WorkingState) -> dict:
    return {"notes": ["Competitor A: $49", "Competitor B: $39"]}

def answer_from_notes(state: WorkingState) -> dict:
    notes = "\n".join(state["notes"])
    # Multiple research nodes append; all results available here
```

**Reducer pattern:** `operator.add` ensures multiple nodes writing to `notes` concatenate rather than overwrite.

**Lifecycle:** Lives only during single invoke. No checkpointer needed. Clears when call returns.

---

## Memory Type 4: Episodic Memory

**Pattern:** Append-only event log with search

```python
eid = str(uuid.uuid4())
store.put(
    ("users", "demo-user", "episodes"),
    eid,
    {
        "task": "pricing_review",
        "outcome": "Chose plan B after comparing quotes"
    }
)

results = store.search(ns, limit=5)
```

**Design choice:** Each episode gets unique UUID. Never overwrite (preserve audit trail) unless outcome updates warrant same key.

**Production upgrades:** Add timestamps for range filtering, embed outcomes for semantic recall.

---

## Memory Type 5: Semantic Memory (RAG)

**Pattern:** ReAct loop with vector-retrieved knowledge

```python
@tool
def profile_kb_search(query: str) -> str:
    """Retrieve top-k chunks from profile knowledge base."""
    docs = kb.similarity_search(query, k=2)
    return "\n".join(d.page_content for d in docs)

graph.add_conditional_edges(
    "agent", tools_condition,
    {"tools": "tools", "__end__": END}
)
```

**Execution flow:**
1. Agent sees question + tool definition
2. LLM emits tool_calls -> routes to ToolNode
3. Tool executes, result appended as ToolMessage
4. Agent re-invokes seeing original query + retrieved context
5. Agent produces final answer or more tool calls

**Why not system prompt?** "For anything non-trivial: system prompts have token limits, you pay for all tokens even if irrelevant, RAG retrieves only what's relevant."

---

## Environment Setup

```bash
pip install langgraph langchain-openai langchain-community faiss-cpu python-dotenv
export OPENAI_API_KEY=sk-...
export OPENAI_CHAT_MODEL=gpt-4o-mini  # optional
```

**macOS note:** Set `os.environ.setdefault("KMP_DUPLICATE_LIB_OK", "TRUE")` before FAISS import to prevent OpenMP collision.

---

## Production Upgrades

| Component | Local Dev | Production |
|-----------|-----------|-----------|
| Checkpointer | InMemorySaver | SqliteSaver.from_conn_string("checkpoints.db") |
| Store | InMemoryStore | SqliteStore (separate file) or cloud vector DB |
| Vector Index | FAISS (RAM-only) | Pinecone, Weaviate, ChromaDB |

---

## Key Takeaways

1. **Context window is the only reality** -- every token must physically be present at inference
2. **Checkpointers save per-thread snapshots; stores save cross-thread facts** -- conflating these breaks most designs
3. **Reducers** (operator.add, add_messages) control how multiple writes merge
4. **SystemMessage injection** keeps retrieved context separate from conversation
5. **ReAct loops** (agent + tools_condition) create feedback cycles for multi-step reasoning

---

## Complete Runnable Script

The article provides a full, production-ready script executing all five patterns sequentially with zero external setup beyond API keys. Available in the original article for immediate experimentation.
