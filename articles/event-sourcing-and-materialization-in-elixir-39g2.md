---
title: "Event Sourcing and Materialization in Elixir"
url: "https://dev.to/matheuscamarques/event-sourcing-and-materialization-in-elixir-39g2"
author: "Matheus de Camargo Marques"
category: "immutable-arch-rust-flink"
---
# Event Sourcing and Materialization in Elixir
**Author:** Matheus de Camargo Marques  **Published:** March 17, 2026

## Overview
Part 4 of 5 in the "CQRS and architecture for AI agents" series. Event Sourcing records every change as an immutable domain event in an append-only log. Current state derives from replaying all past events. Elixir/BEAM Actor model and the Commanded library suit CQRS/ES applications. Bumblebee integrates Hugging Face models for semantic embeddings at event ingestion.

## Key Concepts
- Immutable domain events in append-only log
- Cryptographic auditability and time travel
- Optimistic locking for concurrent AI agents (aggregate versioning)
- Asynchronous projectors updating read models (MongoDB, PostgreSQL, Pinecone)

```elixir
defmodule Trips4you.Finance.Commands do
  @moduledoc "Entry point for Commands that change reality."

  def liquidate_group_with_wallets(scope, group_id, opts \\ []) do
    Commanded.Commands.Router.dispatch(%LiquidateGroupWithWallets{
      scope: scope,
      group_id: group_id,
      opts: opts
    })
  end
end
```

- `execute/2` pure functions validate business rules
- Events emit upon acceptance (e.g., `%GroupLiquidated{}`)
- **AshCommanded**: Combines Ash framework declarative DSL with Commanded foundation
- **Bumblebee** + pgvector: generates semantic embeddings at event ingestion, persists into pgvector via Ecto extension (`Pgvector.Ecto.Vector`)
