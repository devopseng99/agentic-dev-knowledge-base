---
title: "An Autonomous, Agentic, AI Assistant: Meet Alfred and This Is How I Built Him"
url: "https://dev.to/joojodontoh/an-autonomous-agentic-ai-assistant-meet-alfred-and-this-is-how-i-built-him-4e7m"
author: "JOOJO DONTOH"
category: "ai-agents-autonomous-assistant"
---

# An Autonomous, Agentic, AI Assistant: Meet Alfred

**Author:** JOOJO DONTOH
**Date Published:** March 16, 2026
**Tags:** #agents #ai #productivity #showdev

---

## Overview

This comprehensive article chronicles the design and implementation of Alfred, a personal AI assistant that unifies email management, calendar coordination, financial tracking, and work management across multiple platforms through an agentic architecture.

## Problem Statement

The author describes the "Monday Morning Problem"—the cognitive overhead of managing fragmented digital systems (Gmail, Outlook, Teams, Azure DevOps, calendars) without unified context. Before Alfred, each morning involved manual triage across platforms lasting 45-60 minutes, consuming time before actual work could begin.

## Core Architecture

### Key Components

**Email Pipeline:**
- Polls Gmail continuously; receives Outlook via Power Automate webhooks
- Persists to SQLite with deduplication via `INSERT ... ON CONFLICT` patterns
- AI classification assigns urgency levels, categories, and generates summaries
- Configurable rules engine proposes actions (archive, delete, forward, draft, notify)

**Action Lifecycle:**
The system enforces event-sourced action tracking:

> "Every state transition is recorded as an append-only entry in action log"

States: Proposed -> Approved -> Executed (or Rejected/RolledBack)

Low-risk actions (classify, draft) execute automatically; high-risk actions (delete, send) require dashboard approval.

**Integration Architecture:**
- Google Calendar and Outlook Calendar (list, create, update, search)
- Azure DevOps (work items, PR approval, pipeline tracking)
- Microsoft Teams (channel search, webhook ingestion)
- Gmail and Outlook email management

### Chat System: Two Modes

The author evolved from intent extraction to Claude's native tool-use API:

**Intent Extraction Mode:**
- Fast LLM (Haiku) extracts structured intents from natural language
- Maps intents to registered tools in up to 5 reasoning rounds
- Final response composed by main model (Sonnet)

**Tool-Use Mode:**
- Claude directly receives tool definitions and decides which to call
- Maintains conversation across 5 rounds until reaching `end_turn`
- More reliable routing but higher token cost

Both strategies implement the `ChatStrategy` interface and share the `ToolRegistry` for consistent capability exposure.

---

## Data Integrity Patterns

### Idempotency & Upserts

```sql
INSERT INTO emails (id, thread_id, from_address, ..., updated_at)
VALUES (@id, @threadId, @from, ..., datetime('now'))
ON CONFLICT(id) DO UPDATE SET
  thread_id = excluded.thread_id,
  from_address = excluded.from_address,
  updated_at = datetime('now')
```

### Append-Only Action Logs

"No rows are ever updated in place or deleted" to maintain full audit trails of action lifecycle from proposal through execution.

### Normalized Schema

Classifications stored separately from emails, enabling re-classification without corrupting original data.

---

## Financial Statement Processing

A six-stage pipeline automatically processes bank statements:

1. Search Gmail for bank sender addresses
2. Validate unprocessed PDFs (idempotency check)
3. Download and decrypt password-protected statements
4. Extract transactions using bank-specific parsers
5. Hybrid classification: keyword matching + Claude Haiku for ambiguous cases
6. Normalize to unified schema across multiple banks

**Key Discovery:** The system handles 12-month historical backfill with cursor tracking across restarts, enabling retroactive data processing.

---

## Deployment & Operations

**Three launchd Services:**
- Agent server (Node.js, polls, classifies, executes actions)
- Next.js dashboard (pure client-side, all data via HTTP API)
- Cloudflare tunnel (encrypted outbound connection)

**Credential Management:**
macOS Keychain stores OAuth credentials; never in environment variables or logs.

**Deployment Script Flow:**
```
log directory -> npm install -> npm run build -> plist substitution -> launchctl load
```

---

## Key Architectural Insights

### From Intent Extraction to Tool Use

The author initially built custom JSON-based intent routing with extensive system prompts. By 15 intents, the routing prompt became unwieldy and unreliable. Switching to Claude's native tool-use dramatically improved consistency while adding token overhead.

### Multi-Round Reasoning

Early single-pass approaches missed details. Multi-round loops enable:
- Round 1: Search calendar for tomorrow's events
- Round 2: Use event ID to add attendee

Prior results fed back in context allow the LLM to determine when sufficient data is gathered.

### Cost Optimization

- Haiku for intent extraction or mechanical tasks
- Sonnet for response composition with extended thinking
- In-memory TTL cache (3-minute window) for calendar/DevOps queries
- Circuit breaker pattern for classifier failures

---

## Major Features

### Push Notifications
Service worker + Web Push API enables proactive alerts rather than pull-based checking. System uses VAPID keys for authentication, automatic cleanup of expired subscriptions, and window reuse to prevent duplicate tabs.

### Progressive Web App
Converting to PWA created presence—an installable app with dock icon rather than a disposable browser tab, increasing engagement and daily usage.

### Bank Statement Integration
Processes statements from multiple banks with hybrid classification, enabling conversational financial queries like "how much did I spend on food last month?"

---

## Future Roadmap

- **RAG for Personal Knowledge:** Index published articles, tweets, and notes to ground responses in the author's voice
- **WhatsApp & LinkedIn Integration:** Message search, relationship nudging with contextual awareness
- **Smart Home Control:** Apple Shortcuts bridge for HomeKit, robot vacuum status monitoring
- **Second Persona:** Replicate architecture for a different user with distinct character

---

## Key Takeaways

> "The biggest lesson was not technical... Clean Architecture is the reason I was able to bolt on Microsoft Teams notifications... without rewriting the core."

**Core Principle:** Invest early in boundaries (dependency direction, boring domain layer) rather than features. This enables sustainable feature addition without fragility.

The author emphasizes that running everything locally on macOS with Cloudflare Tunnel avoids cloud costs and keeps personal data private—a requirement when handling emails, calendars, and financial data.

**Final Insight:** The most powerful personal software evolves without breaking what already works, enabled by disciplined architectural boundaries.
