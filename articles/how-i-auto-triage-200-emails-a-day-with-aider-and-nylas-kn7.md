---
title: "How I auto-triage 200 emails a day with Aider and Nylas"
url: "https://dev.to/qasim157/how-i-auto-triage-200-emails-a-day-with-aider-and-nylas-kn7"
author: "Qasim Muhammad"
category: "ai-agent-email-automation"
---

# How I auto-triage 200 emails a day with Aider and Nylas

**Author:** Qasim Muhammad
**Published:** May 4, 2026

## Overview

A lightweight email triage system using Aider (CLI LLM tool) and Nylas CLI to classify 200 daily emails into ACTION/SKIM/DROP buckets, saving ~35 minutes daily with >95% accuracy.

## Key Concepts

### Triage Buckets

| Bucket | Action | Contents |
|--------|--------|----------|
| ACTION | Star, leave unread | Customer escalations, oncall alerts, CEO mail |
| SKIM | Mark read, archive | Newsletters, build notifications |
| DROP | Mark read, archive, spam | Cold sales, recruiter spam, marketing |

### The Script

```python
# /opt/triage/triage.py
import json
import subprocess
import sys

def llm_classify(subject: str, snippet: str, sender: str) -> str:
    prompt = f"""Classify this email into one of: ACTION, SKIM, DROP.
ACTION: needs my response or attention soon.
SKIM: informational, can wait.
DROP: spam, recruiter, marketing, newsletter.

From: {sender}
Subject: {subject}
Snippet: {snippet}

Reply with only one word."""
    out = subprocess.run(
        ["aider", "--message", prompt, "--no-auto-commits", "--yes-always"],
        capture_output=True, text=True, timeout=30
    )
    label = out.stdout.strip().split()[-1].upper()
    return label if label in ("ACTION", "SKIM", "DROP") else "SKIM"

def main():
    raw = subprocess.check_output(
        ["nylas", "email", "list", "--unread", "--limit", "50", "--json"]
    )
    msgs = json.loads(raw)
    for m in msgs:
        sender = m["from"][0]["email"]
        bucket = llm_classify(m["subject"], m.get("snippet", ""), sender)
        if bucket == "ACTION":
            subprocess.run(["nylas", "email", "mark-starred", m["id"]])
        elif bucket == "SKIM":
            subprocess.run(["nylas", "email", "mark-read", m["id"]])
        elif bucket == "DROP":
            subprocess.run(["nylas", "email", "mark-read", m["id"]])
            subprocess.run(["nylas", "email", "delete", m["id"], "--yes"])
        print(f"{bucket}: {m['subject'][:60]}")

if __name__ == "__main__":
    main()
```

### Cron Execution

```bash
# Every 5 minutes
*/5 * * * * /usr/bin/python3 /opt/triage/triage.py >> /var/log/triage.log 2>&1
```

Each LLM call ~2 seconds; 50 messages ~100 seconds.

### Starter Prompt

```
Classify this email into one of: ACTION, SKIM, DROP.

ACTION = something I personally need to do or reply to within 24 hours.
SKIM = useful but not urgent.
DROP = spam, sales outreach, recruiters, marketing, automated
build/deploy notifications.

If unsure, prefer ACTION (false positive is cheap; false negative
is expensive).
```

### Results (60 days)

- Time saved: ~35 minutes daily
- False positives: 4 instances
- Key tuning insight: bias toward ACTION -- "false positive is cheap; false negative is expensive"
