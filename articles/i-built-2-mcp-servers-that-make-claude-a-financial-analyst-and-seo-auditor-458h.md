---
title: "I built 2 MCP servers that make Claude a financial analyst and SEO auditor"
url: "https://dev.to/vdalhambra/i-built-2-mcp-servers-that-make-claude-a-financial-analyst-and-seo-auditor-458h"
author: "vdalhambra"
category: "claude-mcp-server"
---

# I built 2 MCP servers that make Claude a financial analyst and SEO auditor

**Author:** vdalhambra
**Published:** April 13, 2026

## Overview

Two MCP servers extending Claude with specialized intelligence: FinanceKit (12 tools for financial market analysis) and SiteAudit (8 tools for website evaluation), built on FastMCP 3.2.

## Key Concepts

### FinanceKit MCP (12 tools)

- Technical analysis engine calculating 10 indicators (RSI, MACD, Bollinger Bands, SMA, EMA, ADX, Stochastic, ATR, OBV)
- Pattern detection: Golden Cross, Death Cross, overbought/oversold conditions
- Stock quotes, cryptocurrency prices via CoinGecko
- Multi-asset comparison with Sharpe ratios
- Portfolio analysis with sector breakdown

### SiteAudit MCP (8 tools)

- 20+ SEO checks plus security header analysis and SSL verification
- Example output: "Overall: 92/100 (Grade A)" with component scores
- `compare_sites` tool for competitive analysis across multiple domains
- Lighthouse scores and Core Web Vitals via Google PageSpeed Insights API
- Broken link detection with concurrent checking

### Installation

**Self-Hosted (MIT-licensed):**
```bash
claude mcp add financekit -- uvx --from financekit-mcp financekit
claude mcp add siteaudit -- uvx --from siteaudit-mcp siteaudit
```

### Technical Stack

- **Framework:** FastMCP 3.2
- **Data sources:** yfinance, CoinGecko API, Google PageSpeed Insights API
- **Analysis:** ta library for technical calculations
- **Parsing:** BeautifulSoup for HTML extraction
- **Optimization:** TTL-based response caching

### v1.2 Updates

**FinanceKit (+5 premium tools, 17 total):**
- Risk metrics (VaR, Sharpe, Sortino, Beta, Max Drawdown)
- Correlation matrix with diversification scoring
- Earnings calendar with EPS estimates
- Options chain data
- Sector rotation ranking (11 GICS sectors)

**SiteAudit (+3 premium tools, 11 total):**
- Accessibility audits (WCAG compliance)
- Schema.org JSON-LD validation
- Competitor gap analysis (up to 5 competitors)

Both servers are listed in the Official MCP Registry and available on Smithery and PyPI.
