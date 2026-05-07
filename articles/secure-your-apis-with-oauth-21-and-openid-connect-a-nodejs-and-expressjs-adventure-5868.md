---
title: "Secure Your APIs with OAuth 2.1 and OpenID Connect: A Node.js and Express.js Adventure"
url: "https://dev.to/anupam_kumar/secure-your-apis-with-oauth-21-and-openid-connect-a-nodejs-and-expressjs-adventure-5868"
author: "Anupam Kumar"
category: "oauth"
---

# Secure Your APIs with OAuth 2.1 and OpenID Connect: A Node.js and Express.js Adventure
**Author:** Anupam Kumar
**Published:** May 1, 2025

## Overview
Comprehensive guide to API security using OAuth 2.1 and OpenID Connect within a Node.js/Express.js context.

## Key Concepts

### Complete app.js Implementation

```javascript
require('dotenv').config();
const express = require('express');
const jwt = require('jsonwebtoken');
const jwksClient = require('jwks-rsa');

const app = express();
const port = process.env.PORT || 3000;

const client = jwksClient({
  jwksUri: `${process.env.ISSUER}/.well-known/jwks.json`,
  cache: true, rateLimit: true, jwksRequestsPerMinute: 5,
});

function getKey(header, callback) {
  client.getSigningKey(header.kid, (err, key) => {
    if (err) { callback(err); } else {
      const signingKey = key.getPublicKey();
      callback(null, signingKey);
    }
  });
}

function validateToken(requiredScopes = []) {
  return (req, res, next) => {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Missing or invalid Authorization header' });
    }
    const token = authHeader.split(' ')[1];
    jwt.verify(token, getKey, {
      audience: process.env.AUDIENCE,
      issuer: process.env.ISSUER,
      algorithms: ['RS256'],
    }, (err, decoded) => {
      if (err) return res.status(401).json({ error: 'Invalid or expired token' });
      const scopes = decoded.scope ? decoded.scope.split(' ') : [];
      const hasRequiredScopes = requiredScopes.every((scope) => scopes.includes(scope));
      if (!hasRequiredScopes) return res.status(403).json({ error: `Missing required scopes: ${requiredScopes}` });
      req.user = decoded;
      next();
    });
  };
}

app.get('/public', (req, res) => {
  res.json({ message: 'Welcome to the public API!' });
});

app.get('/profile', validateToken(['profile']), (req, res) => {
  res.json({ message: `Hello, ${req.user.sub}!` });
});

app.listen(port, () => console.log(`Secure API at http://localhost:${port}`));
```

### Setup

```bash
mkdir secure-cat-api && cd secure-cat-api
npm init -y
npm install express jsonwebtoken jwks-rsa dotenv
```
