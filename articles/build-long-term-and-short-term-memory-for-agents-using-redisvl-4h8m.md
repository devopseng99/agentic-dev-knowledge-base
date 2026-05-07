---
title: "Build Long-Term and Short-Term Memory for Agents Using RedisVL"
url: "https://dev.to/qtalen/build-long-term-and-short-term-memory-for-agents-using-redisvl-4h8m"
author: "Peng Qian"
category: "llm-agent-caching-redis"
---

# Build Long-Term and Short-Term Memory for Agents Using RedisVL

**Author:** Peng Qian
**Published:** January 29, 2026

## Overview
Practical implementation of short-term (MessageHistory) and long-term (SemanticMessageHistory) memory with RedisVL and Microsoft Agent Framework. Finding: RedisVL works well for short-term memory but semantic long-term search has issues.

## Key Concepts

### Short-Term Memory

```python
class RedisVLMessageStore(ChatMessageStoreProtocol):
    def __init__(self, thread_id="common_thread", top_k=6,
                 session_tag=None, redis_url="redis://localhost:6379"):
        self._thread_id = thread_id
        self._top_k = top_k
        self._session_tag = session_tag or f"session_{uuid4()}"
        self._redis_url = redis_url
        self._init_message_history()

    async def list_messages(self) -> list[ChatMessage]:
        messages = self._message_history.get_recent(
            top_k=self._top_k, session_tag=self._session_tag)
        return [self._back_to_chat_message(m) for m in messages]
```

### Long-Term Semantic Memory

```python
class RedisVLSemanticMemory(ContextProvider):
    def __init__(self, distance_threshold=0.3, embedding_model="BAAI/bge-m3", ...):
        self._distance_threshold = distance_threshold
        self._init_semantic_store()

    def _init_semantic_store(self):
        vectorizer = HFTextVectorizer(model=self._embedding_model)
        self._semantic_store = SemanticMessageHistory(
            name=self._thread_id,
            distance_threshold=self._distance_threshold,
            redis_url=self._redis_url,
            vectorizer=vectorizer)
```

### Agent Integration

```python
agent = OpenAILikeChatClient(model_id=Qwen3.NEXT).create_agent(
    name="assistant",
    instructions="You're a helper answering questions in one sentence.",
    chat_message_store_factory=lambda: RedisVLMessageStore(session_tag="user_abc"))
```

### Critical Findings
- Short-term memory works effectively
- Semantic search retrieves questions preferentially over responses
- Distance threshold tuning is difficult (tested 0.3 and 0.2)
- RedisVL not storing requests and responses together is problematic
