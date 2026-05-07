---
title: "OAuth 2.1 Is Here: What Changed, What's Deprecated, and How to Migrate Your App"
url: "https://dev.to/pockit_tools/oauth-21-is-here-what-changed-whats-deprecated-and-how-to-migrate-your-app-ah3"
author: "HK Lee"
category: "oauth"
---

# OAuth 2.1 Is Here: What Changed, What's Deprecated, and How to Migrate Your App
**Author:** HK Lee
**Published:** March 25, 2026

## Overview
OAuth 2.1 consolidates OAuth 2.0 with fourteen years of security improvements from multiple RFCs. It removes several flows entirely and mandates new security practices that break existing implementations.

## Key Concepts

### 1. Implicit Grant Removed

```typescript
// Old: Implicit Grant (REMOVED in OAuth 2.1)
const authUrl = new URL('https://auth.example.com/authorize');
authUrl.searchParams.set('response_type', 'token');
authUrl.searchParams.set('client_id', CLIENT_ID);
authUrl.searchParams.set('redirect_uri', REDIRECT_URI);
window.location.href = authUrl.toString();

// New: Authorization Code + PKCE
const codeVerifier = generateCodeVerifier();
const codeChallenge = await generateCodeChallenge(codeVerifier);
const authUrl = new URL('https://auth.example.com/authorize');
authUrl.searchParams.set('response_type', 'code');
authUrl.searchParams.set('client_id', CLIENT_ID);
authUrl.searchParams.set('redirect_uri', REDIRECT_URI);
authUrl.searchParams.set('code_challenge', codeChallenge);
authUrl.searchParams.set('code_challenge_method', 'S256');
window.location.href = authUrl.toString();
```

### 2. PKCE Now Mandatory for All Clients

```typescript
import { createHash, randomBytes } from 'crypto';

function generateCodeVerifier(): string {
  return randomBytes(32).toString('base64url');
}

async function generateCodeChallenge(verifier: string): Promise<string> {
  const hash = createHash('sha256').update(verifier).digest();
  return Buffer.from(hash).toString('base64url');
}

async function exchangeCode(code: string): Promise<TokenResponse> {
  const verifier = sessionStorage.getItem('pkce_verifier');
  const response = await fetch('https://auth.example.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'authorization_code',
      code,
      redirect_uri: REDIRECT_URI,
      client_id: CLIENT_ID,
      code_verifier: verifier!,
    }),
  });
  return response.json();
}
```

### 3. Device Authorization Flow (Replaces ROPC)

```typescript
async function deviceLogin(): Promise<void> {
  const deviceResponse = await fetch('https://auth.example.com/device', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      client_id: CLI_CLIENT_ID,
      scope: 'read write',
    }),
  });
  const { device_code, user_code, verification_uri, interval } =
    await deviceResponse.json();
  console.log(`Open ${verification_uri} and enter code: ${user_code}`);
  while (true) {
    await sleep(interval * 1000);
    const tokenResponse = await fetch('https://auth.example.com/token', {
      method: 'POST',
      body: new URLSearchParams({
        grant_type: 'urn:ietf:params:oauth:grant-type:device_code',
        device_code,
        client_id: CLI_CLIENT_ID,
      }),
    });
    const result = await tokenResponse.json();
    if (result.access_token) {
      saveTokens(result);
      return;
    }
    if (result.error === 'expired_token') throw new Error('Login expired.');
  }
}
```

### 4. No Bearer Tokens in URLs

```typescript
// Not allowed
fetch('https://api.example.com/data?access_token=eyJhbGciOi...');

// Authorization header only
fetch('https://api.example.com/data', {
  headers: { 'Authorization': 'Bearer eyJhbGciOi...' },
});
```

### 5. DPoP (Demonstration of Proof-of-Possession)

```typescript
async function createDPoPProof(url: string, method: string, accessToken?: string): Promise<string> {
  const keyPair = await crypto.subtle.generateKey(
    { name: 'ECDSA', namedCurve: 'P-256' }, false, ['sign', 'verify']
  );
  const header = {
    alg: 'ES256', typ: 'dpop+jwt',
    jwk: await crypto.subtle.exportKey('jwk', keyPair.publicKey),
  };
  const payload = {
    jti: crypto.randomUUID(), htm: method, htu: url,
    iat: Math.floor(Date.now() / 1000),
    ...(accessToken && { ath: await sha256Base64url(accessToken) }),
  };
  return signJWT(header, payload, keyPair.privateKey);
}
```
