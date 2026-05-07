---
title: "Calling Laravel Developers — Let's Build a Clean, Extensible ERP (and AI Agents)"
url: "https://dev.to/hoang_le_daccdb7744e93666/calling-laravel-developers-lets-build-a-clean-extensible-erp-and-ai-agents-if2"
author: "Hoang Le"
category: "erp-business-law"
---
# Calling Laravel Developers — Let's Build a Clean, Extensible ERP (and AI Agents)
**Author:** Hoang Le  **Published:** February 6, 2026

## Overview
LiteERP is an open-source ERP platform emphasizing architectural cleanliness targeting developers who value "Clean Architecture," "Domain-Driven Design (DDD)," and extensible systems.

## Key Concepts

**Core Architecture Principle**
"The core stays small and stable. All complexity lives in extensions."

**Technology Stack**
- Laravel 12 framework
- Clean Architecture & DDD patterns
- Domain Events system
- Minimal framework coupling
- Clear domain boundaries

**Hybrid Frontend Approach**
Build admin screens using Blade templates OR rich dashboards with React, mixing both per extension without forcing SPA rewrites.

**Extension Architecture**
Extensions function as first-class citizens including:
- HRM (attendance, leave management)
- Debt management
- SMTP
- Reporting
- Upcoming AI agent capabilities

Extensions can: hook into domain events, expose APIs, add UI components independently.

**AI Integration Strategy**
"Practical AI (not buzzwords)" through agent extensions that:
- Remain external to core systems
- Subscribe to domain events
- Provide insights while maintaining human oversight
- Support both self-hosted and external AI providers

**Repository:** https://github.com/liteerp-oss/liteerp
