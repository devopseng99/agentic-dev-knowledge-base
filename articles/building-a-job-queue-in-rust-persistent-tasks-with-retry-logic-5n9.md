---
title: "Building a Job Queue in Rust: Persistent Tasks With Retry Logic"
url: "https://dev.to/dylan_dumont_266378d98367/building-a-job-queue-in-rust-persistent-tasks-with-retry-logic-5n9"
author: "Dylan Dumont"
category: "agent-retry-backoff-pattern"
---

# Building a Job Queue in Rust: Persistent Tasks With Retry Logic

**Author:** Dylan Dumont
**Published:** April 17, 2026

## Overview
A resilient worker service in Rust that processes background tasks from a persistent SQL-backed queue. Ensures failed jobs are never lost but eventually succeed or move to a dead letter queue. State transitions survive application restarts.

## Key Concepts

Transient failures are inevitable; durable execution requires state to survive the crash.

## Code Examples

### Job State Machine

```rust
pub enum JobStatus {
  Pending,
  Running,
  Succeeded,
  Failed,
  DeadLetter,
}
```

### Persistent Job State

```rust
#[derive(sqlx::FromRow)]
pub struct Job {
  pub id: uuid::Uuid,
  pub status: JobStatus,
  pub retry_count: i32,
  pub created_at: DateTime<Utc>,
  pub last_attempted: Option<DateTime<Utc>>,
}
```

### Exponential Backoff with Jitter

```rust
pub fn calculate_delay(retry_count: i32) -> Duration {
  let base_duration = Duration::from_secs(1);
  let max_duration = Duration::from_secs(30);

  let raw_delay = base_duration * (1 << (retry_count as u32));
  let capped_delay = raw_delay.min(max_duration);

  let jitter = Duration::from_millis(rand::random::<u64>() % 100);

  Duration::from_secs(capped_delay.as_secs() + jitter.as_secs())
}
```

### Dead Letter Queue Logic

```rust
pub fn should_retry(job: &Job, error: &Error) -> bool {
  if job.retry_count >= MAX_RETRIES {
    return false; // Mark as DeadLetter
  }
  true
}
```

### Key Takeaways
- Treat state as an external truth source
- Persistent state machines ensure no work lost during crashes
- Separate success, retry, and failure logic for maintainability
