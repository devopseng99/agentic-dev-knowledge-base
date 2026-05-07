---
title: "Building a tmux-native agent supervisor in Rust"
url: "https://dev.to/battyterm/building-a-tmux-native-agent-supervisor-in-rust-5hek"
author: "Batty"
category: "rust-go-java-agents"
---

# Building a tmux-native agent supervisor in Rust
**Author:** Batty
**Published:** March 22, 2026

## Overview
Batty is a ~51k-line Rust daemon orchestrating multiple AI coding agents in parallel. Hierarchical structure: architect directs manager who dispatches tasks to 3-5 engineer agents in isolated git worktrees. Uses synchronous polling, tmux CLI wrapping, Maildir for agent communication, and deep idle detection.

## Key Concepts

### Synchronous Polling Loop
```rust
loop {
    if shutdown_flag.load(Ordering::SeqCst) { break; }
    poll_watchers();
    restart_dead_members();
    deliver_inbox_messages();
    retry_failed_deliveries();
    maybe_auto_dispatch();
    maybe_fire_nudges();
    thread::sleep(Duration::from_secs(5));
}
```

### tmux CLI Wrapping
```rust
pub fn capture_pane(target: &str) -> Result<String> {
    let output = Command::new("tmux")
        .args(["capture-pane", "-p", "-t", target, "-S", "-2000"])
        .output()?;
    Ok(String::from_utf8_lossy(&output.stdout).to_string())
}
```

### Merge Lock for Git Worktrees
```rust
let lock = MergeLock::acquire(project_root)?;
match merge_engineer_branch(project_root, engineer)? {
    MergeOutcome::Success => { drop(lock); board_cmd::move_task(task_id, "done", engineer)?; }
    MergeOutcome::RebaseConflict(info) => { drop(lock); /* escalate */ }
}
```
