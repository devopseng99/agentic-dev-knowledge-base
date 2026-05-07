---
title: "I Rewrote Pipecat in Rust. Here's What I Learned Building a Voice Agent Framework"
url: "https://dev.to/allen_george_4d037f39d509/i-rewrote-pipecat-in-rust-heres-what-i-learned-building-a-voice-agent-framework-from-scratch-4oj6"
author: "ALLEN GEORGE"
category: "code-optimization"
---
# I Rewrote Pipecat in Rust. Here's What I Learned Building a Voice Agent Framework
**Author:** ALLEN GEORGE  **Published:** May 5, 2026

## Overview
Documents rewriting the Pipecat voice agent framework from Python to Rust, motivated by latency requirements. Voice agents need end-to-end latency under 300ms to feel natural. Python's GIL and garbage collection pauses were causing 50-150ms unexpected spikes at worst times.

## Key Concepts

### Why Rust for Voice Agents
- No GIL: True parallelism for audio processing, STT, LLM, TTS pipeline stages
- No GC pauses: Predictable latency (no 50-150ms stop-the-world collections)
- Zero-cost abstractions: Iterator chains compile to tight loops
- Ownership model: Forces correct resource management for audio buffers

### The Pipeline Architecture
Voice agent pipeline: Audio Input -> VAD (Voice Activity Detection) -> STT -> LLM -> TTS -> Audio Output

Each stage is an async task connected by channels. Rust's tokio enables true concurrency without GIL contention.

### Key Performance Results
- Python Pipecat p50 latency: 180ms, p99: 450ms
- Rust implementation p50 latency: 85ms, p99: 140ms
- 2.1x p50 improvement, 3.2x p99 improvement
- Memory: Python 380MB -> Rust 42MB (9x reduction)

## Key Code Examples

```rust
// Pipeline stage trait - each component implements this
use async_trait::async_trait;
use tokio::sync::mpsc;

#[async_trait]
trait PipelineStage {
    type Input: Send + 'static;
    type Output: Send + 'static;

    async fn process(&mut self, input: Self::Input) -> Option<Self::Output>;
}

// Audio frame type - zero-copy using Arc
use std::sync::Arc;

#[derive(Clone)]
struct AudioFrame {
    samples: Arc<Vec<f32>>,
    sample_rate: u32,
    timestamp_ms: u64,
}
```

```rust
// VAD stage - Voice Activity Detection
use webrtc_vad::Vad;

struct VadStage {
    vad: Vad,
    silence_threshold_ms: u64,
    silence_accumulated_ms: u64,
}

#[async_trait]
impl PipelineStage for VadStage {
    type Input = AudioFrame;
    type Output = AudioChunk;  // Complete utterances

    async fn process(&mut self, frame: AudioFrame) -> Option<AudioChunk> {
        let is_speech = self.vad.is_voice_segment(&frame.samples);

        if !is_speech {
            self.silence_accumulated_ms += 20;  // 20ms frames
            if self.silence_accumulated_ms >= self.silence_threshold_ms {
                // Silence detected - emit accumulated utterance
                return self.flush_utterance();
            }
        } else {
            self.silence_accumulated_ms = 0;
            self.accumulate_frame(frame);
        }
        None
    }
}
```

```rust
// Pipeline orchestrator using tokio channels
async fn run_pipeline(audio_rx: mpsc::Receiver<AudioFrame>) {
    let (vad_tx, vad_rx) = mpsc::channel::<AudioChunk>(32);
    let (stt_tx, stt_rx) = mpsc::channel::<String>(16);
    let (llm_tx, llm_rx) = mpsc::channel::<String>(16);
    let (tts_tx, tts_rx) = mpsc::channel::<AudioFrame>(32);

    // Each stage runs in its own task - true concurrency
    tokio::spawn(vad_stage(audio_rx, vad_tx));
    tokio::spawn(stt_stage(vad_rx, stt_tx));
    tokio::spawn(llm_stage(stt_rx, llm_tx));
    tokio::spawn(tts_stage(llm_rx, tts_tx));
    tokio::spawn(audio_output_stage(tts_rx));
}
```

```rust
// Avoiding allocations in the hot path - reuse buffers
struct AudioProcessor {
    // Pre-allocated buffers, reused across frames
    processing_buffer: Vec<f32>,
    output_buffer: Vec<f32>,
}

impl AudioProcessor {
    fn process_frame(&mut self, input: &[f32]) -> &[f32] {
        // Reuse existing allocation instead of Vec::new()
        self.processing_buffer.clear();
        self.processing_buffer.extend_from_slice(input);

        // Apply processing in place
        apply_noise_reduction(&mut self.processing_buffer);

        self.output_buffer.clear();
        resample(&self.processing_buffer, &mut self.output_buffer, 16000, 24000);

        &self.output_buffer
    }
}
```

## Lessons Learned

1. **Start with channels, optimize to shared memory later** - Channels are safer; profile before switching to Arc<Mutex<>>
2. **Benchmark GC pauses, not just throughput** - Python looked fine in average case
3. **Unsafe is rarely needed** - Tokio + channels handled all concurrency safely
4. **Error handling forces you to think about failure modes** - Rust's Result type caught 3 production bugs during port
5. **Build time is the cost** - 45 second Rust builds vs 0 second Python runs; use incremental compilation
