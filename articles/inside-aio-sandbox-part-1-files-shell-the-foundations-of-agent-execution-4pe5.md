---
title: "Inside AIO Sandbox (Part 1): Files & Shell -- The Foundations of Agent Execution"
url: "https://dev.to/bytedanceoss/inside-aio-sandbox-part-1-files-shell-the-foundations-of-agent-execution-4pe5"
author: "XIAOXU CHANG for ByteDance Open Source"
category: "agent-sandbox"
---

# Inside AIO Sandbox (Part 1): Files & Shell -- The Foundations of Agent Execution

**Author:** XIAOXU CHANG for ByteDance Open Source
**Published:** March 31, 2026

## Overview
Introduces AIO Sandbox (ByteDance) providing agents an isolated environment with filesystem and shell access. Multi-language SDK (Python, TypeScript, Go). Demonstrates a Read -> Execute -> Read -> Validate -> Fix -> Re-run -> Export workflow.

## Key Concepts

AIO Sandbox integrates browser, shell, and filesystem into a unified agent-focused environment. Think of it as a "remote, disposable Linux machine" your agent controls via APIs.

### Setup

```bash
docker run --security-opt seccomp=unconfined --rm -it -p 8080:8080 ghcr.io/agent-infra/sandbox:latest
pip install agent-sandbox
```

## Code Examples

### Complete Agent Workflow

```python
from agent_sandbox import Sandbox

client = Sandbox(base_url="http://localhost:8080")
home_dir = client.sandbox.get_context().home_dir
app_dir = f"{home_dir}/data_agent"

# Create input data
client.file.write_file(
    file=f"{app_dir}/data.txt",
    content="10\n20\nINVALID\n40\n50\n",
)

# Write processing script
client.file.write_file(
    file=f"{app_dir}/process.py",
    content="""numbers = []
with open("data.txt") as f:
    for line in f:
        try:
            numbers.append(int(line.strip()))
        except:
            print("Skipping invalid line:", line.strip())

total = sum(numbers)
avg = total / len(numbers)
report = f\"\"\"Report Summary
Valid Count: {len(numbers)}
Total: {total}
Average: {avg}\"\"\"

with open("report.txt", "w") as f:
    f.write(report)
print(report)
""",
)

# List workspace
workspace = client.file.list_path(path=app_dir, recursive=True)
for entry in workspace.data.files:
    print("-", entry.path)

# Execute script
result = client.shell.exec_command(command=f"cd {app_dir} && python3 process.py")
print(result.data.output)

# Read report
report = client.file.read_file(file=f"{app_dir}/report.txt")
print(report.data.content)

# Validate
search = client.file.search_in_file(file=f"{app_dir}/report.txt", regex=r"Average: .*")

# Fix bad input
data_check = client.file.read_file(file=f"{app_dir}/data.txt")
if "INVALID" in data_check.data.content:
    client.file.replace_in_file(file=f"{app_dir}/data.txt", old_str="INVALID", new_str="30")

# Re-run and export
result = client.shell.exec_command(command=f"cd {app_dir} && python3 process.py")
with open("final_report.txt", "wb") as f:
    for chunk in client.file.download_file(path=f"{app_dir}/report.txt"):
        f.write(chunk)
```

### File Primitives
- `write_file` -- creates data and code
- `read_file` -- inspects inputs and outputs
- `list_path` -- workspace awareness
- `replace_in_file` -- repairs bad input
- `search_in_file` -- validates expected output
- `find_files` -- discovers artifacts
- `download_file` -- exports results
