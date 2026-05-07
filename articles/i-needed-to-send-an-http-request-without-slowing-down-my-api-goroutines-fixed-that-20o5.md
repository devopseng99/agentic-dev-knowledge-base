---
title: "I Needed to Send an HTTP Request Without Slowing Down My API. Goroutines Fixed That."
url: "https://dev.to/abhishek_sharma_a9792aee8/i-needed-to-send-an-http-request-without-slowing-down-my-api-goroutines-fixed-that-20o5"
author: "Abhishek Sharma"
category: "code-optimization"
---
# I Needed to Send an HTTP Request Without Slowing Down My API. Goroutines Fixed That.
**Author:** Abhishek Sharma  **Published:** May 5, 2026

## Overview
A practical walk-through of using goroutines to fire-and-forget HTTP requests (analytics, webhooks, notifications) without adding latency to the main API response path. A common pattern that can reduce API response times by 30-200ms.

## Key Concepts

### The Problem
Every time a user logged in, the API was sending a Slack notification AND waiting for the response before returning to the user. This added 150-200ms of latency for every login.

### The Solution: Goroutines for Fire-and-Forget
Launch the non-critical HTTP request in a goroutine and return immediately to the user. The notification still gets sent - just not blocking the user.

### When to Use This Pattern
- Analytics events (don't block the user for telemetry)
- Webhook notifications (user doesn't need to wait)
- Cache invalidation signals (can happen async)
- Audit log writes (user shouldn't wait for logging)

### When NOT to Use This Pattern
- Payment processing (must confirm success/failure)
- Critical data writes (user needs confirmation)
- Operations that must complete before responding

## Key Code Examples

```go
// BEFORE: Blocking - user waits for Slack notification
func loginHandler(w http.ResponseWriter, r *http.Request) {
    user := authenticateUser(r)

    // User waits 150ms for this
    sendSlackNotification(user.Name)  // BLOCKS

    w.WriteHeader(http.StatusOK)
    json.NewEncoder(w).Encode(user)
}

func sendSlackNotification(username string) {
    payload := map[string]string{"text": username + " just logged in"}
    body, _ := json.Marshal(payload)
    http.Post(slackWebhook, "application/json", bytes.NewBuffer(body))
}
```

```go
// AFTER: Non-blocking with goroutine - user gets response immediately
func loginHandler(w http.ResponseWriter, r *http.Request) {
    user := authenticateUser(r)

    // Fire and forget - goroutine runs independently
    go sendSlackNotification(user.Name)  // Returns immediately

    w.WriteHeader(http.StatusOK)
    json.NewEncoder(w).Encode(user)
}
```

```go
// Production-grade: goroutine with timeout and error logging
func sendSlackNotificationAsync(username string) {
    go func() {
        ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
        defer cancel()

        payload := map[string]string{"text": username + " just logged in"}
        body, err := json.Marshal(payload)
        if err != nil {
            log.Printf("slack notification marshal error: %v", err)
            return
        }

        req, err := http.NewRequestWithContext(ctx, "POST", slackWebhook,
            bytes.NewBuffer(body))
        if err != nil {
            log.Printf("slack notification request error: %v", err)
            return
        }
        req.Header.Set("Content-Type", "application/json")

        resp, err := http.DefaultClient.Do(req)
        if err != nil {
            log.Printf("slack notification send error: %v", err)
            return
        }
        defer resp.Body.Close()

        if resp.StatusCode >= 400 {
            log.Printf("slack notification failed with status: %d", resp.StatusCode)
        }
    }()
}
```

```go
// Worker pool pattern for high-volume async notifications
type NotificationWorkerPool struct {
    jobs chan NotificationJob
    wg   sync.WaitGroup
}

func NewNotificationWorkerPool(workers int) *NotificationWorkerPool {
    pool := &NotificationWorkerPool{
        jobs: make(chan NotificationJob, 1000),  // Buffer prevents blocking sender
    }
    for i := 0; i < workers; i++ {
        pool.wg.Add(1)
        go func() {
            defer pool.wg.Done()
            for job := range pool.jobs {
                job.Execute()
            }
        }()
    }
    return pool
}

func (p *NotificationWorkerPool) Submit(job NotificationJob) {
    select {
    case p.jobs <- job:
        // Submitted successfully
    default:
        log.Println("notification queue full, dropping notification")
    }
}
```

## Key Insight
The goroutine approach reduced login latency from 350ms to 180ms (49% improvement) in the author's production system. Goroutines are cheap (~2KB stack) so spawning one per request for non-critical work is perfectly fine up to millions of requests.
