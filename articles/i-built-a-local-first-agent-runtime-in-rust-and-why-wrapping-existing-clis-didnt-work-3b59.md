---
title: "I Built a Local-First Agent Runtime in Rust (and Why Wrapping Existing CLIs Didn't Work)"
url: "https://dev.to/calvinbuild/i-built-a-local-first-agent-runtime-in-rust-and-why-wrapping-existing-clis-didnt-work-3b59"
author: "Calvin Sturm"
category: "immutable-arch-rust-flink"
---
# I Built a Local-First Agent Runtime in Rust (and Why Wrapping Existing CLIs Didn't Work)
**Author:** Calvin Sturm  **Published:** February 21, 2026

## Overview
LocalAgent: Rust-based runtime for AI agents using local models (LM Studio, Ollama, llama.cpp). Defaults to restrictive settings — trust disabled, shell access blocked, write tools unexposed. Embedding security gates natively in execution model rather than wrapping external CLIs. Biggest reliability gains from process constraints, not model hype.

## Key Concepts
Why external wrappers fail: cannot reliably enforce security boundaries when tool execution is external to host application.

Execution cycle:
1. Build runtime context
2. Prepare prompt messages
3. Apply compaction if configured
4. Call model
5. Process tool calls through TrustGate before execution
6. Normalize results and feed back to model
7. Repeat until completion
8. Write artifacts for replay and debugging

```bash
cargo install --path . --force
localagent init
localagent doctor --provider lmstudio
localagent --provider lmstudio --model <model> chat --tui
```

```bash
localagent --provider ollama --model qwen3:8b --prompt "Summarize README.md" run
```

For slow hardware:
```bash
localagent --provider llamacpp \
  --base-url http://localhost:5001/v1 \
  --model default \
  --http-timeout-ms 300000 \
  --http-stream-idle-timeout-ms 120000 \
  --http-max-retries 0 \
  --prompt "..." run
```

Success factors: bounded tasks, strict output expectations, pre-execution validation, deterministic evaluations, replayable artifacts.

**Source:** https://github.com/CalvinSturm/LocalAgent
