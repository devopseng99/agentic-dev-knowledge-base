---
title: "Agents That Remember Where They Were"
url: "https://dev.to/itlackey/agents-that-remember-where-they-were-1koe"
author: "IT Lackey"
category: "multi-cloud-durable"
---

# Agents That Remember Where They Were
**Author:** IT Lackey
**Published:** May 5, 2026

## Overview
Introduces three features in akm v0.5.0 for solving agent state persistence: Workflow Assets (stored procedures with resumable steps), Vault Assets (secret management without value exposure), and Writable Git Stash (cross-machine skill sync). Distinguishes between tasks (single-context) and procedures (multi-session sequences).

## Key Concepts

Workflows are markdown files with resumable steps:

```markdown
---
description: Ship a production release
params:
  version: "The version to release (e.g. 1.2.3)"
---
# Workflow: Ship Release

## Step: Validate inputs
Step ID: validate
### Instructions
Check that version follows semver and that the release branch exists.

## Step: Build
Step ID: build
### Instructions
Run `bun run build` and verify dist/ was generated.
```

Commands for workflow management:

```bash
akm workflow start workflow:ship-release --params '{"version":"1.2.3"}'
akm workflow next workflow:ship-release
akm workflow complete run-abc123 --step validate --notes "Version confirmed"
akm workflow status run-abc123
```

The procedure state becomes auditable and external to the conversation. Interrupted sessions resume precisely where they left off without context reconstruction.
