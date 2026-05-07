---
title: "Whistleblower for Database: Set up an internal informant who exposes performance"
url: "https://dev.to/mongodb/whistleblower-for-database-set-up-an-internal-informant-who-exposes-performance-47db"
author: "MongoDB Guests"
category: "code-optimization"
---
# Whistleblower for Database: Set up an internal informant who exposes performance
**Author:** MongoDB Guests (Darshan Jayarama)  **Published:** May 7, 2026

## Overview
Uses the metaphor of "whistleblowers" to describe database monitoring alerts that signal problems before production failures occur. Rather than waiting for catastrophic system failures, DBAs should heed warning signs proactively.

## Key Concepts

### Whistleblower 1: Performance Informant
Monitors operational efficiency:
- **High CPU utilization** - indicates unsustainable workloads; consider shifting processes elsewhere
- **Slow queries (<5 seconds threshold)** - suggest missing or poorly optimized indexes
- **Low cache hit ratios (<80%)** - reflect excessive disk I/O; increase memory allocation or optimize queries

### Whistleblower 2: Cost Informant
Tracks resource consumption:
- **Storage >80%** - requires archival of old logs and cleanup of unused processes
- **IOPS exceeding budget** - demands query rewriting and schema redesign
- **Unexpected auto-scaling in MongoDB Atlas** - signals workload changes requiring investigation

### Whistleblower 3: Reliability Informant
Ensures data durability:
- **Replication lag >10 seconds** - may indicate primary write overload; use flow-control and writeConcern settings
- **Oplog <24 hours retention** - insufficient; maintain minOplogRetention at 24+ hours
- **Connections >80%** - each connection consumes ~1MB memory; implement connection pooling

## Key Thresholds to Monitor

| Metric | Warning Threshold | Action |
|--------|----------|--------|
| CPU utilization | High sustained | Shift processes, optimize queries |
| Query duration | > 5 seconds | Add/optimize indexes |
| Cache hit ratio | < 80% | Increase memory, optimize queries |
| Storage usage | > 80% | Archive old data, cleanup |
| Replication lag | > 10 seconds | Reduce primary write load |
| Oplog retention | < 24 hours | Increase minOplogRetention |
| Connection usage | > 80% | Implement connection pooling |

## Key Insight
Choose between reactive incident response or proactive database management. Heeding these "whistleblower" alerts prevents the "pressure cooker explosion" of production outages. Set up monitoring dashboards and alerting before incidents happen, not after.
