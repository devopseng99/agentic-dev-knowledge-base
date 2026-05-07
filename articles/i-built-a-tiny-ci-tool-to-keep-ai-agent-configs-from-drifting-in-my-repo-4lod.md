---
title: "I built a tiny CI tool to keep AI agent configs from drifting in my repo"
url: "https://dev.to/ramanpreet_singh_701cac53/i-built-a-tiny-ci-tool-to-keep-ai-agent-configs-from-drifting-in-my-repo-4lod"
author: "Ramanpreet Singh"
category: "full-code-examples"
---

# I built a tiny CI tool to keep AI agent configs from drifting in my repo
**Author:** Ramanpreet Singh
**Published:** May 5, 2026

## Overview
Lightweight CI validation tool that converts agent governance rules into YAML contracts and flags violations. Prevents configuration drift in AI agent repositories.

## Key Concepts

### GitHub Repository
https://github.com/RPSingh1990/agent-contract-tests

### Tool ACL Configuration

```yaml
# .agent-ops/registry/tool-acl.yaml
backend-builder:
  tools:
    - repo_read
    - repo_write_backend
    - run_backend_tests

security-reviewer:
  tools:
    - repo_read
    - dependency_scan

blocked_tools:
  - direct_email_send
  - production_delete
```

### Runtime Guard Module

```python
from agent_ops_guard import AgentOpsGuard

guard = AgentOpsGuard(".")
guard.assert_tool_allowed("backend-builder", "repo_read")
guard.assert_call_allowed("orchestrator", "backend-builder")
```

Policy violations raise `PolicyDenied` exceptions before execution.

### Getting Started

```bash
git clone https://github.com/RPSingh1990/agent-contract-tests
cd agent-contract-tests
python3 scripts/agent_ops_validate.py --strict
```

### Initialize in Existing Repos

```bash
python3 scripts/agent_ops_init.py --target /path/to/your-repo
```

### CI Flags
- Agent declares unauthorized tools
- Agent calls another agent outside the call graph
- Sensitive actions lack required evidence fields

### Scope
NOT an agent framework, process sandbox, or LLM evaluation suite -- purely a contract-testing layer.
