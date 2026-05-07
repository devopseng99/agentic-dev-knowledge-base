---
title: "Proof Key for Code Exchange: A developer's guide"
url: "https://dev.to/saif_shines/proof-key-for-code-exchange-a-developers-guide-pih"
author: "Saif"
category: "oauth"
---

# Proof Key for Code Exchange: A developer's guide
**Author:** Saif
**Published:** June 25, 2025

## Overview
Originally designed for mobile, PKCE is now mandatory in OAuth 2.1 for all public clients. Prevents interception and replay attacks.

## Key Concepts

### Generate Code Verifier and Challenge
```javascript
import crypto from 'crypto';
const codeVerifier = crypto.randomBytes(64).toString('base64url');
const codeChallenge = crypto.createHash('sha256').update(codeVerifier).digest('base64url');
console.log({ codeVerifier, codeChallenge });
```

### Exchange Code for Tokens
```shell
curl -X POST https://auth.example.com/oauth/token \
  -d grant_type=authorization_code \
  -d client_id=your-client-id \
  -d code=RECEIVED_AUTH_CODE \
  -d redirect_uri=http://localhost/callback \
  -d code_verifier=YOUR_CODE_VERIFIER
```

The server recomputes the hash of the code verifier and compares it to the original challenge. Mismatched values cause the exchange to fail.
