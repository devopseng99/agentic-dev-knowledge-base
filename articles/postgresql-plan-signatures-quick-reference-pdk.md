---
title: "PostgreSQL Plan Signatures: Quick Reference"
url: "https://dev.to/philip_mcclarence_2ef9475/postgresql-plan-signatures-quick-reference-pdk"
author: "Philip McClarence"
category: "code-optimization"
---
# PostgreSQL Plan Signatures: Quick Reference
**Author:** Philip McClarence  **Published:** May 6, 2026

## Overview
A rapid-lookup companion for PostgreSQL query optimization. Provides three practical tables for diagnosing and fixing query performance issues by analyzing EXPLAIN plans quickly. "A scannable lookup companion designed for when you have an EXPLAIN plan in front of you and need the pattern -> fix mapping fast."

## Key Concepts

### How to Use
1. Capture plan: `EXPLAIN (ANALYZE, BUFFERS, VERBOSE, SETTINGS)`
2. Identify the dominant cost signature
3. Look up signature in reference table
4. Apply the fix (usually a single SQL statement)
5. Re-run EXPLAIN to verify changes

### Plan-Node Signatures

Key patterns to recognize:
- **Sequential scans on large tables** - indicates missing or unusable indexes
- **Functions on columns** - disables index usage; normalize data on write or create expression indexes
- **Nested loops with high iteration counts** - needs indexing on join columns
- **Hash joins with spillover (Batches > 1)** - increase work_mem or change join strategy
- **External merge sorts** - memory constraints; adjust work_mem or use sorted index input
- **Stale statistics** - when plan rows vs actual rows diverge by 10x or more

### SQL Anti-Patterns

| Anti-Pattern | Problem | Solution |
|---|---|---|
| SELECT * on wide tables | Prevents Index Only Scans | Name specific columns |
| WHERE text_col = 123 | Implicit casting disables index | Use WHERE text_col = '123' |
| WHERE NOT IN (SELECT ...) | NULL-unsafe logic | Replace with NOT EXISTS |
| OFFSET N LIMIT M with large N | Reads and discards rows | Use keyset pagination |
| N+1 ORM queries | Multiple round trips | Implement eager loading/JOINs |
| count(*) on huge tables | Full table scan | Use reltuples estimate or counter |

### MyDBA Analyzer Severity Levels
- Critical: Plan is broken for the query size
- Warning: Specific, known problem requiring investigation
- Info: Notable but not necessarily actionable

Key rules: seq_scan_large, nested_loop_large, sort_on_disk, hash_batches_spill, row_estimate_inaccurate

## Key Code Examples

```sql
-- The correct way to capture plans for analysis
EXPLAIN (ANALYZE, BUFFERS, VERBOSE, SETTINGS)
SELECT ...;
```

```sql
-- Fix: expression index when function on column disables index
-- Before (bad - can't use index):
SELECT * FROM users WHERE lower(email) = 'user@example.com';

-- After (add expression index):
CREATE INDEX idx_users_email_lower ON users (lower(email));
```

```sql
-- Fix: keyset pagination instead of OFFSET
-- Before (slow for large offsets):
SELECT * FROM events ORDER BY id LIMIT 20 OFFSET 10000;

-- After (fast keyset):
SELECT * FROM events WHERE id > :last_seen_id ORDER BY id LIMIT 20;
```

```sql
-- Fix: NOT EXISTS instead of NOT IN (NULL-safe)
-- Before:
SELECT * FROM orders WHERE customer_id NOT IN (SELECT id FROM deleted_customers);

-- After:
SELECT * FROM orders o
WHERE NOT EXISTS (SELECT 1 FROM deleted_customers dc WHERE dc.id = o.customer_id);
```

```sql
-- Fix stale statistics
ANALYZE table_name;
-- Or for specific columns:
ANALYZE table_name (column1, column2);
```
