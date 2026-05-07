---
title: "The Three Rules That Make Bombs Feel Fair (Bomberman Clone Part 6)"
url: "https://dev.to/tomerl1/building-an-atomic-bomberman-clone-part-6-the-three-rules-that-make-bombs-feel-fair-4cco"
author: "tomerl1"
category: "gaming-agents"
---
# The Three Rules That Make Bombs Feel Fair (Bomberman Clone Part 6)
**Author:** Tomer Levy  **Published:** April 13, 2026

## Overview
Documents the implementation of bomb mechanics in a Rust-based Atomic Bomberman clone. Addresses movement responsiveness through axis-independent collision resolution, establishes three core bomb rules that define fair gameplay, reorganizes the codebase with a dedicated collision module, and debugs visual anomalies revealing emergent rendering behavior.

## Key Concepts
- **Wall Sliding Algorithm**: Independent axis testing allows diagonal movement to partially succeed — natural sliding behavior emerges from structure, not special cases
- **Collision Module Extraction**: `collision.rs` centralizes "can this entity move here?" combining map solidity and bomb position checks
- **Three Bomb Rules**: (1) No Stacking — single bomb per tile max, (2) Bombs Block Movement — all players, (3) Walk-Off Immunity — placers can traverse their own bomb until leaving the tile
- **Ghost Explosions**: Apparent data corruption traced to emergent visual behavior — blast paths crossing at 90 degrees trigger intersection tiles with center-sprite rendering
- **Iterator Pattern**: Rust's `iter().any()` preferred over manual loops for collision checks

```rust
// Axis-Independent Movement Resolution — wall sliding
if can_player_move(player.x, y, ...) {
    resolved_y = y;
}
if can_player_move(x, player.y, ...) {
    resolved_x = x;
}
if can_player_move(x, y, ...) {
    resolved_x = x;
    resolved_y = y;
}
```

```rust
// Single Bomb Per Tile Check
if bombs.iter().any(|b| b.row == row && b.col == col) {
    return; // tile already has a bomb
}
```

```rust
// Unified Movement Validation
pub fn can_player_move(
    x: f64,
    y: f64,
    map: &[TileType],
    bombs: &[Bomb],
    player_id: u8,
) -> bool {
    !is_blocked(x, y, map) && !is_bomb_blocking(x, y, bombs, player_id)
}
```

```rust
// Bomb struct with Walk-Through Immunity for Placer
pub struct Bomb {
    pub row: usize,
    pub col: usize,
    pub timer: f64,
    pub fire_range: u32,
    pub walkthrough_player: Option<u8>, // placer can traverse until they leave tile
}
```

## Key Design Insight
"Wall sliding and diagonal movement aren't two features. They're one algorithm" — emerges from structural design, not explicit case handling.
