---
title: "How We Built a Custom ERP System: Tech Stack & Lessons Learned"
url: "https://dev.to/abhishek_pundir_beb087d2b/how-we-built-a-custom-erp-system-tech-stack-lessons-learned-5c35"
author: "Abhishek Pundir"
category: "erp-business-law"
---
# How We Built a Custom ERP System: Tech Stack & Lessons Learned
**Author:** Abhishek Pundir  **Published:** April 12, 2026

## Overview
Documents the architecture and implementation of a custom ERP system built by Vexioapp, addressing scenarios where off-the-shelf solutions like SAP or Oracle prove inadequate. System processes 10M+ transactions daily across 50+ integrated modules, maintaining 99.95% uptime with sub-200ms API response times.

## Key Concepts

**Technology Stack**
- Backend: Node.js with NestJS framework (TypeScript, horizontal scalability)
- Database: PostgreSQL (ACID compliance) + Redis (caching, real-time)
- Frontend: React + TypeScript, React Query, Tailwind CSS, Zustand, Vite
- Infrastructure: Docker + Kubernetes with auto-scaling

**Architectural Evolution: Monolith → Domain-Driven Microservices**
- User Service (authentication, permissions)
- Inventory Service (stock management)
- Order Service (sales fulfillment)
- Accounting Service (general ledger, payables, receivables)
- Reporting Service (business intelligence)

**Key Technical Patterns**
- Event-Driven Communication: Apache Kafka/RabbitMQ for service decoupling
- Real-Time Updates: WebSocket via Socket.io for live dashboards
- Distributed Transactions: Saga pattern with rollback capabilities
- CQRS for complex domains

**Major Challenges & Solutions**
1. Data Consistency → Saga patterns for distributed transaction management
2. Reporting Performance → Read replicas, data warehouses, materialized views
3. Access Control → Role-based + attribute-based access control

**Lessons Learned**
- Start with minimal viable architecture; optimize iteratively
- Database design fundamentally impacts performance
- Observability requires upfront investment
- Integration testing prevents system-wide failures
- API contracts and documentation become critical at scale
