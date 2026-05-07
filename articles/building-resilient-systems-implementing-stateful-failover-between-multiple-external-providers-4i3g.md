---
title: "Building Resilient Systems: Implementing Stateful Failover Between Multiple External Providers"
url: "https://dev.to/dantesbytes/building-resilient-systems-implementing-stateful-failover-between-multiple-external-providers-4i3g"
author: "Dante"
category: "multi-cloud-durable"
---

# Building Resilient Systems: Implementing Stateful Failover Between Multiple External Providers
**Author:** Dante
**Published:** March 18, 2025

## Overview
Comprehensive guide to implementing stateful failover between external providers covering proxy-based failover, service mesh patterns, circuit breakers, stateful session management, chaos testing, and production observability with Prometheus metrics.

## Key Concepts

Circuit breaker pattern implementation:

```javascript
class CircuitBreaker {
  constructor(provider, options = {}) {
    this.provider = provider;
    this.state = 'CLOSED';
    this.failureCount = 0;
    this.failureThreshold = options.failureThreshold || 3;
    this.resetTimeout = options.resetTimeout || 30000;
  }
  async executeRequest(request) {
    if (this.state === 'OPEN') {
      if ((Date.now() - this.lastFailureTime) > this.resetTimeout) {
        this.state = 'HALF_OPEN';
      } else {
        throw new Error('Circuit breaker is OPEN');
      }
    }
    try {
      const result = await this.provider.handleRequest(request);
      if (this.state === 'HALF_OPEN') { this.state = 'CLOSED'; this.failureCount = 0; }
      return result;
    } catch (error) {
      this.failureCount++;
      this.lastFailureTime = Date.now();
      if (this.failureCount >= this.failureThreshold) { this.state = 'OPEN'; }
      throw error;
    }
  }
}
```

Chaos testing for failover verification:

```javascript
function startChaosTesting(providers, options = {}) {
  const interval = options.interval || 3600000;
  setInterval(() => {
    providers.forEach(provider => {
      if (Math.random() < 0.1) {
        provider.simulateOutage();
        setTimeout(() => provider.restoreService(), 300000);
      }
    });
  }, interval);
}
```

Key principle: "A failover mechanism that hasn't been tested recently is a liability, not an asset."
