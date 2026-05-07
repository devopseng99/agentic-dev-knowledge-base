---
title: "OAuth 2.1 is Here: What You Need to Know"
url: "https://dev.to/logto/oauth-21-is-here-what-you-need-to-know-28b8"
author: "Palomino"
category: "oauth"
---

# OAuth 2.1 is Here: What You Need to Know
**Author:** Palomino
**Published:** June 21, 2024

## Overview
Since OAuth 2.0's 2012 release, the shift toward mobile devices and SPAs has created new security challenges. OAuth 2.1 consolidates best practices and security recommendations into a unified specification.

## Key Concepts

### PKCE is Now Required for All Clients
PKCE becomes mandatory in OAuth 2.1 for all Authorization Code flow clients, both confidential and public. SPAs and mobile apps requiring code challenges will have requests lacking them rejected.

### Redirect URIs Exact Matching
Exact string matching ensures the Redirect URI registered with the server matches precisely. Any deviation risks code or token leakage.

### The Implicit Flow is Deprecated
The implicit grant flow returns access tokens directly in URL fragments. Tokens can be exposed through browser history, referrer headers, or interception. The Authorization Code flow with PKCE is required instead.

### The ROPC Grant is Deprecated
The ROPC grant exposes user credentials to client applications. OAuth 2.1 removes it entirely. Organizations should migrate to the Authorization Code flow or client credentials grant.
