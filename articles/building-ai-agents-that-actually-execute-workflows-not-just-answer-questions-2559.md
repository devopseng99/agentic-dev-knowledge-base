---
title: "Building AI Agents That Actually Execute Workflows, Not Just Answer Questions"
url: "https://dev.to/tactasai/building-ai-agents-that-actually-execute-workflows-not-just-answer-questions-2559"
author: "Daniel R. Foster"
category: "LLM agent evaluation"
---

# Building AI Agents That Actually Execute Workflows, Not Just Answer Questions

**Author:** Daniel R. Foster (Tactas AI)
**Published:** May 7, 2026

## Overview
Distinguishes between conversational chatbots and operational workflow agents. While chatbots answer questions, workflow agents must safely execute business processes across multiple systems, enforcing rules and maintaining audit trails. Key insight: "Tool calling is not workflow automation."

## Key Concepts

### Chatbot vs Workflow Agent
- Chatbot: User -> LLM -> Response
- Workflow Agent: Trigger -> Intent classification -> Context retrieval -> Policy evaluation -> Risk scoring -> Action planning -> Permission check -> Tool execution -> State update -> Audit log -> Potential human approval

### Refund Tool Definition

```typescript
type RefundCustomerInput = {
  customerId: string;
  orderId: string;
  amount: number;
  reason: string;
};

async function refundCustomer(input: RefundCustomerInput) {
  // Create refund through payment provider
}
```

### Business Rules as YAML Configuration

```yaml
refund_policy:
  auto_approve:
    max_amount_usd: 100
    within_days: 14
    customer_risk_score_below: 0.35
  require_human_approval:
    amount_above_usd: 100
    customer_has_prior_refunds: true
    fraud_signal_detected: true
    open_chargeback: true
  never_refund_automatically:
    product_type:
      - enterprise_contract
      - custom_service
    account_status:
      - suspended_for_abuse
```

### Workflow Execution Example

```json
{
  "workflow": "duplicate_payment_refund",
  "ticket_id": "TCK-48291",
  "customer_id": "cus_10928",
  "detected_intent": "billing_duplicate_charge",
  "confidence": 0.91,
  "retrieved_context": {
    "invoices_found": 2,
    "duplicate_payment_detected": true,
    "payment_provider": "stripe",
    "amount_usd": 49
  },
  "policy_result": {
    "auto_refund_allowed": true,
    "requires_approval": false,
    "reason": "Duplicate charge confirmed; amount below threshold"
  },
  "planned_actions": [
    "create_refund",
    "add_ticket_note",
    "send_customer_reply",
    "close_ticket"
  ]
}
```

### Audit Log Example

```json
{
  "event": "refund_created",
  "workflow_id": "wf_78321",
  "actor": "ai_agent:support_refund_agent",
  "human_approver": null,
  "customer_id": "cus_10928",
  "amount_usd": 49,
  "policy_version": "refund_policy_v3",
  "reason": "duplicate_payment_confirmed",
  "tool_called": "stripe.refunds.create",
  "external_reference": "re_12345",
  "timestamp": "2026-05-07T10:24:18Z"
}
```

### Critical Design Principles
1. Business rules live outside the LLM where possible
2. Workflow state (not just chat history) tracks completed steps and recovery points
3. Human approval gates for high-risk actions
4. Scoped permissions per agent
5. Explicit failure handling -- never generate confident guesses
