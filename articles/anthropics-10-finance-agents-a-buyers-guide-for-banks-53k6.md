---
title: "Anthropic's 10 Finance Agents: A Buyer's Guide for Banks"
url: "https://dev.to/max_quimby/anthropics-10-finance-agents-a-buyers-guide-for-banks-53k6"
author: "Max Quimby"
category: "autonomous-operations"
---
# Anthropic's 10 Finance Agents: A Buyer's Guide for Banks
**Author:** Max Quimby  **Published:** May 6, 2026

## Overview
Anthropic released ten finance-focused agent templates designed for banking and insurance workflows. This buyer's guide maps each template to real finance teams and identifies open-source alternatives.

## Key Concepts

### The 10 Templates

1. **Pitch Builder** (IB Coverage Teams) — Creates Excel models, PowerPoint pitchbooks, and Outlook briefs. No comparable open-source option.

2. **Meeting Preparer** (Coverage/Sales) — Aggregates client filings, news, and interaction history. Open-source alternative: LlamaIndex RAG pipeline.

3. **Earnings Reviewer** (Equity Research) — Analyzes transcripts, flags guidance shifts, drafts update notes. Open-source alternative: TradingAgents (multi-agent debate framework).

4. **Model Builder** (IB/PE Modeling) — Constructs DCF, LBO, merger models from financials. No equivalent open-source solution.

5. **Market Researcher** (Coverage/Strategy) — Produces research briefs using FactSet, S&P, IBISWorld data. Open-source alternative: Dexter.

6. **Valuation Reviewer** (IB/PE Quality Control) — Audits models for formula errors, broken references, assumption inconsistencies.

7. **General Ledger Reconciler** (Accounting) — Matches transactions, flags exceptions, drafts journal entries. Open-source alternative: TaxHacker.

8. **Month-End Closer** (Controllership) — Orchestrates multi-day close (accruals, reconciliations, consolidation). No open-source equivalent at parity.

9. **Statement Auditor** (Audit/Compliance) — Ties out statements, checks disclosures, flags risks.

10. **KYC Screener** (Compliance/Onboarding) — Assembles entity files, runs sanctions/PEP checks, packages escalations.

### Technical Architecture
Templates operate on three structural layers:
- **Skills:** Domain knowledge encoded as markdown files (e.g., KYC rules)
- **Connectors:** Governed data access via FactSet, S&P Capital IQ, MSCI, PitchBook, Morningstar, LSEG, Daloopa, and Moody's
- **Subagents:** Additional Claude instances handling sub-tasks

### Deployment Options
- **Claude Cowork Plugin:** Browser-based, human-in-the-loop (pitchbooks, earnings prep)
- **Claude Code Plugin:** Terminal-based, code-aware (modeling, auditing)
- **Claude Managed Agents:** Unattended, scheduled/event-driven (month-end, batch KYC)

### Pricing
Enterprise contracts quoted in "high-six- to low-seven-figure range" for full ten-template deployment.

### Buyer's Guide Conclusion
- **Buy Anthropic if:** Output requires Wall Street letterhead and client-facing deliverables with Microsoft Office integration
- **Build open-source if:** Output is buy-side thesis-focused or data residency requirements prohibit vendor tenancy
