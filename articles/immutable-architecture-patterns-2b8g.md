---
title: "Immutable Architecture Patterns"
url: "https://dev.to/aws-builders/immutable-architecture-patterns-2b8g"
author: "Supratip Banerjee"
category: "immutable-arch-rust-flink"
---
# Immutable Architecture Patterns
**Author:** Supratip Banerjee  **Published:** January 6, 2021

## Overview
Systems remain unchanging rather than being modified in place. Instead of patching existing servers, create new ones and deploy applications to them. Eliminates SSH access, deploys identical code across all environments, and enables reliable rollbacks through Blue-Green and Canary deployments.

## Key Concepts
- **Server Management**: Create new servers rather than patching existing ones
- **Access Control**: Eliminate SSH and manual server access
- **Consistency**: Deploy identical code across all environments
- Enhanced reliability through Canary and Blue-Green deployments
- Offline dependency management via artifactory
- Protection against malicious interference through server isolation

AWS-based deployment strategies:
1. **Route 53 Traffic Routing** - Minimized TTL values for faster updates
2. **Auto Scaling Groups** - Two ASGs gradually shifting instances from production to new versions
3. **ALB with Weighted Target Groups** - Routes traffic to specific target groups
4. **API Gateway** - Routes percentages of REST API requests to new deployments
5. **Lambda Alias Traffic Shifting** - Updates version weights to route traffic to new Lambda versions

Automation: AWS CodeDeploy with canary deployment configurations.
