---
title: "I Compressed GPT-2 to Run on an Arduino"
url: "https://dev.to/aman_sachan_126d19c4a2773/i-compressed-gpt-2-to-run-on-an-arduino-3a3f"
author: "Aman Sachan"
category: "jetson-robotics"
---
# I Compressed GPT-2 to Run on an Arduino
**Author:** Aman Sachan  **Published:** 2026-04-30

## Overview
Presents BitForge, a quantization tool designed to compress large language models for microcontroller deployment. The project addresses an extreme resource disparity: GPT-2 Small requires ~500MB storage while Arduino Uno offers only 2KB RAM and 32KB Flash — a 250,000x gap.

## Key Concepts
- Quantization techniques from 1-bit to 8-bit compression
- Adaptive per-layer bit width optimization
- Pure C99 code generation with zero dependencies
- Target device support: ESP32, Arduino, STM32
- Compression achievement: 8x reduction with 99.3% correlation preservation
- GPT-2 Small: ~500MB storage, Arduino Uno: 2KB RAM / 32KB Flash
- TinyML approach to LLM deployment on microcontrollers

```bash
pip install bitforge
bitforge compress gpt2 --target esp32-s3 --bits 4
```

## GitHub Repos
- https://github.com/AmSach/bitforge
