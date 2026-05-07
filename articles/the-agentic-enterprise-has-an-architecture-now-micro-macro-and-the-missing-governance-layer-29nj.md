---
title: "The Agentic Enterprise Has an Architecture Now: Micro, Macro, and the Missing Governance Layer"
url: "https://dev.to/itskondrat/the-agentic-enterprise-has-an-architecture-now-micro-macro-and-the-missing-governance-layer-29nj"
author: "Mykola Kondratiuk"
category: "agent-microservices"
---

# The Agentic Enterprise Has an Architecture Now: Micro, Macro, and the Missing Governance Layer

**Author:** Mykola Kondratiuk
**Published:** April 15, 2026

## Overview
A framework for enterprise AI agent architecture highlighting three components: micro agents (narrow, task-specific), macro agents (orchestration and workflow management), and a critically overlooked governance layer.

## Key Concepts

Micro agents are microservices, macro agents are orchestrators. The patterns are similar. The failure modes are too.

### Authorization Scope Configuration

```yaml
agent: onboarding-orchestrator
type: macro
authorization:
  can_access:
    - customer_profile (read)
    - onboarding_checklist (read/write)
    - notification_service (write)
  cannot_access:
    - billing_system
    - admin_settings
    - customer_communications (direct)
  escalation:
    trigger: confidence_score < 0.7
    action: queue_for_human_review
  scope_boundary:
    max_actions_per_run: 50
    timeout_minutes: 30
    requires_approval: [delete_*, modify_billing_*]
```

### The Governance Gap
The critical missing piece involves defining outcome contracts and authorization scope. Organizations often fail to establish what agents can access or when they should escalate.

### The PM-Shaped Hole
Governance decisions are fundamentally project management decisions requiring cross-functional input rather than purely engineering solutions.
