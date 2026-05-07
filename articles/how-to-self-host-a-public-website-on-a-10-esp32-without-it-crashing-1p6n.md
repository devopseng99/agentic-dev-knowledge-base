---
title: "How to Self-Host a Public Website on a $10 ESP32 Without It Crashing"
url: "https://dev.to/alanwest/how-to-self-host-a-public-website-on-a-10-esp32-without-it-crashing-1p6n"
author: "Alan West"
category: "esp32-hardware"
---
# How to Self-Host a Public Website on a $10 ESP32 Without It Crashing

**Author:** Alan West  **Published:** 2026-04-21

## Overview

Running a publicly accessible website on an ESP32 microcontroller — reliably. The challenge isn't serving HTML (trivial) but handling concurrent connections, memory exhaustion, and watchdog recovery without crashing.

## Key Concepts

- **ESP32 Web Server**: AsyncWebServer or built-in WiFiServer; async is critical for stability under load
- **Memory Management**: Each HTTP connection uses ~4KB RAM; with 520KB total, max ~10 concurrent connections
- **Connection Limits**: Must explicitly limit concurrent connections to prevent heap exhaustion
- **Watchdog Timer**: Auto-restart on crash; reset reason logging to understand failure modes
- **Dynamic DNS**: Use DuckDNS or similar for public access without static IP
- **Cloudflare Tunnel**: Alternative to port forwarding — tunnels HTTPS to ESP32 on LAN

## AsyncWebServer Setup

```cpp
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>

AsyncWebServer server(80);

void setup() {
    server.on("/", HTTP_GET, [](AsyncWebServerRequest *request) {
        request->send(200, "text/html", html_content);
    });
    
    // Serve static files from SPIFFS
    server.serveStatic("/static", SPIFFS, "/static/");
    
    // 404 handler
    server.onNotFound([](AsyncWebServerRequest *request) {
        request->send(404, "text/plain", "Not found");
    });
    
    server.begin();
}
```

## Memory Safety Pattern

```cpp
// Monitor heap before serving large responses
void serve_heavy_page(AsyncWebServerRequest *request) {
    if (ESP.getFreeHeap() < 20000) {
        request->send(503, "text/plain", "Server busy");
        return;
    }
    // Proceed with response
}
```

## Stability Tricks

1. Use chunked response for large data (avoid single large malloc)
2. Enable PSRAM if available (ESP32-S3 with 8MB PSRAM handles much more)
3. Limit upload size: `server.on("/upload", HTTP_POST, ...)` with size check
4. Use watchdog: `esp_task_wdt_init(30, true)` for 30-second auto-restart
5. Log reset reasons via `esp_reset_reason()` to diagnose crashes
