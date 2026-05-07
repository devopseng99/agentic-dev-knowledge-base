---
title: "Building Persistent Memory for AI Agents: A pgvector + Supabase Architecture"
url: "https://dev.to/moneylab_ai/building-persistent-memory-for-ai-agents-a-pgvector-supabase-architecture-558n"
author: "moneylab"
category: "ai-agent-supabase"
---

# Building Persistent Memory for AI Agents: A pgvector + Supabase Architecture

**Author:** moneylab
**Published:** April 6, 2026

## Overview

Describes how Moneylab, an AI-operated business, built a persistent memory system called "Open Brain" using PostgreSQL with pgvector extension on Supabase, giving AI agents long-term memory across sessions.

## Key Concepts

### Database Schema (thoughts table)

- id (uuid)
- content (text)
- summary (text)
- importance (int, 1-10)
- tags (text[])
- project (text)
- embedding (vector(1536))
- parent_id (uuid)
- session_id (text)
- event_timestamp (timestamptz)

### Importance Scale System

```
importance = 10  // Core identity, constitution, critical rules
importance = 9   // Major decisions, architectural choices
importance = 7-8 // Significant events, session summaries
importance = 5-6 // Routine work, minor notes
importance = 1-4 // Ephemeral observations
```

### Superseding Stale Memories

```sql
INSERT INTO thoughts (content, parent_id, importance, tags)
VALUES (
  'Revenue strategy updated: focusing on consulting leads',
  'uuid-of-original-revenue-thought',
  8,
  ARRAY['decision', 'revenue', 'strategy']
);
```

### Search Functions

```python
# Semantic search
search_thoughts("how do we handle authentication?")
# Returns related concepts, not just keyword matches

# Keyword search
search_text("Stripe webhook")
# Returns only exact mentions
```

### Project-Scoped Query

```sql
SELECT * FROM thoughts
WHERE project = 'moneylab'
AND importance >= 7
ORDER BY created_at DESC;
```

### Key Lessons

- **Memory is not Logging** -- Focus on decisions, patterns, and relationships, not derivable information
- **Importance calibration** -- Reserve levels 7+ for memories whose loss would cause visible session mistakes
- **Temporal reasoning** -- Event timestamps enable agents to evaluate whether past decisions remain valid
- **Content quality matters** -- Search result quality depends on clarity of original thought documentation

### Implementation Steps

1. Spin up Supabase project
2. Enable vector extension
3. Create thoughts table with provided schema
4. Build wrapper functions for agent calls
5. Implement boot sequence for high-importance memory loading
