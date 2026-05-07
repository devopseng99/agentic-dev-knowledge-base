---
title: "How an AI Agent Connected ERP and E-commerce: Implementing UniApp API Integration and ERP Sync for TechsFree"
url: "https://dev.to/linou518/how-an-ai-agent-connected-erp-and-e-commerce-implementing-uniapp-api-integration-and-erp-sync-for-1j8m"
author: "linou518"
category: "erp-business-law"
---
# How an AI Agent Connected ERP and E-commerce: Implementing UniApp API Integration and ERP Sync for TechsFree
**Author:** linou518  **Published:** March 6, 2026

## Overview
Two major integration tasks for the TechsFree Platform: a backend ERP synchronization API and a UniApp mobile frontend refactor. Both projects bridged previously independent ERP and e-commerce systems.

## Key Concepts

**Task 1: Backend ERP Sync API**

Endpoints Implemented:
```
POST /api/v1/erp/sync/products
POST /api/v1/erp/sync/inventory
POST /api/v1/orders/:id/sync-to-erp
GET /api/v1/erp/inventory/check/:productId
```

**Key Design Pattern — Upsert Strategy**
"Update if exists, create if not" based on `erpProductId` as the conflict key — prevents duplicate products during re-synchronization cycles.

**Inventory Sync Approach**
Two complementary methods:
1. Batch updates for nightly runs
2. Real-time queries to prevent overselling at checkout

**Order Integration**
Customer and sales records automatically flow from e-commerce into ERP, eliminating manual data entry.

**Task 2: UniApp Refactor**
- Configuration management
- HTTP request utilities (migrated from session cookies to JWT Bearer token authentication)
- Store, user, order, and activity API layers
- Removed dead code: `user_coupon`, `user_getcoupon`, `user_vip` routes
- Automatic logout handling for expired tokens

**Key Insight**
Both tasks exemplify "seam tidying" — unglamorous but foundational integration work that eliminates repetitive manual data synchronization.
