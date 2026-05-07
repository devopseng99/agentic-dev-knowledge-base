---
title: "Building a crashproof cloud backend in Python using REST and PostgreSQL"
url: "https://dev.to/dbos/building-a-crashproof-cloud-backend-in-python-using-rest-and-postgresql-4a0j"
author: "Qian Li"
category: "multi-cloud-durable"
---

# Building a crashproof cloud backend in Python using REST and PostgreSQL
**Author:** Qian Li
**Published:** October 11, 2024

## Overview
Tutorial demonstrating how to build a resilient Python backend for an e-commerce platform using DBOS framework. The application features REST APIs, PostgreSQL integration, and durable execution that ensures each step executes precisely once with automatic resumption after interruptions.

## Key Concepts

The checkout workflow orchestrates order creation, inventory reservation, payment processing, and fulfillment dispatch. Each step executes exactly once, with automatic resumption after interruptions. Users can trigger crashes via a dedicated endpoint and the application automatically restarts from its exact previous state.

The system uses transaction-decorated functions for CRUD operations, HTTP endpoints for frontend access, and idempotency keys to prevent duplicate order creation. Deployment options include DBOS Cloud CLI and local Docker-containerized PostgreSQL.
