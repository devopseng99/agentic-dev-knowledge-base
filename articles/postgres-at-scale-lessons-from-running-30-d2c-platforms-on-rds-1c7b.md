---
title: "Postgres at Scale: Lessons from Running 30+ D2C Platforms on RDS"
url: "https://dev.to/ujjawal_tyagi_c5a84255da4/postgres-at-scale-lessons-from-running-30-d2c-platforms-on-rds-1c7b"
author: "Ujjawal Tyagi"
category: "code-optimization"
---
# Postgres at Scale: Lessons from Running 30+ D2C Platforms on RDS
**Author:** Ujjawal Tyagi  **Published:** May 6, 2026

## Overview
Production lessons from operating PostgreSQL on AWS RDS across 30+ direct-to-consumer e-commerce platforms, covering query optimization, connection management, index strategies, and cost reduction patterns.

## Key Concepts

### 1. Connection Pooling is Non-Negotiable
PostgreSQL forks a new OS process per connection. At 200+ concurrent connections, this destroys performance. PgBouncer in transaction mode reduces effective connections from 500 to 20-30 while handling 5,000 concurrent requests.

### 2. Analyze Your Slow Query Log First
The pg_stat_statements extension reveals your top-N most expensive queries before you touch anything else.

### 3. N+1 is the Silent Killer
Most D2C platforms had N+1 in their ORM layer. One call to list 100 products was making 101 database queries.

### 4. Partial Indexes Beat Full Indexes
On a 50M row orders table, a partial index on active orders (2% of rows) is 98% smaller and covers 95% of queries.

### 5. Autovacuum Needs Tuning
Default autovacuum settings are conservative. High-write tables need aggressive tuning or dead tuple buildup kills performance.

## Key Code Examples

```sql
-- Enable slow query logging (add to postgresql.conf)
log_min_duration_statement = 100  -- log queries > 100ms
shared_preload_libraries = 'pg_stat_statements'

-- Find your top 10 slowest queries
SELECT query, calls, total_exec_time, mean_exec_time, stddev_exec_time
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;
```

```sql
-- EXPLAIN ANALYZE - your best friend
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT o.*, p.name, c.email
FROM orders o
JOIN products p ON o.product_id = p.id
JOIN customers c ON o.customer_id = c.id
WHERE o.status = 'pending'
  AND o.created_at > NOW() - INTERVAL '7 days';

-- Look for: Seq Scans on large tables, high Rows Removed by Filter
```

```sql
-- Partial index - covers 95% of queries, 2% of table size
CREATE INDEX idx_orders_pending ON orders (created_at, customer_id)
WHERE status = 'pending';

-- vs full index (expensive to maintain, rarely needed)
-- CREATE INDEX idx_orders_full ON orders (status, created_at, customer_id);
```

```sql
-- Autovacuum tuning for high-write tables
ALTER TABLE orders SET (
    autovacuum_vacuum_scale_factor = 0.01,  -- 1% dead tuples triggers vacuum (default: 20%)
    autovacuum_analyze_scale_factor = 0.005, -- 0.5% for analyze
    autovacuum_vacuum_cost_delay = 2         -- ms (default: 20ms - too slow)
);
```

```python
# Django ORM - fix N+1 with select_related and prefetch_related
# N+1 (BAD): 1 query for orders + 1 query per order for customer
orders = Order.objects.filter(status='pending')
for order in orders:
    print(order.customer.email)  # 101 queries for 100 orders

# Fixed: 2 queries total
orders = Order.objects.filter(status='pending').select_related('customer', 'product')
for order in orders:
    print(order.customer.email)  # Already loaded
```

## RDS-Specific Tips
- Use db.r6g (Graviton) instances: 20% better price/performance vs x86
- Enable Performance Insights (free tier: 7 days retention)
- Use Enhanced Monitoring for OS-level metrics (CPU steal, disk I/O)
- RDS Proxy for Lambda/serverless to prevent connection exhaustion
- Read replicas for analytics queries - never run OLAP on primary
