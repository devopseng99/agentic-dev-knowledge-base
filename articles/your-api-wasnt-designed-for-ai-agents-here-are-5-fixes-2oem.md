---
title: "Your API Wasn't Designed for AI Agents. Here Are 5 Fixes."
url: "https://dev.to/klement_gunndu/your-api-wasnt-designed-for-ai-agents-here-are-5-fixes-2oem"
author: "klement Gunndu"
category: "agent-error-handling-retry"
---

# Your API Wasn't Designed for AI Agents. Here Are 5 Fixes.

**Author:** klement Gunndu
**Published:** March 25, 2026

## Overview

Five patterns to make APIs agent-ready. Core principle: "make the implicit explicit." Humans infer context; agents operate on explicit API signals.

## Key Concepts

### 1. Machine-Readable Descriptions in OpenAPI Specs

```python
from fastapi import FastAPI
from pydantic import BaseModel, Field

app = FastAPI(
    title="Order Management API",
    description="Manages customer orders. All monetary values are in USD cents.",
)

class OrderCreate(BaseModel):
    """Create a new order. Does NOT charge the customer.
    Use POST /orders/{order_id}/confirm to finalize and charge."""
    customer_id: str = Field(
        description="Unique customer identifier. Format: cust_xxxxxxxxxxxx"
    )
    items: list[str] = Field(
        description="List of SKU strings. Each SKU must exist in the product catalog."
    )
    amount_cents: int = Field(
        description="Total order amount in USD cents. Must match sum of item prices.",
        ge=1,
    )
```

### 2. Idempotency Keys for Safe Retries

```python
@app.post("/payments")
async def create_payment(
    amount_cents: int,
    customer_id: str,
    response: Response,
    idempotency_key: Optional[str] = Header(None, alias="Idempotency-Key"),
):
    if idempotency_key is None:
        raise HTTPException(
            status_code=400,
            detail={
                "error": "idempotency_key_required",
                "message": "POST /payments requires an Idempotency-Key header.",
            },
        )
    if idempotency_key in idempotency_store:
        cached = idempotency_store[idempotency_key]
        response.headers["X-Idempotent-Replayed"] = "true"
        return cached["response"]
    # Process and cache...
```

### 3. Structured Error Responses

```python
class APIError(BaseModel):
    error_code: str
    message: str
    retryable: bool
    retry_after_seconds: int | None = None
    suggestion: str | None = None

ERROR_CATALOG = {
    "insufficient_funds": APIError(
        error_code="insufficient_funds",
        message="Customer balance is below the requested amount.",
        retryable=False,
        suggestion="Reduce the amount or add funds via POST /customers/{id}/balance",
    ),
    "rate_limited": APIError(
        error_code="rate_limited",
        message="Too many requests. Slow down.",
        retryable=True,
        retry_after_seconds=30,
        suggestion="Wait for retry_after_seconds, then retry the same request.",
    ),
}
```

### 4. Confirmation Endpoints for Destructive Actions

Two-step process: preview (read-only) then confirm (with token). Tokens expire after 5 minutes. Prevents agents from accidentally executing destructive operations.

### 5. Rate Limiting With Retry-After Headers

Essential headers: `Retry-After`, `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`.

### Implementation Priority
1. Start with structured errors and rate limit headers (minimal refactoring)
2. Add idempotency keys for mutations and payments
3. Finally add confirmation patterns for high-risk operations
