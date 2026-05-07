---
title: "AthenaDB: Distributed Vector Database Powered by Cloudflare"
url: "https://dev.to/timesurgelabs/athenadb-distributed-vector-database-powered-by-cloudflare-4p59"
author: "Chandler"
category: "cloudflare-vectorize"
---

# AthenaDB: Distributed Vector Database Powered by Cloudflare
**Author:** Chandler
**Published:** February 19, 2024

## Overview
Serverless vector database using Workers AI for vector creation, Vectorize for querying, and D1 for text storage. Automatic replication across data centers.

## Key Concepts

### Setup
```shell
git clone https://github.com/TimeSurgeLabs/athenadb.git
cd athenadb && npm i && npx wrangler login
npm run create-vector && npm run create-db
npm run init-db && npm run deploy
```

### API Usage
```typescript
// Insert
fetch('https://athenadb.workers.dev/your-namespace/insert', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ input: 'Your text here' })
})

// Query
fetch('https://athenadb.workers.dev/your-namespace/query', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ input: 'Query text' })
})
```
