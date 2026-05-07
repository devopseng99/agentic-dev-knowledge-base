---
title: "Retrying Failed Requests with Exponential Backoff"
url: "https://dev.to/abhivyaktii/retrying-failed-requests-with-exponential-backoff-48ld"
author: "Abhinav"
category: "agent-retry-backoff-pattern"
---

# Retrying Failed Requests with Exponential Backoff

**Author:** Abhinav
**Published:** May 29, 2025

## Overview
Exponential backoff with jitter for handling transient network failures. Covers JavaScript/Node.js implementation, Axios integration, Redis-based retry tracking, and retryable vs non-retryable error classification.

## Key Concepts

### Formula
```
delay = baseDelay * (2 ^ attemptNumber)
```
With baseDelay of 500ms: 500ms, 1000ms, 2000ms, 4000ms, 8000ms

### Retryable vs Non-Retryable
- Retry: 500, 503, 429
- Do NOT retry: 400, 401/403

## Code Examples

### JavaScript Fetch with Retry

```javascript
async function fetchWithRetry(url, options = {}, maxRetries = 5, baseDelay = 500) {
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      const response = await fetch(url, options);
      if (!response.ok && response.status >= 500) {
        throw new Error(`Server error: ${response.status}`);
      }
      return response;
    } catch (error) {
      if (attempt === maxRetries) {
        throw new Error(`Failed after ${maxRetries + 1} attempts: ${error.message}`);
      }
      const backoff = baseDelay * 2 ** attempt;
      const jitter = Math.random() * 100;
      const delay = backoff + jitter;
      console.warn(`Attempt ${attempt + 1} failed. Retrying in ${delay.toFixed(0)}ms...`);
      await new Promise((r) => setTimeout(r, delay));
    }
  }
}
```

### Axios with Retry

```javascript
const axios = require('axios');

async function axiosRetry(url, options = {}, retries = 3, baseDelay = 300) {
  for (let i = 0; i <= retries; i++) {
    try {
      return await axios(url, options);
    } catch (err) {
      if (i === retries || !shouldRetry(err)) throw err;
      const delay = baseDelay * 2 ** i + Math.random() * 100;
      await new Promise(r => setTimeout(r, delay));
    }
  }
}

function shouldRetry(err) {
  return [429, 500, 503].includes(err.response?.status);
}
```

### Redis Retry Tracking

```javascript
const retryKey = `retry:${jobId}`;
const attempt = await redis.get(retryKey) || 0;
if (attempt > maxRetries) throw new Error('Too many retries');
await redis.set(retryKey, attempt + 1, 'EX', retryExpirySeconds);
```
