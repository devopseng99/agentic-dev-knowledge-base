---
title: "Kimi K2.6 vs. Claude Opus 4.7 in a Weird Game Coding Test"
url: "https://dev.to/shricodev/kimi-k26-vs-claude-opus-47-in-a-weird-game-coding-test-2ck3"
author: "shricodev"
category: "gaming-agents"
---
# Kimi K2.6 vs. Claude Opus 4.7 in a Weird Game Coding Test
**Author:** Shrijal Acharya (Composio)  **Published:** May 5, 2026

## Overview
Compares two AI coding models — Kimi K2.6 (cheaper, open model) and Claude Opus 4.7 (premium frontier model) — by tasking both with building a Minetest bounty board system with TypeScript backend and optional Google Sheets integration via Composio. Evaluates functional correctness, code quality, debugging requirements, execution time, and cost.

## Key Concepts
- **Model Positioning**: Opus ($5/$25 per M tokens) vs. Kimi ($0.95/$4 per M tokens) — 5x cost difference
- **Test Architecture**: Minetest/Luanti Lua mod + TypeScript backend + optional Composio Google Sheets integration
- **Evaluation Criteria**: End-to-end functionality, code structure, debugging burden, timing, and cost
- **Results**: Claude Opus produced cleaner code requiring no debugging; Kimi required manual fixes but worked for simpler tasks
- **Composio Integration**: Google Sheets sync as optional feature — Claude succeeded, Kimi failed on complex integration

```bash
# Test 1: Generate Bounty
curl -s -X POST http://localhost:8787/api/bounty/generate \
  -H 'Content-Type: application/json' \
  -d '{"player":"singleplayer","availableTasks":["collect_item"]}' \
  | jq
```

```bash
# Test 1: Complete Bounty
curl -s -X POST http://localhost:8787/api/bounty/complete \
  -H 'Content-Type: application/json' \
  -d "$(jq -nc \
        --argjson b "$(jq .bounty /tmp/b.json)" \
        --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        '{player:"singleplayer", bounty:$b, progress:{current:$b.target.count, required:$b.target.count}, completedAt:$ts}')" \
  | jq
```

```json
{
  "ok": true,
  "message": "Bounty completed.",
  "leaderboard": {
    "player": "singleplayer",
    "points": 8,
    "completedBounties": 1
  },
  "sync": {
    "googleSheets": {
      "ok": true,
      "message": "Google Sheets row appended."
    }
  }
}
```

```conf
# Minetest Config
secure.http_mods = bountyboard
```

## Results Summary

| Metric | Claude Opus 4.7 (T1) | Kimi K2.6 (T1) | Opus (T2) | Kimi (T2) |
|--------|---|---|---|---|
| Cost | $3.59 | $0.39 | $16.03 | $5.03 |
| API Time | 12m 3s | ~9m 27s | 28m 52s | ~25m |
| Outcome | Working | Working (debug needed) | Working | Failed |
| Code Lines | +1,688 | +4,671 | +1,848/-507 | Incomplete |

## GitHub Repository
https://github.com/shricodev/opus-kimi-minetest-game-mod
