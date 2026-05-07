---
title: "Open Source Local LLM Benchmarking and Leaderboards on MacOS"
url: "https://dev.to/uncsoft/open-source-local-ll-benchmarking-and-leaderboards-on-macos-4a28"
author: "JT"
category: "huggingface-llm-agents"
---
# Open Source Local LLM Benchmarking and Leaderboards on MacOS
**Author:** JT  **Published:** March 4, 2026

## Overview
Anubis is a native macOS application designed for benchmarking and comparing local large language models on Apple Silicon machines. The tool integrates with multiple inference backends (Ollama, MLX, LM Studio, etc.) and provides real-time hardware telemetry alongside performance metrics. Users can upload results to a community leaderboard and access an open-source dataset for comparative analysis.

## Key Concepts
1. Three integrated modules: Benchmark (single-model testing), Arena (A/B comparison), Leaderboard (community submissions)
2. Hardware telemetry — real-time GPU/CPU/ANE/DRAM power consumption via IOReport
3. Backend agnostic — supports any OpenAI-compatible endpoint
4. Local-first privacy — "Nothing leaves your machine"
5. Process monitoring — auto-detection of inference processes

## System Requirements
- macOS 15.0 (Sequoia) or later
- Apple Silicon (M1/M2/M3/M4/M5+)
- 8GB minimum unified memory

## Code Examples

### Swift Backend Protocol
```swift
protocol InferenceBackend {
    var id: String { get }
    var displayName: String { get }
    var isAvailable: Bool { get async }

    func listModels() async throws -> [ModelInfo]
    func generate(prompt: String, parameters: GenerationParameters)
        -> AsyncThrowingStream<InferenceChunk, Error>
}
```

### Ollama Setup
```bash
brew install ollama
ollama serve
ollama pull llama3.2:3b
```

### Build Instructions
```bash
git clone https://github.com/uncSoft/anubis-oss.git
cd anubis-oss/anubis
xcodebuild -scheme anubis-oss -configuration Debug build
```

## Architecture Layers
- Presentation: SwiftUI views (MVVM pattern)
- Service: MetricsService, InferenceService, ModelService
- Integration: API clients, IOReportBridge, ProcessMonitor
- Persistence: SQLite via GRDB.swift
