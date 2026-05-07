---
title: "How to Authenticate AI Agents in B2B SaaS: Delegated Auth, Scoped Tokens, and Audit Trails"
url: "https://dev.to/sachingeek/how-to-authenticate-ai-agents-in-b2b-saas-delegated-auth-scoped-tokens-and-audit-trails-6cg"
author: "Sachin"
category: "oauth-agents"
---

# How to Authenticate AI Agents in B2B SaaS
**Author:** Sachin
**Published:** March 23, 2026

## Overview
Delegated authorization for AI agents in multi-tenant B2B SaaS using Scalekit's Agent Auth service with scoped tokens carrying user identity and org context.

## Key Concepts

### Token Structure
```json
{
  "sub": "user_01HXYZ123",
  "org_id": "org_xcorp_456",
  "scope": "notion:pages:write notion:workspace:read-specific",
  "agent_id": "agent_content_mgr",
  "auth_event_id": "authz_789",
  "iat": 1714000000,
  "exp": 1714003600
}
```

### Implementation (Python)
```python
import scalekit.client
scalekit_client = scalekit.client.ScalekitClient(
    client_id=os.getenv("SCALEKIT_CLIENT_ID"),
    client_secret=os.getenv("SCALEKIT_CLIENT_SECRET"),
    env_url=os.getenv("SCALEKIT_ENV_URL"),
)
link_response = scalekit_client.actions.get_authorization_link(
    connection_name="notion", identifier="Sachin"
)

# Get token and call API
response = scalekit_client.actions.get_connected_account(
    connection_name="notion", identifier="Sachin"
)
access_token = response.connected_account.authorization_details["oauth_token"]["access_token"]
headers = {"Authorization": f"Bearer {access_token}", "Notion-Version": "2022-06-28"}
search_response = requests.post("https://api.notion.com/v1/search", headers=headers,
    json={"filter": {"value": "page", "property": "object"}, "page_size": 1})
```

### Key Principles
- Revocation per-user without disrupting others
- Every action traces to a specific authorization event
- Token scoping as hard boundary at infrastructure layer
