---
title: "INP Is Not Just a Faster FID"
url: "https://dev.to/nosyos/inp-is-not-just-a-faster-fid-2cg5"
author: "nosyos"
category: "code-optimization"
---
# INP Is Not Just a Faster FID
**Author:** nosyos  **Published:** May 7, 2026

## Overview
Challenges the misconception that Interaction to Next Paint (INP) is merely a faster version of First Input Delay (FID). Optimizing handler performance alone often misses the real bottlenecks. Input delay frequently represents the largest performance barrier yet receives minimal developer attention.

## Key Concepts

### The Three-Phase INP Model
INP measures interactions across three distinct phases:

1. **Input Delay**: Time from user interaction until browser begins processing the event, blocked by main thread work
2. **Processing Time**: Duration while event handlers execute
3. **Presentation Delay**: Time from handler completion until visual updates render (React reconciliation and painting)

The interaction's total duration across all phases determines INP score; the slowest interaction in a session becomes the metric.

### Input Delay Sources (The Hidden Culprit)
- React rendering large lists after search completion
- Synchronous calculations in useEffect
- Timer callbacks scheduled during interactions
- Any main thread work coinciding with user input

### Diagnostic Approach
1. Analyze inputDelay values BEFORE optimizing handler code
2. Identify long tasks during normal page usage cycles
3. Use React DevTools Profiler for high presentation delay cases
4. Address processing time only when it proves the dominant phase

## Key Code Examples

```javascript
// Detect phase breakdowns in production
new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
        if (entry.entryType !== 'event' || entry.duration < 200) continue;

        console.log({
            interaction: entry.name,
            inputDelay: entry.processingStart - entry.startTime,
            processingTime: entry.processingEnd - entry.processingStart,
            presentationDelay: entry.duration - (entry.processingEnd - entry.startTime),
        });
    }
}).observe({ type: 'event', durationThreshold: 100, buffered: true });
```

```javascript
// Break up long tasks with scheduler.yield()
async function processLargeDataset(items) {
    const results = [];

    for (let i = 0; i < items.length; i++) {
        results.push(expensiveTransform(items[i]));

        // Every 50 items, yield to let the browser breathe
        if (i % 50 === 0) {
            await scheduler.yield();  // Chrome/Edge; use setTimeout(0) for others
        }
    }

    return results;
}
```

```javascript
// Long Animation Frames (LoAF) attribution in production
new PerformanceObserver((list) => {
    for (const frame of list.getEntries()) {
        if (frame.duration < 100) continue;

        for (const script of frame.scripts) {
            sendMetric({
                page: location.pathname,
                frameDuration: frame.duration,
                scriptSource: script.sourceURL,
                scriptFunction: script.sourceFunctionName,
                scriptDuration: script.duration,
                invokerType: script.invokerType,  // event listener, setTimeout, Promise, etc.
            });
        }
    }
}).observe({ type: 'long-animation-frame', buffered: true });
```

## Key Insight
`scheduler.yield()` pauses execution to allow browser input handling between work chunks. React's `useTransition` hook specifically addresses presentation delay by deferring non-critical reconciliation work. The Chrome UX Report provides attribution data identifying which phase dominates slow interactions.
