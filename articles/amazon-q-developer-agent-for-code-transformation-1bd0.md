---
title: "Amazon Q Developer Agent for Code Transformation"
url: "https://dev.to/aws-heroes/amazon-q-developer-agent-for-code-transformation-1bd0"
author: "Matt Lewis"
category: "aws-agents"
---

# Amazon Q Developer Agent for Code Transformation
**Author:** Matt Lewis
**Published:** November 18, 2024

## Overview
Practical walkthrough of using Amazon Q Developer's /transform agent to upgrade a Java 11 Spring Boot application to Java 17. Compares the Code Transformation Agent with the Software Development Agent (/dev) for SDK migration tasks.

## Key Concepts

### Transformation Process
1. Type `/transform` in Amazon Q chat
2. Agent analyzes workspace for Java 8 or 11 modules
3. Auto-selects module and confirms JDK17 target
4. Builds locally with optional unit tests
5. Uploads to AWS managed secure build environment
6. Rebuilds, analyzes, applies changes, fixes compilation errors
7. Completes in approximately 12 minutes

### Results
- All source files compiled successfully
- 6 unit tests ran without failures
- New methods auto-added for updated Spring Data interfaces

### Code Transformation Agent vs Software Development Agent

| Feature | /transform | /dev |
|---------|-----------|------|
| Secure build environment | Yes | No |
| Continuous compilation | Yes | No |
| Autonomous error fixing | Yes | No |
| Pre-acceptance testing | Yes | No |

### Limitations
- Did not transform AWS SDK v1 to v2
- Target limited to Java 17 (not 21 or 23)
