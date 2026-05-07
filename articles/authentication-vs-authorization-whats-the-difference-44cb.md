---
title: "Authentication vs Authorization: What's the Difference?"
url: "https://dev.to/kontext/authentication-vs-authorization-whats-the-difference-44cb"
author: "tumberger (Kontext)"
category: "oauth"
---

# Authentication vs Authorization: What's the Difference?
**Author:** tumberger (Kontext)
**Published:** May 3, 2026

## Overview
Explains the fundamental distinction: Authentication verifies identity ("Who?"), Authorization determines access ("What can they do?"). Covers OAuth 2.0 vs OpenID Connect and AI agent authorization gaps.

## Key Concepts

### Sequence
1. Credentials presented
2. Credentials verified
3. Identity established
4. Authorization layer evaluates action
5. Decision enforced

### AI Agent Context
Agents create authorization gaps. Valid credentials do not guarantee appropriate actions. Runtime authorization checks needed for sensitive operations.

### OAuth vs OpenID Connect
OAuth 2.0 is primarily an authorization framework. OpenID Connect adds an identity layer on top.
