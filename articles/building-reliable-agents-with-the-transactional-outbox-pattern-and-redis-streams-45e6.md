---
title: "Building Reliable Agents with the Transactional Outbox Pattern and Redis Streams"
url: "https://dev.to/redis/building-reliable-agents-with-the-transactional-outbox-pattern-and-redis-streams-45e6"
author: "Ricardo Ferreira"
category: "ai-agent-redis"
---

# Building Reliable Agents with the Transactional Outbox Pattern and Redis Streams

**Author:** Ricardo Ferreira
**Published:** March 27, 2026

## Overview
Addresses ensuring that business decisions made by AI agents translate into reliable downstream actions. Uses the Transactional Outbox pattern with Redis Streams to atomically commit state changes and event publications together, preventing inconsistencies when crashes occur between operations.

## Key Concepts
- State updates and event publishing committed atomically
- Redis Streams as commit log for event ordering and consumer group processing
- Hash tags for co-locating keys in the same Redis cluster slot
- Consumer groups for independent downstream processing

## Code Examples

### Redis Key Structure with Hash Tags
```java
public record SupportKeys(String caseKey, String outboxKey) {
    public static SupportKeys forCase(String tenantId, String caseId) {
        String hashTag = "{" + tenantId + "}";
        return new SupportKeys(
            "support:" + hashTag + ":case:" + caseId,
            "support:" + hashTag + ":outbox"
        );
    }
}
```

### Atomic Refund Approval (Write Path)
```java
public RefundCommitted approveRefund(RefundDecision decision) {
    SupportKeys keys = SupportKeys.forCase(decision.tenantId(), decision.caseId());

    Map<String, String> caseFields = new LinkedHashMap<>();
    caseFields.put("case_id", decision.caseId());
    caseFields.put("status", "refund_approved");
    caseFields.put("decision_source", "support-agent");

    Map<String, String> outboxFields = new LinkedHashMap<>();
    outboxFields.put("event_id", decision.eventId());
    outboxFields.put("event_type", "RefundApproved");
    outboxFields.put("case_id", decision.caseId());
    outboxFields.put("customer_id", decision.customerId());

    try (AbstractTransaction redisTx = jedis.multi()) {
        redisTx.hset(keys.caseKey(), caseFields);
        Response<StreamEntryID> streamEntryId =
            redisTx.xadd(keys.outboxKey(), StreamEntryID.NEW_ENTRY, outboxFields);

        List<Object> execResults = redisTx.exec();
        if (execResults == null) {
            throw new IllegalStateException("Refund approval transaction aborted");
        }

        return new RefundCommitted(
            decision.caseId(), decision.eventId(), streamEntryId.get().toString()
        );
    }
}
```

### Billing Consumer (Read Path)
```java
public void run(String tenantId) throws InterruptedException {
    String outboxKey = SupportKeys.forCase(tenantId, "unused").outboxKey();
    createConsumerGroup(outboxKey);

    while (!Thread.currentThread().isInterrupted()) {
        List<StreamMessage> pendingEntries = readGroup(outboxKey, PENDING_ID, 10);
        if (!pendingEntries.isEmpty()) {
            processEntries(outboxKey, pendingEntries);
            continue;
        }

        List<StreamMessage> newEntries = readGroup(outboxKey, NEW_ENTRY_ID, 10);
        if (!newEntries.isEmpty()) {
            processEntries(outboxKey, newEntries);
        } else {
            Thread.sleep(200L);
        }
    }
}

private void processEntries(String outboxKey, List<StreamMessage> entries) {
    for (StreamMessage entry : entries) {
        if (!"RefundApproved".equals(entry.fields().get("event_type"))) {
            jedis.xack(outboxKey, BILLING_GROUP_NAME, new StreamEntryID(entry.id()));
            continue;
        }
        billingGateway.issueRefund(
            entry.fields().get("refund_id"),
            entry.fields().get("customer_id"),
            entry.fields().get("event_id")
        );
        jedis.xack(outboxKey, BILLING_GROUP_NAME, new StreamEntryID(entry.id()));
    }
}
```

## Design Considerations
- Per-tenant streams provide better isolation than global outbox streams
- Multiple consumer groups allow independent processing
- Downstream workers must handle replay safely (idempotency)
- Redis becomes part of the correctness model, requiring careful replication and failover
