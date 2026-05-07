---
title: "OAuth 2.0 Explained: From Authorization Codes to PKCE (The Complete Picture)"
url: "https://dev.to/tyson_cung/oauth-20-explained-from-authorization-codes-to-pkce-the-complete-picture-36b7"
author: "Tyson Cung"
category: "oauth"
---

# OAuth 2.0 Explained: From Authorization Codes to PKCE (The Complete Picture)
**Author:** Tyson Cung
**Published:** March 28, 2026

## Overview
A comprehensive conceptual guide explaining OAuth 2.0 mechanics, the authorization code flow, PKCE, token types, and the distinction between OAuth and OpenID Connect.

## Key Concepts

### The Four Actors
- **Resource Owner** -- The user who owns the data
- **Client** -- The application requesting data access
- **Authorization Server** -- Issues tokens after permission is granted
- **Resource Server** -- The API containing user data

### Authorization Code Flow
1. App redirects to authorization server with client ID, scopes, redirect URI, and state parameter
2. User authenticates and grants consent
3. Authorization server redirects back with a short-lived authorization code
4. App exchanges the code for tokens server-to-server using the client secret
5. App uses the access token in API calls via the Authorization header

### PKCE: Fixing the Gap for Public Clients
Client generates a random code_verifier and computes its SHA-256 hash (code_challenge). During auth request, client sends the code_challenge. During token exchange, client sends the original code_verifier. Auth server hashes it and verifies. OAuth 2.1 mandates PKCE for all clients.

### Common Mistakes
1. Storing tokens in localStorage (vulnerable to XSS)
2. Overly broad scopes
3. Skipping state parameter validation
4. Using access tokens as identity proof (use OIDC ID tokens instead)
