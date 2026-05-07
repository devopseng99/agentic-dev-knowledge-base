---
title: "Building an Agent that respects User Permissions - With AWS Bedrock AgentCore and Entra ID"
url: "https://dev.to/sumanthprasad/building-an-agent-that-respects-user-permissions-with-aws-bedrock-agentcore-and-entra-id-10f9"
author: "Sumanth P"
category: "agent-identity"
---

# Building an Agent that respects User Permissions
**Author:** Sumanth P
**Published:** May 1, 2026

## Overview
Uses On-Behalf-Of (OBO) token exchange with AgentCore Identity to convert user auth tokens into downstream-scoped tokens, preserving user identity and permissions throughout the call chain.

## Key Concepts

### AgentCore Setup

```bash
aws bedrock-agentcore-control create-oauth2-credential-provider \
  --cli-input-json '{
    "name": "EntraIdServiceNow",
    "credentialProviderVendor": "CustomOauth2",
    "oauth2ProviderConfigInput": {
      "customOauth2ProviderConfig": {
        "oauthDiscovery": {
          "discoveryUrl": "https://login.microsoftonline.com/YOUR_TENANT_ID/v2.0/.well-known/openid-configuration"
        },
        "clientId": "YOUR_AGENT_APP_CLIENT_ID",
        "clientSecret": "YOUR_AGENT_APP_CLIENT_SECRET",
        "onBehalfOfTokenExchangeConfig": {
          "grantType": "JWT_AUTHORIZATION_GRANT"
        }
      }
    }
  }'
```

### Agent Implementation (Python)

```python
from strands import Agent, tool
from bedrock_agentcore.runtime import BedrockAgentCoreApp, BedrockAgentCoreContext
from bedrock_agentcore.services.identity import IdentityClient

identity_client = IdentityClient(region=AWS_REGION)

async def fetch_snow_token() -> None:
    workload_token = BedrockAgentCoreContext.get_workload_access_token()
    token_b = await identity_client.get_token(
        provider_name="EntraIdServiceNow",
        scopes=["api://YOUR_API_CONNECTOR_CLIENT_ID/user_impersonation"],
        agent_identity_token=workload_token,
        auth_flow="ON_BEHALF_OF_TOKEN_EXCHANGE",
    )
    snow_token_var.set(token_b)

@tool
def query_incidents(query: str = "", limit: int = 10) -> str:
    return json.dumps(snow_request("GET", "table/incident", params={
        "sysparm_query": query, "sysparm_limit": limit,
    }), indent=2)
```

### Deployment
```bash
agentcore deploy -y \
  --env SNOW_INSTANCE_URL=https://YOUR_INSTANCE.service-now.com \
  --env MODEL_ID=us.anthropic.claude-sonnet-4-20250514-v1:0
```
