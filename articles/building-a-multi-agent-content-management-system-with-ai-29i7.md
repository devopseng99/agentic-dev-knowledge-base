---
title: "Building a Multi-Agent Content Management System with AI"
url: "https://dev.to/pavel_polivka/building-a-multi-agent-content-management-system-with-ai-29i7"
author: "Pavel Polivka"
category: "full-code-examples"
---

# Building a Multi-Agent Content Management System with AI
**Author:** Pavel Polivka
**Published:** April 13, 2026

## Overview
Multi-agent orchestration system for managing content workflows across LinkedIn, BlueSky, and DEV.to. Uses specialized AI agents coordinating around a task management layer with atomic locking and heartbeat patterns.

## Key Concepts

### Agent Roles
- Discovery Agent: identifies trending topics
- Content Writer: drafts initial content
- Content Manager: orchestrates publishing schedules
- Brand Strategist: reviews content for brand alignment

### Heartbeat Pattern -- Checkout and Update

```shell
# Checkout (atomic lock)
curl -s -X POST -H "Authorization: Bearer $API_KEY" \
  -H "X-Run-Id: $RUN_ID" \
  "$API_URL/api/issues/$ISSUE_ID/checkout"

# Do the work
# ... agent-specific logic here ...

# Update status
curl -s -X PATCH -H "Authorization: Bearer $API_KEY" \
  -H "X-Run-Id: $RUN_ID" \
  -d '{"status": "done", "comment": "..."}' \
  "$API_URL/api/issues/$ISSUE_ID"
```

### BlueSky Publishing via AT Protocol

```shell
# Authenticate with BlueSky
AUTH=$(curl -s -X POST "https://bsky.social/xrpc/com.atproto.server.createSession" \
  -H "Content-Type: application/json" \
  -d "{\"identifier\": \"$BSKY_IDENTIFIER\", \"password\": \"$BSKY_APP_PASSWORD\"}")

ACCESS_JWT=$(echo "$AUTH" | python3 -c "import sys,json; print(json.load(sys.stdin)['accessJwt'])")
DID=$(echo "$AUTH" | python3 -c "import sys,json; print(json.load(sys.stdin)['did'])")

# Create the post
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")

curl -s -X POST "https://bsky.social/xrpc/com.atproto.repo.createRecord" \
  -H "Authorization: Bearer $ACCESS_JWT" \
  -H "Content-Type: application/json" \
  -d "{
    \"repo\": \"$DID\",
    \"collection\": \"app.bsky.feed.post\",
    \"record\": {
      \"\$type\": \"app.bsky.feed.post\",
      \"text\": \"$POST_TEXT\",
      \"createdAt\": \"$TIMESTAMP\"
    }
  }"
```

### Content Length Validation (BlueSky 300 grapheme limit)

```python
import unicodedata
text = "your post text"
grapheme_count = len(list(text))
if grapheme_count > 300:
    # Truncate or split into thread
```

### Concurrency Control

```json
{
  "title": "Daily content reminder",
  "cronExpression": "30 8 * * *",
  "concurrencyPolicy": "skip_if_active"
}
```

### Core Principles
1. Clear task specifications -- "Agents are APIs for work"
2. Visibility over autonomy
3. Boring technology -- PostgreSQL and REST APIs for orchestration; LLMs for writing and reasoning
