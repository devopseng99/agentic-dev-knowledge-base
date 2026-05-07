---
title: "Web3 Verifier Agent: Fight Rug Pulls with AI-Powered Due Diligence"
url: "https://dev.to/datadr1ven/web3-verifier-agent-fight-rug-pulls-with-ai-powered-due-diligence-2c0n"
author: "datadr1ven"
category: "web3-blockchain-agents"
---

# Web3 Verifier Agent: Fight Rug Pulls with AI-Powered Due Diligence
**Author:** datadr1ven
**Published:** January 23, 2026

## Overview
AI-powered safety tool for crypto investors to instantly verify web3 projects through natural conversation, with trust scoring, evidence-based responses, and structured analysis of positives and red flags.

## Key Concepts

### Data Pipeline

```javascript
const projects = await fetch('https://api.llama.fi/protocols');

{
  project_name: "Uniswap V3",
  chain: "Ethereum", 
  tvl_usd: 2070611004,
  audit_status: "audited",
  sentiment_score: 0.85,
  risk_flags: [],
}
```

### Trust Scoring Strategy

```
You are a neutral web3 investigator. For each query:

1. Search the web3-projects index for relevant data
2. Calculate trust score (1-10) based on:
   - Audit status (40% weight)
   - TVL stability (25% weight) 
   - Verified contracts (20% weight)
   - Sentiment analysis (15% weight)

3. Structure response with:
   - Trust score badge
   - Evidence-based summary
   - Positives first
   - Red flags second  
   - Source citations
```

### Tech Stack
- Frontend: Next.js 15 + TypeScript + Tailwind CSS
- AI Backend: Algolia Agent Studio for RAG with 200+ indexed web3 projects
- Data: Real-time DefiLlama API, hybrid semantic + keyword search

Live at: https://web3-verifier.vercel.app
