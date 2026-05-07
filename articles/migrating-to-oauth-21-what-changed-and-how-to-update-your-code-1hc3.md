---
title: "Migrating to OAuth 2.1: What changed and how to update your code"
url: "https://dev.to/saif_shines/migrating-to-oauth-21-what-changed-and-how-to-update-your-code-1hc3"
author: "Saif"
category: "oauth"
---

# Migrating to OAuth 2.1: What changed and how to update your code
**Author:** Saif
**Published:** May 28, 2025

## Overview
Practical guide to OAuth 2.1 migration, covering code changes needed to eliminate implicit flow and adopt PKCE universally.

## Key Concepts

### PKCE Challenge Generation

```javascript
const codeVerifier = crypto.randomBytes(32).toString('hex');

async function generateCodeChallenge(verifier) {
  const digest = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(verifier));
  return btoa(String.fromCharCode(...new Uint8Array(digest)))
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=+$/, '');
}
const codeChallenge = await generateCodeChallenge(codeVerifier);
```

### Redirect URI Validation

```javascript
const allowedRedirectUris = ['https://app.example.com/callback'];
function validateRedirectUri(uri) {
  return allowedRedirectUris.includes(uri);
}
```

### Key Recommendations
- Implement PKCE universally, even for public clients
- Enable refresh token rotation with reuse detection
- Use strict, exact redirect URI matching
- Maintain precise scopes for token permissions
