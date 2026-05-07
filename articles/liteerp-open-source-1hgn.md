---
title: "LiteERP - Open Source"
url: "https://dev.to/hoang_le_daccdb7744e93666/liteerp-open-source-1hgn"
author: "Hoang Le"
category: "erp-business-law"
---
# LiteERP - Open Source
**Author:** Hoang Le  **Published:** February 6, 2026

## Overview
LiteERP is an open-source ERP system targeting small and medium-sized businesses that can grow over time. Key architectural principle: "A lightweight core, with all features implemented as Extensions." Not trying to be a huge, bloated ERP system.

## Key Concepts

**Key Architectural Improvements**

React ServiceProvider Support
- React modules can now be loaded directly from Extensions without touching the core
- Enables modular feature development

Extension-First Design
- Dynamic React module loading per extension
- Reduced coupling between core components

**Extension Ecosystem**
Current and planned extensions:
- HRM Extension (attendance, leave management, workflows)
- SMTP Extension (flexible email configuration)
- Additional extensions following established standards

**AI Integration Strategy**
AI agent extensions remain external to core, subscribe to domain events, provide insights while maintaining human oversight, support both self-hosted and external AI providers. "Practical AI (not buzzwords)."

**Technology Stack**
- Laravel 12 framework
- Clean Architecture & DDD patterns
- Domain Events system
- Minimal framework coupling
- Hybrid frontend: Blade templates or React per extension

**Repository:** https://github.com/liteerp-oss/liteerp
