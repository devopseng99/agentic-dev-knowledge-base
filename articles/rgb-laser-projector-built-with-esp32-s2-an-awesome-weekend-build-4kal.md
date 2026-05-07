---
title: "RGB Laser Projector Built with ESP32-S2 — An Awesome Weekend Build"
url: "https://dev.to/bittobuild/rgb-laser-projector-built-with-esp32-s2-an-awesome-weekend-build-4kal"
author: "Bit to Build"
category: "esp32-hardware"
---
# RGB Laser Projector Built with ESP32-S2 — An Awesome Weekend Build

**Author:** Bit to Build  **Published:** 2026-05-06

## Overview

A creative weekend electronics project featuring an RGB laser display system built around an ESP32-S2 microcontroller. Developers Breq and Mia built a vector-based laser projector capable of rendering graphics and games on walls using galvanometer-driven mirror systems.

## Key Concepts

- **Galvanometers (Galvos)**: Rapidly-moving mirrors that redirect laser beams; achieve 20,000 points/second scanning rate
- **RGB Laser Module**: Combined red, green, and blue laser diodes with dichroic mirrors for full-color output
- **ESP32-S2 DAC Integration**: Built-in digital-to-analog converters drive the galvo control signals directly — no external DAC needed
- **Vector Display**: Graphics rendered as paths rather than raster pixels; ideal for text, SVG graphics, and line art
- **AliExpress Sourcing**: Core components sourced affordably; safety glasses are the most expensive component

## Capabilities

- Play Asteroids via wall projection with Wiimote controller support
- Render decorative laser clocks with real-time NTP sync
- Display text and SVG vector graphics
- Create audio-reactive Lissajous pattern light displays
- Custom animations at 20,000 points/second

## ESP32-S2 Key Features Used

- Dual DAC channels at 8-bit resolution (for X/Y galvo control)
- SPI for RGB laser modulation
- WiFi for remote control and NTP time sync
- Compact form factor fits in small projector enclosure

## Safety Notes

- **Laser safety glasses required**: Class 3B/4 laser diodes can cause permanent eye damage
- Interlocks recommended to prevent laser firing when enclosure is open
- Never point laser at people or reflective surfaces

## Community Resources

Well-documented project from Breq and Mia with full hardware schematics, firmware, and build guides.
