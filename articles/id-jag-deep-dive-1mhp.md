---
title: "ID-JAG Deep Dive"
url: "https://dev.to/kanywst/id-jag-deep-dive-1mhp"
author: "kt"
category: "oauth-agents"
---

# ID-JAG Deep Dive
**Author:** kt
**Published:** March 16, 2026

## Overview
Identity Assertion JWT Authorization Grant (ID-JAG) is the IETF's new approach to secure cross-domain API access by extending existing SSO trust relationships. Critical for AI agent authentication.

## Key Concepts

### Token Exchange Request (Getting the ID-JAG)
```
POST /oauth2/token HTTP/1.1
Host: acme.idp.example
Content-Type: application/x-www-form-urlencoded

grant_type=urn:ietf:params:oauth:grant-type:token-exchange
&requested_token_type=urn:ietf:params:oauth:token-type:id-jag
&audience=https://acme.chat.example/
&resource=https://api.chat.example/
&scope=chat.read+chat.history
&subject_token=eyJraWQiOi...
&subject_token_type=urn:ietf:params:oauth:token-type:id_token
```

### Inside the ID-JAG JWT
```json
{
  "alg": "ES256",
  "typ": "oauth-id-jag+jwt"
}
{
  "iss": "https://acme.idp.example/",
  "sub": "U019488227",
  "aud": "https://acme.chat.example/",
  "client_id": "f53f191f9311af35",
  "resource": "https://api.chat.example/",
  "scope": "chat.read chat.history",
  "amr": ["mfa", "phrh", "hwk", "user"]
}
```

### ID Token vs ID-JAG
- ID Token says "this user is authentic" (to the Client)
- ID-JAG says "this Client is allowed to access the API on behalf of this user" (to the Resource AS)

### AI Agent Use Case
Agent dynamically discovers auth via `WWW-Authenticate` header with Protected Resource Metadata URL. If IdP metadata includes `identity_chaining_requested_token_types_supported`, ID-JAG support is auto-detected.

### DPoP Support (Draft-02)
Sender-constrained tokens bind to specific clients. Only the client with the corresponding private key can use the token.

### RFC Stack
RFC 8693 (Token Exchange), RFC 7523 (JWT Bearer Grant), OpenID Connect, RFC 8414 (AS Metadata), RFC 9728 (Protected Resource Metadata), RFC 9396 (RAR), RFC 9449 (DPoP).
