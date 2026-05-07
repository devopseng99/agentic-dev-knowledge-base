---
title: "Amazon Q Developer Tips: No.18 Amazon Q Developer Agents - /dev"
url: "https://dev.to/aws/amazon-q-developer-tips-no18-amazon-q-developer-agents-dev-1i0"
author: "Ricardo Sueiras"
category: "aws-agents"
---

# Amazon Q Developer Tips: No.18 Amazon Q Developer Agents - /dev
**Author:** Ricardo Sueiras
**Published:** December 18, 2024

## Overview
Tips for using Amazon Q Developer's /dev agent effectively. Covers scaffolding strategies, data model-first approaches, and important constraints like file limits and workspace sizing.

## Key Concepts

### Scaffolding Strategy

```
/dev Create a Node.js project for a basic hit counter application with the following structure:

.
├── iac/
│ ├── dynamodb-table.yml
│ └── fargate-service.yml
├── models/
│ └── counter.js
├── routes/
│ ├── healthcheck.js
│ └── increment-counter.js
├── tests/
│ ├── healthcheck.test.js
│ └── increment-counter.test.js
├── Dockerfile
├── build-and-deploy.sh
├── index.js
└── package.json
```

### Key Constraints
- .gitignore files are filtered out, only supported file types generate code
- Limit changes to approximately 5 files per request
- Sizing limits: 50MB compressed (200MB uncompressed) source code
- Build data models first as /dev uses them when building the rest

### Best Practice
Use "Provide feedback and regenerate" option for course corrections when results don't match expectations.
