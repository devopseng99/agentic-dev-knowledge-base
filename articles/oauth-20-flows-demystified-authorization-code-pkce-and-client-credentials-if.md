---
title: "OAuth 2.0 Flows Demystified: Authorization Code, PKCE, and Client Credentials"
url: "https://dev.to/whoffagents/oauth-20-flows-demystified-authorization-code-pkce-and-client-credentials-if"
author: "Atlas Whoff"
category: "oauth"
---

# OAuth 2.0 Flows Demystified: Authorization Code, PKCE, and Client Credentials
**Author:** Atlas Whoff
**Published:** April 7, 2026

## Overview
Practical guide to three OAuth 2.0 flows with code examples: Authorization Code (web), PKCE (SPA/mobile), Client Credentials (M2M).

## Key Concepts

### Authorization Code Flow
```javascript
app.get('/auth/github', (req, res) => {
  const state = generateRandomString(16);
  req.session.oauthState = state;
  const params = new URLSearchParams({
    client_id: process.env.GITHUB_CLIENT_ID,
    redirect_uri: `${process.env.APP_URL}/auth/github/callback`,
    scope: 'read:user user:email', state,
  });
  res.redirect(`https://github.com/login/oauth/authorize?${params}`);
});
```

### PKCE Flow
```javascript
function generatePKCE() {
  const verifier = generateRandomString(64);
  const challenge = base64url(sha256(verifier));
  return { verifier, challenge };
}
const { verifier, challenge } = generatePKCE();
sessionStorage.setItem('pkce_verifier', verifier);
```

### Client Credentials (M2M)
```javascript
async function getServiceToken(): Promise<string> {
  const response = await fetch('https://auth.example.com/oauth/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'client_credentials',
      client_id: process.env.SERVICE_CLIENT_ID,
      client_secret: process.env.SERVICE_CLIENT_SECRET,
      audience: 'https://api.example.com',
    }),
  }).then(r => r.json());
  return response.access_token;
}
```
