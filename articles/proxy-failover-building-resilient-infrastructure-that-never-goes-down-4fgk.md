---
title: "Proxy Failover: Building Resilient Infrastructure That Never Goes Down"
url: "https://dev.to/xavier_fok/proxy-failover-building-resilient-infrastructure-that-never-goes-down-4fgk"
author: "Xavier Fok"
category: "multi-cloud-durable"
---

# Proxy Failover: Building Resilient Infrastructure That Never Goes Down
**Author:** Xavier Fok
**Published:** March 8, 2026

## Overview
Implementation guide for multi-provider proxy failover with circuit breakers, health checks, and automatic recovery. Compares single-provider (~7 hours monthly downtime) vs multi-provider (~43 minutes) approaches at 25-50% additional cost.

## Key Concepts

Multi-provider resilient proxy manager:

```python
class ResilientProxyManager:
    def __init__(self):
        self.providers = [
            {"name": "primary", "gateway": "gateway.provider-a.com:8080", "priority": 1, "healthy": True},
            {"name": "secondary", "gateway": "gateway.provider-b.com:8080", "priority": 2, "healthy": True},
            {"name": "tertiary", "gateway": "gateway.provider-c.com:8080", "priority": 3, "healthy": True}
        ]

    def get_proxy(self):
        available = sorted([p for p in self.providers if p["healthy"]], key=lambda p: p["priority"])
        if not available:
            self.reset_all()
            available = self.providers
        return available[0]

    def report_failure(self, provider_name):
        provider = self.get_provider(provider_name)
        provider["consecutive_failures"] += 1
        if provider["consecutive_failures"] >= 3:
            provider["healthy"] = False
            self.schedule_health_check(provider, delay=60)
```

Circuit breaker with CLOSED/OPEN/HALF_OPEN states. Health checker running on background thread with 30-second intervals. Cost analysis: single provider $200/mo with 99% uptime vs multi-provider $250-300/mo with 99.9%+ uptime.
