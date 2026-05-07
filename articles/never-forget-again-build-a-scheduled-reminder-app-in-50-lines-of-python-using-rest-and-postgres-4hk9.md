---
title: "Never Forget Again: Build a Scheduled Reminder App in <50 Lines of Python"
url: "https://dev.to/dbos/never-forget-again-build-a-scheduled-reminder-app-in-50-lines-of-python-using-rest-and-postgres-4hk9"
author: "DBOS"
category: "multi-cloud-durable"
---

# Never Forget Again: Build a Scheduled Reminder App in <50 Lines of Python
**Author:** DBOS
**Published:** 2024

## Overview
Demonstrates DBOS durable execution for building a scheduled reminder application in under 50 lines of Python. The app uses REST endpoints and PostgreSQL persistence, with scheduled workflows that survive crashes and restarts.

## Key Concepts
DBOS durably executes workflows where each step executes exactly-once. If the application is interrupted, it automatically resumes from where it left off. Scheduled workflows use PostgreSQL for state persistence, making the entire system crashproof without complex infrastructure. Demonstrates the minimal code required to add durability to Python applications.
