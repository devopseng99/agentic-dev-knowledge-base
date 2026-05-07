---
title: "Building an AI-Agent Decision Engine for Self-Healing To Protect Uptime (Part 1)"
url: "https://dev.to/tomcao2012/building-an-ai-agent-decision-engine-for-self-healing-to-protect-uptime-part-1-1-2m7o"
author: "Tom"
category: "self-healing-agent"
---
# Building an AI-Agent Decision Engine for Self-Healing To Protect Uptime (Part 1)
**Author:** Tom  **Published:** July 7, 2025

## Overview
AI-driven infrastructure management shifting from reactive monitoring to proactive self-healing. Principle: "Uptime First, Human Intervention When Necessary."

## Key Concepts

### Decision Thresholds
**Emergency Healing (automatic):**
- Disk usage > 65%
- Memory usage > 65%
- Single processes consuming > 30% CPU for 5+ minutes
- Critical service failures

**Notify Only (human review):**
- Performance degradation with functional services
- Temporary spikes with potential self-resolution

### Step 1: Alert Reception and Enrichment
```javascript
const alerts = items[0].json.body.alerts || [];
return alerts.map(alert => {
  const startsAt = new Date(alert.startsAt);
  const hour = startsAt.getUTCHours();
  const isBusinessHours = hour >= 9 && hour < 17;
  const durationMinutes = (Date.now() - startsAt.getTime()) / 1000 / 60;
  return { json: {
    alertname: alert.labels.alertname,
    severity: alert.labels.severity,
    instance: alert.labels.instance,
    description: alert.annotations.description,
    isBusinessHours: isBusinessHours,
    durationMinutes: durationMinutes
  }};
});
```

### Step 2: AI-Powered Triage
```
Analyze this alert and decide: EMERGENCY_HEALING or NOTIFY_ONLY

Respond with JSON:
{
  "decision": "EMERGENCY_HEALING|NOTIFY_ONLY",
  "threat_level": "CRITICAL|HIGH|MEDIUM|LOW",
  "immediate_actions": [{"command": "...", "purpose": "..."}],
  "reasoning": "Why this decision ensures system survival"
}
```

### Step 4: Safe Command Execution
```javascript
function validateCommand(command, riskLevel) {
  const dangerousPatterns = ['rm -rf /', 'shutdown', 'reboot', 'mkfs'];
  const isDangerous = dangerousPatterns.some(pattern =>
    command.toLowerCase().includes(pattern));
  if (isDangerous || riskLevel === 'RISKY') {
    return { safe: false, reason: `Blocked: ${command}` };
  }
  return { safe: true };
}
```

### Workflow Architecture
```
Prometheus Alert → AI Triage → System Analysis (SSH) → AI Remediation Planning → Safe Execution → Discord Notification
```

### Safety Mechanisms
1. Command Pattern Blocking
2. Risk Level Assessment (SAFE/MODERATE/RISKY)
3. Business Hours Consideration
4. Execution Ordering
5. Audit Trails
