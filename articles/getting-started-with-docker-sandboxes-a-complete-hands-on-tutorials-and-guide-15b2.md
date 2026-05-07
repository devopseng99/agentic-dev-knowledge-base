---
title: "Docker Sandboxes: A Deep Dive into Secure AI Agent Isolation"
url: "https://dev.to/ajeetraina/getting-started-with-docker-sandboxes-a-complete-hands-on-tutorials-and-guide-15b2"
author: "Ajeet Singh Raina"
category: "agent-sandbox"
---

# Docker Sandboxes: A Deep Dive into Secure AI Agent Isolation

**Author:** Ajeet Singh Raina
**Published:** January 18, 2026

## Overview
Hands-on tutorial for Docker Sandboxes (Docker Desktop 4.50+), Docker's experimental feature for isolating agentic AI. Covers complete test matrix: SSH key blocking, AWS credential protection, path matching, state persistence, environment variables, and Playwright browser testing.

## Key Concepts

Docker Sandboxes auto-mount only project directories, automatically exclude sensitive paths (~/.ssh, ~/.aws, ~/Documents), maintain identical paths inside/outside the sandbox, and persist state per workspace.

## Code Examples

### Launch a Sandbox

```bash
mkdir -p /Users/ajeetsraina/sandbox-testing
cd /Users/ajeetsraina/sandbox-testing
docker sandbox run claude
```

### Sandbox Management

```bash
docker sandbox ls
docker sandbox inspect 275d94b417bf
docker sandbox rm <sandbox-id>
```

### Isolation Verification

```bash
ls -la ~/.ssh/          # No access
ls -la ~/.aws/          # No access
ls ~/Documents/         # Blocked
ls -la /Users/ajeetsraina/sandbox-testing/  # Accessible
```

### Environment Variables

```bash
docker sandbox run -e MY_SECRET=supersecret123 -e APP_ENV=development claude
echo $MY_SECRET         # Available inside
```

### Docker Socket Access (with warning)

```bash
docker sandbox run --mount-docker-socket claude
sudo docker ps          # Requires sudo inside sandbox
```

### Test Results

| Feature | Expected | Result |
|---------|----------|--------|
| SSH keys blocked | Blocked | Pass |
| AWS credentials blocked | Blocked | Pass |
| Documents blocked | Blocked | Pass |
| Project folder accessible | Accessible | Pass |
| Path matching | Same paths | Pass |
| State persistence | Persists | Pass |
| Environment variables | Available | Pass |
| Playwright isolation | Browsers isolated | Pass |
