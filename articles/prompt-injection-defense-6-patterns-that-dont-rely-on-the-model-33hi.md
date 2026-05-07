---
title: "Prompt Injection Defense: 6 Patterns That Don't Rely on the Model"
url: "https://dev.to/gabrielanhaia/prompt-injection-defense-6-patterns-that-dont-rely-on-the-model-33hi"
author: "Gabriel Anhaia"
category: "llm-research-evals"
---
# Prompt Injection Defense: 6 Patterns That Don't Rely on the Model
**Author:** Gabriel Anhaia  **Published:** May 5, 2026

## Overview
Six structural defense patterns against prompt injection that operate independently of model behavior. The core principle: defense must keep working when the model is gullible — structural boundaries prevent model mistakes from reaching privileged systems.

## Key Concepts

### Why Model-Based Defenses Fail
Relying on the model to recognize and refuse prompt injection creates a single point of failure. Adversarial inputs are specifically designed to bypass model-level instructions. Structural defenses operate at the infrastructure layer, making them robust to model-level compromise.

### Pattern 1: Side Filters on Indirect Content
Screen untrusted sources (emails, PDFs, search results) with regex patterns and classifiers before they reach the model's prompt. Content flagged as injection attempts is sanitized or blocked before model processing.

```python
INJECTION_SIGNALS = [
    r"ignore previous instructions",
    r"you are now",
    r"new task:",
    r"</?system>",
    r"\[INST\]",
]

def side_filter(content: str) -> str:
    for pattern in INJECTION_SIGNALS:
        if re.search(pattern, content, re.IGNORECASE):
            return "[CONTENT FILTERED: injection pattern detected]"
    return content
```

### Pattern 2: Tool Whitelist + Capability Tokens
Require cryptographic tokens scoped to specific tools and resources. Models cannot call unauthorized functions even if instructed by injected content.

```python
def verify_capability(tool_name: str, token: str, resource_id: str) -> bool:
    # Token must be signed and scoped to specific tool + resource
    claims = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
    return (
        claims.get("tool") == tool_name
        and claims.get("resource") == resource_id
        and claims.get("exp") > time.time()
    )
```

### Pattern 3: Second-Model Verification
Use a different LLM family to audit sensitive actions before execution. Creates an independent check using different training data and architecture.

### Pattern 4: Dual-LLM Separation
Split privileged (tool-accessing) and quarantined (untrusted-content processing) models, with narrow JSON interfaces between them. The quarantined model cannot directly invoke tools.

### Pattern 5: Human-in-the-Loop for Irreversible Actions
Require manual approval for operations that cannot be undone: fund transfers, data deletion, deployments. No automated override permitted.

### Pattern 6: Provenance Tracking + Signed Inputs
Tag all content chunks with source and trust level. Refuse tool requests from reasoning chains that touched untrusted content.

```python
class ProvenanceTracker:
    def tag(self, content: str, source: str, trust_level: str) -> dict:
        return {
            "content": content,
            "source": source,
            "trust_level": trust_level,  # "system" | "user" | "external"
            "signature": self._sign(content + source + trust_level),
        }

    def can_execute_tool(self, reasoning_chain: list) -> bool:
        # Reject if any step used external/untrusted content
        return all(
            step.get("trust_level") in ("system", "user")
            for step in reasoning_chain
        )
```
