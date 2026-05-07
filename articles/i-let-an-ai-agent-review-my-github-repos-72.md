---
title: "I Let an AI Agent Review My GitHub Repos"
url: "https://dev.to/aws-builders/i-let-an-ai-agent-review-my-github-repos-72"
author: "Sarvar Nadaf"
category: "ai-agent-github-actions-ci"
---

# I Let an AI Agent Review My GitHub Repos

**Author:** Sarvar Nadaf
**Published:** March 11, 2026

## Overview
Using Amazon Q Developer CLI + GitHub MCP Server to automate infrastructure code reviews, achieving 83% reduction in review time, 3x deployment velocity, and $18,000/month in cost savings.

## Key Concepts

### Review Guidelines (YAML)

```yaml
security_checks:
  - encryption_at_rest: required
  - encryption_in_transit: required
  - iam_least_privilege: enforce
  - public_access: flag_for_review

cost_checks:
  - unused_resources: flag
  - oversized_instances: warn
  - missing_lifecycle_policies: warn

compliance_checks:
  - tagging_standards: enforce
  - backup_policies: required
  - logging_enabled: required
```

### Results

| Metric | Before | After |
|--------|--------|-------|
| PR review time | 2-4 days | 2-4 hours |
| Architect review/day | 6-7 hours | 1-2 hours |
| Deployments/week | 12-15 | 35-40 |
| Security issues/month | 3-4 | 0-1 |

### Key Implementation Steps
1. Install Amazon Q Developer CLI
2. Set up GitHub MCP Server locally
3. Create review guidelines in YAML/markdown
4. Add `.q-context.md` files for project-specific exceptions
5. Train team leads on Q CLI with GitHub MCP
