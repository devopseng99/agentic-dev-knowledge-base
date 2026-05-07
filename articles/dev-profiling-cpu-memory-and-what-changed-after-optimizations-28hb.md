---
title: "Dev profiling: CPU, memory, and what changed after optimizations"
url: "https://dev.to/matheuscamarques/dev-profiling-cpu-memory-and-what-changed-after-optimizations-28hb"
author: "Matheus de Camargo Marques"
category: "code-optimization"
---
# Dev profiling: CPU, memory, and what changed after optimizations
**Author:** Matheus de Camargo Marques  **Published:** March 20, 2026

## Overview
Practical guidance on development profiling within an Elixir monorepo. Emphasizes reproducible load testing and using OTP profilers to measure optimization impact without self-deception. "Every improvement must be validated through paired profiling runs using identical commits, environments, and configuration knobs."

## Key Concepts

### Profiler Tools and Their Purposes

| Tool | Purpose |
|------|---------|
| cprof | Identifies functions with highest call frequency |
| eprof | Shows time spent within a specific process |
| fprof | Displays call graphs with timing information |
| tprof (OTP 27+) | Aggregates time, calls, or allocation across processes |

### Critical Methodology
"Publishing a performance claim without reproducible side-by-side measurements constitutes storytelling rather than benchmarking."

### Baseline Configurations
- Light server: `PHX_LV_DEBUG=0 SIMULACOES_TSDB_ENABLED=false AUTO_START_MONTE_CARLO=false`
- Heavy server: `PHX_LV_DEBUG=1 SIMULACOES_TSDB_ENABLED=true AUTO_START_MONTE_CARLO=true`

## Key Code Examples

```elixir
# PipelineWorkload structure for reproducible load testing
def run(opts \\ []) when is_list(opts) do
    duration_ms = Keyword.get(opts, :duration_ms) || env_duration_ms()
    ticks = Keyword.get(opts, :ticks, env_int("PROFILE_PIPELINE_TICKS", 30))
    max_ticks = Keyword.get(opts, :max_ticks, env_int("PROFILE_PIPELINE_MAX_TICKS", 5_000_000))
    mode = Keyword.get(opts, :mode, mode_from_env())
    memory? = Keyword.get(opts, :memory, env_bool("PROFILE_PIPELINE_MEMORY", false))

    {:ok, _} = Application.ensure_all_started(:simulacoes_visuais)
    if memory?, do: print_memory_section("before")
    # ... run workload
    if memory?, do: print_memory_section("after")
    :ok
end
```

```bash
# Call-count profiling (120-second window, TSDB off)
PROFILE_PIPELINE_DURATION_MS=120000 LOGGER_LEVEL=warning \
  SIMULACOES_TSDB_ENABLED=false \
  mix profile.cprof -e "SimulacoesVisuais.Profile.PipelineWorkload.run()" \
  | tee tmp/profile/cprof-sample.txt

# Module-specific profiling
mix profile.cprof --module SimulacoesVisuais.SmartBreweryMonteCarlo \
  -e "SimulacoesVisuais.Profile.PipelineWorkload.run()"

# Memory snapshots only
PROFILE_PIPELINE_MEMORY=1 PROFILE_PIPELINE_TICKS=30 \
  mix profile.pipeline

# OTP 27+ aggregated time profiling
PROFILE_PIPELINE_DURATION_MS=120000 LOGGER_LEVEL=warning \
  mix profile.tprof --type time --report total \
  -e "SimulacoesVisuais.Profile.PipelineWorkload.run()"

# fprof trace file
mix profile.fprof -e "SimulacoesVisuais.Profile.PipelineWorkload.run()" \
  --trace-to-file tmp/profile/run.trace \
  | tee tmp/profile/fprof-out.txt
```

## Environment Variables

```
PROFILE_PIPELINE_TICKS           Fixed tick count
PROFILE_PIPELINE_DURATION_MS     Wall-clock runtime limit
PROFILE_PIPELINE_MAX_TICKS       Safety ceiling for duration mode
PROFILE_PIPELINE_MODE            via_genserver | in_process
PROFILE_PIPELINE_MEMORY          Enable memory snapshots (1/true)
SIMULACOES_TSDB_ENABLED          Database on/off scenario
LOGGER_LEVEL                     Reduce noise during long runs
```

## Key Insight
Important: These tools don't provide direct heap maps. RAM pressure requires :erlang.memory/0, Process.info/2, Observer, or LiveDashboard metrics. Optimization as hypothesis: profile before and after with identical conditions.
