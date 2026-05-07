---
title: "How I Automated My Workflow With GitHub Actions (Agency-Level Setup in Minutes)"
url: "https://dev.to/pixel_mosaic/how-i-automated-my-workflow-with-github-actions-agency-level-setup-in-minutes-3ell"
author: "Pixel Mosaic"
category: "ai-agent-github-actions-ci"
---

# How I Automated My Workflow With GitHub Actions (Agency-Level Setup in Minutes)

**Author:** Pixel Mosaic
**Published:** December 9, 2025

## Overview
A straightforward guide to implementing CI/CD automation using GitHub Actions with Node.js and Vercel deployment.

## Key Concepts

### Complete Workflow

```yaml
name: CI/CD Pipeline

on:  
  push:  
    branches: [ main ]  
  pull_request:  
    branches: [ main ]

jobs:  
  build:  
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm install
      
      - name: Run tests
        run: npm test
      
      - name: Build project
        run: npm run build
      
      - name: Deploy to Vercel
        run: npx vercel --prod --yes
        env:
          VERCEL_TOKEN: ${{ secrets.VERCEL_TOKEN }}
```

### Best Practices
- Use `main` for production, `dev` for staging
- Include `npm run lint` in pipeline
- Secure tokens via GitHub Secrets
- Implement dependency caching
