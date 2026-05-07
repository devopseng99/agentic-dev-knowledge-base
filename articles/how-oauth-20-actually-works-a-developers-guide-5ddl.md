---
title: "How OAuth 2.0 Actually Works - A Developer's Guide"
url: "https://dev.to/tyson_cung/how-oauth-20-actually-works-a-developers-guide-5ddl"
author: "Tyson Cung"
category: "oauth"
---

# How OAuth 2.0 Actually Works - A Developer's Guide
**Author:** Tyson Cung
**Published:** April 2, 2026

## Overview
Conceptual guide to OAuth 2.0 covering the problem it solved (password sharing), the four players, authorization code flow, tokens, scopes, PKCE, and common mistakes.

## Key Concepts

### The Four Players
1. Resource Owner (user)
2. Client (application)
3. Authorization Server (identity provider)
4. Resource Server (API)

### Authorization Code Flow
App redirects to auth server -> User authenticates -> Server returns authorization code -> Backend exchanges code + client secret for tokens -> App uses access token for API calls.

### PKCE for Mobile/SPA
Generate random code_verifier, hash it to code_challenge, include hash in auth request, send original during token exchange. OAuth 2.1 requires PKCE for all clients.

### Common Mistakes
1. localStorage token storage (XSS vulnerable)
2. Skipping state parameter (CSRF risk)
3. Overly broad scopes
4. Ignoring token expiration
5. Using implicit flow (deprecated)
