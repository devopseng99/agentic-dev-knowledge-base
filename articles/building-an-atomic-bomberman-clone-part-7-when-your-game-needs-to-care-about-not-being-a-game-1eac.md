---
title: "When Your Game Needs to Care About Not Being a Game (Bomberman Clone Part 7)"
url: "https://dev.to/tomerl1/building-an-atomic-bomberman-clone-part-7-when-your-game-needs-to-care-about-not-being-a-game-1eac"
author: "tomerl1"
category: "gaming-agents"
---
# When Your Game Needs to Care About Not Being a Game (Bomberman Clone Part 7)
**Author:** Tomer Levy  **Published:** April 13, 2026

## Overview
Describes implementing a lobby system, ready mechanism, and round loop for an Atomic Bomberman clone. Transforms a "tech demo" into a playable multiplayer experience with proper game phases using a Rust state machine enum.

## Key Concepts
- **State Machine Pattern**: Rust enum modeling three game phases (Lobby, Playing, RoundOver) — phase-specific data exists only when relevant, enforced by compiler
- **Mutex Management & Deadlocks**: Holding a players mutex across async await points blocks connection handling — must lock late, release early
- **Guard Reuse**: Leverages existing `alive: false` field to prevent player actions during lobby phase rather than adding new conditionals
- **Stale Closures in React**: WebSocket message handler capturing outdated state values from closure scope — fix with functional setState
- **State Transition Side Effects**: Explosions must finish animating even as game transitions to RoundOver phase — visual continuity requires careful timing

```rust
// Game State Enum — compiler enforces phase-appropriate data
enum GameState {
    Lobby,
    Playing,
    RoundOver { timer: u64, winner_id: Option<u8> },
}
```

```rust
// RoundOver State Handling
GameState::RoundOver { ref mut timer, ref mut winner_id } => {
    *timer -= 1;
    // ...
}
```

```rust
// Deadlock Fix — lock scoping
// Acquire mutex, do work, drop guard BEFORE await
// Never hold lock across async await points
```

```rust
// Bomb struct with walkthrough immunity for placer
pub struct Bomb {
    pub row: usize,
    pub col: usize,
    pub timer: f64,
    pub fire_range: u32,
    pub walkthrough_player: Option<u8>, // placer can walk through their own bomb
}
```

```javascript
// React stale closure fix — functional setState
setPhase((prev) => (prev === "lobby" ? "playing" : prev));
```

## Technical Lessons
- Lock Late, Release Early: Microsecond-duration locks prevent blocking in async game loops
- Compiler-Enforced Correctness: Rust enums prevent accessing phase-specific data outside valid phase
- Unit Tests Caught Inverted Condition Bug: "Why is the winner teleporting?"
