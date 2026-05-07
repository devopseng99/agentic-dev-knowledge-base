---
title: "Implementing Consumer IR Protocols and GPIO Interrupts on ESP32 with JavaScript"
url: "https://dev.to/pavel_kostromin/implementing-consumer-ir-protocols-and-gpio-interrupts-on-esp32-with-javascript-solutions-and-p94"
author: "Pavel Kostromin"
category: "esp32-hardware"
---
# Implementing Consumer IR Protocols and GPIO Interrupts on ESP32 with JavaScript

**Author:** Pavel Kostromin  **Published:** 2026-03-26

## Overview

Running JavaScript on ESP32 via Moddable SDK's XS engine to implement infrared remote control protocols (NEC, Samsung, Sony SIRC) with hardware GPIO interrupts. Demonstrates that JavaScript is a viable language for real-time embedded programming on ESP32.

## Key Concepts

- **Moddable SDK**: Professional JavaScript engine (XS) for microcontrollers — production-grade, not Node.js
- **GPIO Interrupts**: Hardware interrupt service routines for precise timing measurement (required for IR decoding)
- **IR Protocols**: NEC (38kHz carrier), Samsung, Sony SIRC — timing-based binary encoding
- **Pulse Timing**: IR protocol decoded by measuring pulse durations in microseconds
- **XS JavaScript**: Subset of ECMAScript for embedded; supports modules, typed arrays, promises

## IR Decoding in JavaScript

```javascript
import Digital from "pins/digital";
import Timer from "timer";

// NEC Protocol decoder
class NECDecoder {
    constructor(pin) {
        this.timings = new Uint32Array(68); // Max NEC bit count
        this.index = 0;
        this.lastTime = 0;
        
        this.input = new Digital({
            pin: pin,
            mode: Digital.InputPullUp,
            edge: Digital.Rising | Digital.Falling,
            onReadable: () => this.onEdge()
        });
    }
    
    onEdge() {
        const now = Timer.ticks; // Microsecond timer
        const duration = now - this.lastTime;
        this.lastTime = now;
        this.timings[this.index++] = duration;
        
        if (this.index >= 68) {
            this.decode();
            this.index = 0;
        }
    }
    
    decode() {
        // Parse timing array into NEC address + command
        let address = 0, command = 0;
        for (let i = 16; i < 32; i++) {
            if (this.timings[i] > 1500) command |= (1 << (i - 16));
        }
        trace(`Received: address=${address} command=${command}\n`);
    }
}
```

## ESP32 + JavaScript Performance

- Interrupt latency: ~10µs (adequate for IR decoding, which needs ~50µs accuracy)
- XS engine overhead: ~2KB RAM
- Module loading: From flash (SPIFFS equivalent)

## Why JavaScript on ESP32?

- Faster prototyping than C/C++
- Same language as web frontend for full-stack IoT developers
- Moddable SDK used in production consumer electronics
