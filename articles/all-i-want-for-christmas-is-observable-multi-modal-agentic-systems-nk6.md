---
title: "All I Want for Christmas is Observable Multi-Modal Agentic Systems"
url: "https://dev.to/launchdarkly/all-i-want-for-christmas-is-observable-multi-modal-agentic-systems-nk6"
author: "Scarlett Attensil"
category: "multi-modal-agent-vision"
---

# All I Want for Christmas is Observable Multi-Modal Agentic Systems

**Author:** Scarlett Attensil (LaunchDarkly)
**Published:** December 17, 2025

## Overview

Demonstrates combining session replay and online evaluations for comprehensive observability of multi-modal AI systems through a holiday pet casting application.

## Key Concepts

### Key Discoveries

**Discovery 1: User Patience Thresholds**
Progress indicators doubled completion rates: 35% without progress steps vs 80% with them after 40 seconds.

**Discovery 2: Session Replay + Evaluations**
Session replay reveals user behavior patterns; online evaluations score AI output quality. Speed-running users received low scores; thoughtful users achieved 96/100 accuracy.

**Discovery 3: Photo Upload Resilience**
33% of photo uploads contained issues (screenshots, blurry images, multiple subjects), but AI remained robust scoring 87-91/100 even with problematic photos.

### SDK Initialization (JavaScript)

```javascript
import { initialize } from 'launchdarkly-js-client-sdk';
import Observability from '@launchdarkly/observability';
import SessionReplay from '@launchdarkly/session-replay';

const ldClient = initialize(clientId, user, {
  plugins: [
    new Observability(),
    new SessionReplay({
      privacySetting: 'strict'
    })
  ]
});
```

### Installation

```javascript
npm install @launchdarkly/observability
npm install @launchdarkly/session-replay
```

### Key Insight

Out-of-the-box evaluation model incorrectly flagged AI-generated costume suggestions as physical safety hazards, accounting for approximately 40% of low evaluation scores. Session replay was needed to distinguish legitimate quality issues from overly cautious evaluation criteria.
