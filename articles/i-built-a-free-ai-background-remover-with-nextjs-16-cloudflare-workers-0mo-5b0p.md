---
title: "I Built a Free AI Background Remover with Next.js 16 & Cloudflare Workers"
url: "https://dev.to/_51c72dc747ba876dd3294/i-built-a-free-ai-background-remover-with-nextjs-16-cloudflare-workers-0mo-5b0p"
author: "WobblyDev"
category: "ai-agent-cloudflare-workers"
---

# I Built a Free AI Background Remover with Next.js 16 & Cloudflare Workers

**Author:** WobblyDev
**Published:** April 13, 2026

## Overview
Complete AI background removal tool at zero monthly cost using Cloudflare's free tier (Workers + D1 + KV). Next.js 16 with Edge Runtime, Google OAuth in 200 lines, PayPal payments, and i18n support (English/Chinese).

## Key Concepts

### Why Cloudflare Over Vercel
On Vercel's free tier, a database means bolting on external services (hosted Postgres, Upstash for Redis), creating $15-20/month in dependencies. Cloudflare integrates D1 + KV + Workers in a single free offering with no cold starts.

### Architecture
- Next.js 16 (App Router + Edge Runtime)
- Cloudflare Workers (compute), D1 (SQLite), KV (sessions)
- Google OAuth, PayPal payments
- Privacy-first: no image storage

## Code Examples

### Before/After Comparison Slider

```tsx
<div className="relative overflow-hidden">
  <img src={originalUrl} alt="Original" />
  <img
    src={processedUrl}
    alt="Processed"
    style={{ clipPath: `inset(0 ${100 - position}% 0 0)` }}
    className="absolute inset-0"
  />
  <input
    type="range" min={0} max={100}
    value={position}
    onChange={(e) => setPosition(Number(e.target.value))}
  />
</div>
```

### Internationalization

```typescript
export type Locale = "en" | "zh";

export const messages: Record<Locale, Messages> = {
  en: {
    hero: { title: "Make your images clean, cut-out, and ready to use." },
  },
  zh: {
    hero: { title: "Make images cleaner and ready to use." },
  },
};
```

### Deployment

```shell
npx opennextjs-cloudflare build   # ~45 seconds
npx wrangler deploy               # ~45 seconds
```

```toml
# wrangler.toml - CRITICAL: without this, Node.js APIs fail silently
compatibility_flags = ["nodejs_compat"]
```

### Auth Structure
```
/api/auth/login           -> redirect to Google consent screen
/api/auth/callback/google -> exchange code for tokens, create user in D1
/api/auth/me              -> look up session in KV, return user
```
Sessions stored in KV with 7-day TTL. ~200 lines total.
