---
title: "How to Give Claude Long-Term Memory"
url: "https://dev.to/hjarni/how-to-give-claude-long-term-memory-4a6"
author: "Evert"
category: "a2a-protocols"
---

# How to Give Claude Long-Term Memory
**Author:** Evert
**Published:** March 31, 2026

## Overview
Hjarni: a note-taking app integrating with Claude via MCP to provide persistent memory across conversations.

## Key Concepts

### Setup
1. Create notes at hjarni.com about frequently discussed topics
2. In Claude Settings > Connectors, add custom connector "Hjarni" pointing to `https://hjarni.com/mcp`
3. Query naturally -- Claude searches and retrieves relevant notes automatically

### Example
Note titled "Tech Stack": "Rails 8 + SQLite. Deployed on Hetzner via Kamal."
Ask Claude "Write me a pitch based on what you know about my product" and it uses the stored context.

### Free tier: 25 notes with full MCP access
