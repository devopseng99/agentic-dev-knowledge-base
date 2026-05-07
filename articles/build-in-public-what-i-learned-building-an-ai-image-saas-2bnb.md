---
title: "Build-in-Public: What I Learned Building an AI Image SaaS"
url: "https://dev.to/gozel_t_8f2c084ded7672955/build-in-public-what-i-learned-building-an-ai-image-saas-2bnb"
author: "Gozel T"
category: "ai-image-video-generation"
---
# Build-in-Public: What I Learned Building an AI Image SaaS
**Author:** Gozel T  **Published:** 2026-04-22

## Overview
Founder of AdLoft AI (e-commerce AI ad creative tool) shares lessons from achieving $3.2k MRR with 520 users over six months through transparent public development.

## Key Concepts

### Tech Stack
- **Replicate** (image generation): $0.01/image
- **Vercel** (hosting): $20 at 1k users
- **Stripe** (payments): 2.9% + $0.30 per transaction
- **Uploadthing** (file uploads): Free tier
- **Next.js** for frontend
- **ComfyUI on RunPod** for heavy users

### Lesson 1: MVP Simplicity
Initial version included unnecessary features like video generation and A/B testing. Success came after stripping to core: image upload, five style templates, and instant downloads. Development time: two days using Replicate's API + Next.js + Vercel.

### Lesson 2: Paid-First Model
Freemium approach: 1,000 signups with only 2% conversion.
After switching to $19/mo: 80% fewer signups, 500% revenue increase.

Current tiered structure:
- $9/mo: 100 images
- $29/mo: Unlimited + custom templates
- $99/mo: API access for agencies

Average customer lifetime value: $250.

### Lesson 3: Results Over Technology
Users prioritize outcomes, not technical specifications. Adding an analytics dashboard tracking ad performance converted casual users to recurring subscribers, reducing churn to 8%.

### Lesson 4: Public Building Benefits
Twitter generated 40% of user acquisition. Weekly milestone posts about MRR, bug fixes, and feature releases. Time investment: 2 hours weekly.

### Lesson 5: Cost Management
AI infrastructure expenses scaled unexpectedly. Optimization:
- Cache common styles (60% savings)
- Batch processing
- Migrate heavy users to self-hosted ComfyUI on RunPod (40% reduction)

### Critical Mistakes
1. Frontend over-engineering delayed launch one month
2. Referral program failed; retention more valuable
3. SEO neglected initially; now ranking organically for "AI product ad generator"

### Current Metrics
$3.2k MRR, 520 users, 12% month-over-month growth
