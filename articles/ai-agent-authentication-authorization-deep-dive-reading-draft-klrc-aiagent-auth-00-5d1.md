---
title: "AI Agent Authentication & Authorization Deep Dive: Reading draft-klrc-aiagent-auth-00"
url: "https://dev.to/kanywst/ai-agent-authentication-authorization-deep-dive-reading-draft-klrc-aiagent-auth-00-5d1"
author: "kt"
category: "ai-agent-authentication-authorization"
---

# AI Agent Authentication & Authorization Deep Dive

**Author:** kt
**Published:** March 14, 2026

## Overview
Analysis of IETF Internet-Draft `draft-klrc-aiagent-auth-00` from engineers at Defakto Security, AWS, Zscaler, and Ping Identity. Core thesis: no new authentication protocol needed -- properly composing existing standards (WIMSE, SPIFFE, OAuth 2.0) is sufficient.

## Key Concepts

### Agent Identity Management System (AIMS) - Five Layers
1. **Identifier** - WIMSE/SPIFFE URIs for workload identity
2. **Credentials** - Short-lived X.509 certs or JWTs with cryptographic binding
3. **Attestation** - Evidence proving agent identity before credential issuance
4. **Provisioning** - Dynamic delivery with automatic rotation
5. **Authentication** - mTLS at transport; WIMSE tokens at application layer

### Authorization via OAuth 2.0
Three scenarios:
- User delegation
- Agent self-authorization
- Agent-as-resource-server

### Key Principles
- Static API keys explicitly rejected
- Short-lived credentials enable revocation without explicit mechanisms
- Transaction tokens limit propagation risk in microservice chains
- Opaque tokens with introspection minimize PII exposure

### Cross-Domain Patterns
- OAuth Identity and Authorization Chaining
- Identity Assertion JWT Authorization Grants
- OpenID CIBA for human-in-the-loop approval

### Standards Composed
RFC 6749 (OAuth), RFC 8693 (Token Exchange), RFC 9068 (JWT Profile), RFC 9421 (HTTP Signatures), RFC 9700 (Security BCP), WIMSE specifications.
