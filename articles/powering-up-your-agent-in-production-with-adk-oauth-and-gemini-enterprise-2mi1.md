---
title: "Powering Up Your Agent in Production with ADK, OAuth and Gemini Enterprise"
url: "https://dev.to/fmind/powering-up-your-agent-in-production-with-adk-oauth-and-gemini-enterprise-2mi1"
author: "Mederic Hurier (Fmind)"
category: "google-adk"
---

# Powering Up Your Agent in Production with ADK, OAuth and Gemini Enterprise

**Author:** Mederic Hurier (Fmind)
**Published:** February 6, 2026
**Original Source:** fmind.Medium (November 1, 2025)
**Tags:** #artificialintelligence #generativeaitools #agents #googlecloudplatform

---

## Overview

The article documents the journey of converting a Jupyter notebook prototype into a production-ready AI agent. The author demonstrates how leveraging the Agent Development Kit (ADK), OAuth 2.0, and Gemini Enterprise can accelerate deployment while maintaining security and scalability.

## Key Problem Statement

The author argues that infrastructure and tooling choices significantly impact agent deployment speed. Building custom UIs and managing authentication flows creates bottlenecks. The article references previous work stating: "The Real AI Agent Bottleneck is the Damn UI," highlighting how proper tooling selection eliminates these constraints.

## Solution Architecture

The implementation follows a multi-stage workflow:

1. **Local Development** - Using ADK and the ADK Web UI
2. **Deployment** - To Vertex AI Agent Engine on Google Cloud
3. **Production Access** - Through Gemini Enterprise Web UI
4. **Execution** - Managed by the Agent Engine with OAuth security

## OAuth Implementation

OAuth 2.0 provides the security foundation, enabling users to grant specific permissions without sharing credentials. The agent can access:
- Google Drive API (presentation copying)
- Google Slides API (content reading/writing)

### Authentication Configuration

The OAuth setup requires registering an OAuth Client ID in the Google Cloud Console with authorized redirect URIs:

- **Development:** `localhost` (ADK Web UI testing)
- **Production:** `https://vertexaisearch.cloud.google.com/oauth-redirect`

## Code Implementation

### Authentication Setup

```python
from fastapi.openapi.models import OAuth2, OAuthFlowAuthorizationCode, OAuthFlows
from google.adk.auth.auth_credential import AuthCredential, AuthCredentialTypes, OAuth2Auth
from google.adk.auth.auth_tool import AuthConfig

AUTHORIZATION_URL = "https://accounts.google.com/o/oauth2/auth"
TOKEN_URL = "https://oauth2.googleapis.com/token"
SCOPES = {
    "https://www.googleapis.com/auth/drive": "Google Drive API",
    "https://www.googleapis.com/auth/presentations": "Google Slides API",
}

AUTH_SCHEME = OAuth2(
    flows=OAuthFlows(
        authorizationCode=OAuthFlowAuthorizationCode(
            authorizationUrl=AUTHORIZATION_URL,
            tokenUrl=TOKEN_URL,
            scopes=SCOPES,
        )
    )
)
```

### Credential Negotiation

```python
def negotiate_creds(tool_context: ToolContext) -> Credentials | dict:
    """Handle the OAuth 2.0 flow to get valid credentials."""
    if cached_token := tool_context.state.get(configs.TOKEN_CACHE_KEY):
        if isinstance(cached_token, dict):
            creds = Credentials.from_authorized_user_info(
                cached_token, list(auths.SCOPES.keys())
            )
            if creds.valid:
                return creds
            if creds.expired and creds.refresh_token:
                creds.refresh(Request())
                tool_context.state[configs.TOKEN_CACHE_KEY] = json.loads(creds.to_json())
                return creds

    if exchanged_creds := tool_context.get_auth_response(auths.AUTH_CONFIG):
        creds = Credentials(
            token=exchanged_creds.oauth2.access_token,
            refresh_token=exchanged_creds.oauth2.refresh_token,
            token_uri=auth_scheme.flows.authorizationCode.tokenUrl,
            client_id=auth_credential.oauth2.client_id,
            client_secret=auth_credential.oauth2.client_secret,
            scopes=list(auth_scheme.flows.authorizationCode.scopes.keys()),
        )
        tool_context.state[configs.TOKEN_CACHE_KEY] = json.loads(creds.to_json())
        return creds

    tool_context.request_credential(auths.AUTH_CONFIG)
    return {"pending": True, "message": "Awaiting user authentication"}
```

## Production Deployment

### Authentication Configuration Command

```bash
./as.py create-auth \
  --auth-id slides-translator-auth \
  --client-id ... \
  --client-secret ... \
  --auth-uri "https://accounts.google.com/o/oauth2/auth?include_granted_scopes=true&response_type=code&access_type=offline&prompt=consent" \
  --token-uri "https://oauth2.googleapis.com/token" \
  --scope "https://www.googleapis.com/auth/drive" \
  --scope "https://www.googleapis.com/auth/presentations"
```

## Gemini Enterprise Advantages

Deploying via Gemini Enterprise eliminates traditional UI bottlenecks:

- **Zero-effort interface** - No separate frontend application needed
- **Built-in observability** - Automatic tracing and logging through Agent Engine
- **Enterprise security** - Integrated within Google Cloud security infrastructure
- **Seamless integration** - Users interact directly within the Gemini interface

## Key Takeaways

1. **Proper tooling accelerates deployment** - ADK handles complex OAuth flows seamlessly
2. **Security by design** - OAuth 2.0 provides granular permission control without password sharing
3. **Reduced infrastructure burden** - Gemini Enterprise eliminates custom UI development
4. **Production readiness** - From notebook to enterprise agent with minimal architectural work

## Resources

**GitHub Repository:** [slides-translator-agent](https://github.com/fmind/slides-translator-agent)
