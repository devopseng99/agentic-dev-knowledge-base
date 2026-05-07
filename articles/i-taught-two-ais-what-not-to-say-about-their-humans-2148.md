---
title: "I Taught Two AIs What Not to Say About Their Humans"
url: "https://dev.to/jasmin/i-taught-two-ais-what-not-to-say-about-their-humans-2148"
author: "Jasmin Virdi"
category: "hackathons"
---

# I Taught Two AIs What Not to Say About Their Humans
**Author:** Jasmin Virdi
**Published:** April 26, 2026

## Overview
Clawmate demonstrates two AI agents (Alice and Bob) communicating through a shared JSON file with privacy contracts enforced via markdown persona files. Built for the OpenClaw Challenge.

## Key Concepts
- Multi-agent systems with privacy contracts
- Persona files as enforcement mechanisms
- Markdown-based privacy boundaries
- Agent workspace isolation
- Filesystem-based inter-agent communication

### Bob's Privacy Contract

```markdown
## Privacy contract

### Never share
- Event names or descriptions
- Message contents from anyone
- Names of people Bob is meeting with
- Locations Bob will be at

### Do share
- Whether Bob is busy or free in a time range
- Whether Bob can be reached for an emergency

### When in doubt
Refuse, name the rule, offer what you can give.
```

### Demo Calendar Data

```json
{
  "owner": "bob",
  "events": [
    { "date": "2026-04-26", "start": "18:00", "end": "20:00", "title": "dinner with emma" },
    { "date": "2026-04-27", "start": "14:00", "end": "15:30", "title": "therapy" },
    { "date": "2026-04-28", "start": "19:00", "end": "22:00", "title": "concert" }
  ]
}
```

Key insight: "the tech doesn't enforce the privacy. The persona does." The agent reads IDENTITY.md as binding instruction before composing responses.
