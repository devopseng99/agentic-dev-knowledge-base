---
title: "Queue-Based Exponential Backoff: A Resilient Retry Pattern for Distributed Systems"
url: "https://dev.to/andreparis/queue-based-exponential-backoff-a-resilient-retry-pattern-for-distributed-systems-37f3"
author: "Andre Paris"
category: "agent-retry-backoff-pattern"
---

# Queue-Based Exponential Backoff: A Resilient Retry Pattern for Distributed Systems

**Author:** Andre Paris
**Published:** October 20, 2025

## Overview
Production-ready retry pattern using message queues (SQS) instead of in-process setTimeout for durable, distributed, observable retries. Includes error-specific strategies, CDK infrastructure, and dead letter queue handling.

## Key Concepts

### Problems with Traditional Retry
- No durability: retries vanish if process crashes
- Memory leaks: long-running timers accumulate
- Poor scalability: cannot distribute across workers
- Limited observability: difficult to track attempts
- No backpressure: cannot throttle based on load

### Error-Specific Strategies
- Rate Limit: 60s base delay, up to 5 minutes
- Temporary: 2s base, up to 1 minute
- Quota Exceeded: 120s base, up to 10 minutes

## Code Examples

### Retry Logic with Exponential Backoff

```typescript
private calculateRequeueDelay(error: any, retryCount: number): number {
  const errorType = this.classifyError(error);
  const config = this.ERROR_RETRY_CONFIG[errorType] ||
                 this.ERROR_RETRY_CONFIG.DEFAULT;

  const exponentialDelay = config.baseDelay *
    Math.pow(this.RETRY_CONFIG.baseDelayMultiplier, retryCount);

  const jitter = Math.random() *
    (exponentialDelay * this.RETRY_CONFIG.jitterPercentage);

  const finalDelay = Math.min(
    exponentialDelay + jitter,
    Math.min(config.maxDelay, this.RETRY_CONFIG.maxDelaySeconds)
  );

  return Math.ceil(finalDelay);
}
```

### Message Processing Poll Loop

```typescript
private async poll(handler: MessageHandler,
                   queueUrl: string): Promise<void> {
  while (true) {
    try {
      const { Messages } = await this.sqs.send(
        new ReceiveMessageCommand({
          QueueUrl: queueUrl,
          MaxNumberOfMessages: 1,
          WaitTimeSeconds: 20, // Long polling
        })
      );

      if (!Messages || Messages.length === 0) continue;

      for (const msg of Messages) {
        try {
          await handler.handle(JSON.parse(msg.Body ?? '{}'));
          await this.sqs.send(
            new DeleteMessageCommand({
              QueueUrl: queueUrl,
              ReceiptHandle: msg.ReceiptHandle!,
            })
          );
        } catch (err) {
          await this.retryWithBackoff(err, queueUrl, msg);
        }
      }
    } catch (err) {
      this.logger.error(`Error polling queue`, err as any);
      await new Promise(r => setTimeout(r, 5000));
    }
  }
}
```

### CDK Infrastructure

```typescript
const processingQueue = new sqs.Queue(this, 'ProcessingQueue', {
  queueName: 'my-service-processing-queue',
  visibilityTimeout: cdk.Duration.seconds(60),
  retentionPeriod: cdk.Duration.days(14),
  deadLetterQueue: {
    queue: deadLetterQueue,
    maxReceiveCount: 3,
  },
  receiveMessageWaitTime: cdk.Duration.seconds(20),
});
```
