---
title: "Evolution without Big Bang: Hexagonal, Strangler and Governance"
url: "https://dev.to/matheuscamarques/evolution-without-big-bang-hexagonal-strangler-and-governance-g7i"
author: "Matheus de Camargo Marques"
category: "immutable-arch-rust-flink"
---
# Evolution without Big Bang: Hexagonal, Strangler and Governance
**Author:** Matheus de Camargo Marques  **Published:** March 17, 2026

## Overview
Part 5 of 5 in the "CQRS and architecture for AI agents" series. Hexagonal Architecture (Ports and Adapters) + CQRS + Event Sourcing = essential substrate for large-scale generative automation. Strangler Fig pattern for gradual monolith migration without Big Bang rewrites. Architectural Fitness Functions for continuous governance.

## Key Concepts
- Primary Ports (Driving): REST APIs, queue handlers, AI agents trigger the application
- Secondary Ports (Driven): contracts the domain requires, implemented by Secondary Adapters
- Evolutionary Architectures prioritize evolvability over predictability
- Tools: ArchUnit, NetArchTest, ArchTest for CI/CD structural enforcement

```elixir
defmodule Trips4you.Finance.Ports.LiquidationRepo do
  @callback persist_liquidation(%{group_id: String.t(), amount: integer()})
            :: {:ok, %{liquidation_id: String.t()}} | {:error, term()}

  @callback notify_payments(%{liquidation_id: String.t()}) :: :ok | {:error, term()}
end
```

```elixir
defmodule Trips4you.Finance.Adapters.LiquidationRepo.Postgres do
  @behaviour Trips4you.Finance.Ports.LiquidationRepo

  def persist_liquidation(_attrs) do
    {:ok, %{liquidation_id: "liq_" <> "123"}}
  end

  def notify_payments(%{liquidation_id: _liquidation_id}) do
    :ok
  end
end
```

```elixir
defmodule Trips4you.Finance.Commands.LiquidateGroupWithWallets do
  defstruct [:scope, :group_id, :adapters]

  def execute(%__MODULE__{group_id: group_id, adapters: adapters}) do
    attrs = %{group_id: group_id, amount: 123_00}

    with {:ok, %{liquidation_id: liquidation_id}} <-
           adapters.liquidation_repo.persist_liquidation(attrs),
         :ok <- adapters.liquidation_repo.notify_payments(%{liquidation_id: liquidation_id}) do
      {:ok, liquidation_id}
    end
  end
end
```

Runtime adapter swap without restart:
```elixir
defmodule Trips4you.Finance.AdapterRouter.LiquidationRepo do
  use Agent

  def start_link(_) do
    Agent.start_link(fn ->
      Application.fetch_env!(:trips4you, :liquidation_repo_adapter)
    end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end

  def put(adapter_module) do
    Agent.update(__MODULE__, fn _old -> adapter_module end)
  end
end
```
