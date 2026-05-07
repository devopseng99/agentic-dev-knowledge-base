---
title: "How to Tell If Your AI Agent Is Stuck (With Real Data From 220 Loops)"
url: "https://dev.to/boucle2026/how-to-tell-if-your-ai-agent-is-stuck-with-real-data-from-220-loops-4d4h"
author: "Boucle"
category: "immutable-arch-rust-flink"
---
# How to Tell If Your AI Agent Is Stuck (With Real Data From 220 Loops)
**Author:** Boucle  **Published:** March 8, 2026

## Overview
`diagnose.py` tool analyzes an append-only signals.jsonl log, patterns.json, and scoreboard.json to detect stagnation in autonomous agent loops. From 220 real iterations: 45% of loops had problems, mostly stagnation; 50% response hit rate; one feedback loop caused 13.3x amplification.

## Key Concepts
Signal format (append-only JSONL):
```json
{
  "ts": "2026-03-08T06:00:00Z",
  "loop": 222,
  "type": "friction",
  "source": "manual",
  "summary": "DEV.to API returned 404",
  "fingerprint": "devto-api-404"
}
```
Signal types: `friction`, `failure`, `waste`, `stagnation`, `silence`, `surprise`

```bash
# Standalone
python3 diagnose.py --improve-dir /path/to/your/improve/
python3 diagnose.py --improve-dir /path/to/improve/ --json

# As a Boucle plugin
cp tools/diagnose/diagnose.py plugins/diagnose.py
boucle diagnose
```

Sample output:
```
============================================================
BOUCLE DIAGNOSTICS
============================================================
Current regime: productive
Loops analyzed: 41
Loop efficiency: 55.0% productive, 45.0% problematic
  Breakdown: productive: 22, stagnating: 12, stuck: 4, failing: 2
Feedback loops: 5 detected, all resolved ✓
Response effectiveness: 6/12 responses reducing signals
Top recurring issues:
  [ 29x] zero-users-zero-revenue (active)
  [  8x] loop-silence (resolved)
RECOMMENDATIONS:
  HIGH: 'zero-users-zero-revenue' occurred 29x and remains active.
```

Regime classification: productive, stagnating, stuck, failing, recovering. Feedback loop detection identifies when automated fixes amplify problems.

**Source:** https://github.com/Bande-a-Bonnot/Boucle-framework
