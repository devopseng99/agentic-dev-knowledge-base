---
title: "Nakama with YugabyteDB"
url: "https://dev.to/franckpachot/nakama-with-yugabytedb-1i5o"
author: "franckpachot"
category: "gaming-agents"
---
# Nakama with YugabyteDB
**Author:** Franck Pachot (YugabyteDB)  **Published:** September 6, 2022

## Overview
Demonstrates how to run Nakama (a server for real-time social and gaming applications) using YugabyteDB as the database backend. Since YugabyteDB is PostgreSQL-compatible, the integration is straightforward — requiring only a connection string change. The guide shows practical implementation through Docker Compose configuration with initialization scripts and health checks.

## Key Concepts
- **Nakama**: Open-source game server for real-time social and multiplayer gaming applications
- **PostgreSQL Compatibility**: YugabyteDB's compatibility enables drop-in replacement for PostgreSQL in game servers
- **Docker Compose Setup**: Containerized deployment strategy for both databases
- **Database Initialization**: SQL scripts for automatic database creation at startup
- **Health Checks**: TCP connection validation before service startup ensures dependencies are ready
- **Port Configuration**: YugabyteDB runs on port 5433; Nakama on ports 7349-7351
- **Prometheus Integration**: Metrics collection for game server monitoring

```bash
# Connection Wait Logic
until echo > /dev/tcp/yugabytedb/5433 ;
do
 echo "Waiting for YugabyteDB to be up..." ; sleep 1 ;
done ;
echo "YugabyteDB is up - check http://localhost:7000" ; sleep 5
```

```yaml
# Docker Compose — three services: yugabytedb, nakama, prometheus
# yugabytedb: version 2.14.1.0-b36 on port 5433
# nakama: version 3.13.1 on ports 7349-7351
# prometheus: metrics monitoring
# Key: change Nakama connection string from postgres:5432 to yugabytedb:5433
```
