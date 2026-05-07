---
title: "PKCE Explained: Securing the OAuth 2.0 Authorization Code Flow"
url: "https://dev.to/sohillalakiya/pkce-explained-securing-the-oauth-20-authorization-code-flow-2i1o"
author: "Sohil Lalakiya"
category: "oauth"
---

# PKCE Explained: Securing the OAuth 2.0 Authorization Code Flow
**Author:** Sohil Lalakiya
**Published:** March 8, 2026

## Overview
PKCE is a security extension for OAuth 2.0 that protects authorization codes from interception by binding requests with a one-time cryptographic secret.

## Key Concepts

### How PKCE Works
- **code_verifier**: Secure random string known only to the client
- **code_challenge**: Derived via SHA256 hash encoded in Base64URL (S256 method recommended)

### Flow
1. Generate code_verifier and code_challenge
2. Send code_challenge in authorization request
3. Authorization server stores it and redirects with authorization code
4. Client sends token request with authorization code AND code_verifier
5. Server verifies `BASE64URL(SHA256(code_verifier)) == stored code_challenge`

PKCE is considered best practice for ALL OAuth clients including confidential clients.
