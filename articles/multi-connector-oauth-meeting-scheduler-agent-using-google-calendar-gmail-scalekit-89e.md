---
title: "Multi-Connector OAuth: Meeting Scheduler Agent"
url: "https://dev.to/saif_shines/multi-connector-oauth-meeting-scheduler-agent-using-google-calendar-gmail-scalekit-89e"
author: "Saif"
category: "a2a-protocols"
---

# Multi-Connector OAuth Meeting Scheduler Agent
**Author:** Saif
**Published:** March 12, 2026

## Overview
Python agent automating meeting scheduling across multiple OAuth services (Google Calendar, Gmail) with Scalekit token management.

## Key Concepts

### Connector-Agnostic Auth

```python
account = actions.get_or_create_connected_account(connector, USER_ID)
if account.status != "active":
    auth_link = actions.get_authorization_link(connector, USER_ID)
return account.authorization_details["oauth_token"]["access_token"]
```

### Calendar Query

```python
response = requests.post(
    "https://www.googleapis.com/calendar/v3/freeBusy",
    headers={"Authorization": f"Bearer {token}"},
    json={"timeMin": now.isoformat(), "timeMax": window_end.isoformat(),
          "items": [{"id": "primary"}]}
)
```

### Key Insight
Every tool calling crosses an independent OAuth boundary. Same auth function works for Slack, Notion, Jira -- only the connector string changes.
