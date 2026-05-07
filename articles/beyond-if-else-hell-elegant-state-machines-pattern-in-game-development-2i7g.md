---
title: "Beyond If-Else Hell: Elegant State Machine pattern in Game Development"
url: "https://dev.to/niraj_gaming/beyond-if-else-hell-elegant-state-machines-pattern-in-game-development-2i7g"
author: "Niraj Vishwakarma"
category: "agent-state-machine"
---

# Beyond If-Else Hell: Elegant State Machine pattern in Game Development

**Author:** Niraj Vishwakarma
**Published:** April 17, 2025

## Overview
Explains the State pattern as a behavioral design pattern for game development, enabling objects to modify behavior based on internal state changes. Demonstrates with AI/NPC agent states including Sleep, Patrol, Chase, and Hurt.

## Key Concepts

### Core Definitions
- State: the current condition of an object or system
- Finite state machine: a finite number of states with transitions between them based on inputs

### State Components
1. **Entry** - initialization when entering a state
2. **Exit** - cleanup when leaving a state
3. **Update loop** - continuous processing logic

### Implementation (C#)

```csharp
public abstract class CharacterState
{
    public abstract void EnterState(CharacterController controller);
    public abstract void Update(CharacterController controller);
    public abstract void ExitState(CharacterController controller);
}
```

```csharp
public class AttackingState : CharacterState
{
    public override void EnterState(CharacterController controller) { }
    public override void Update(CharacterController controller) { }
    public override void ExitState(CharacterController controller) { }
}
```

```csharp
public class CharacterController
{
    private CharacterState currentState;

    public void ChangeState(CharacterState newState)
    {
        if (currentState != null) { currentState.ExitState(this); }
        currentState = newState;
        currentState.EnterState(this);
    }

    public void Update()
    {
        if (currentState != null) { currentState.Update(this); }
    }
}
```

This promotes flexible and modular design for managing game entity behavior transitions, replacing deeply nested if-else chains.
