---
title: "DIY Telegram-Controlled ESP32 Security Cam"
url: "https://dev.to/a_c/diy-telegram-controlled-esp32-security-cam-2mac"
author: "A C"
category: "esp32-hardware"
---
# DIY Telegram-Controlled ESP32 Security Cam

**Author:** A C  **Published:** 2025-07-24

## Overview

Building a remotely-controllable security camera using ESP32-CAM that receives commands via Telegram bot and sends images on demand or on motion trigger. Complete implementation with Telegram Bot API integration.

## Key Concepts

- **Telegram Bot API**: Free real-time messaging API for IoT device control
- **ESP32-CAM OV2640**: Camera module with built-in ESP32 microcontroller
- **Async Bot Polling**: ESP32 polls Telegram's getUpdates endpoint for new commands
- **Command-Response Pattern**: Bot receives `/snap` → ESP32 captures JPEG → sends back via Telegram
- **Motion-Triggered Push**: PIR sensor triggers auto-send without user command
- **UniversalTelegramBot Library**: Arduino library wrapping Telegram Bot API

## Telegram Command Handler

```cpp
#include <UniversalTelegramBot.h>
#include "esp_camera.h"

WiFiClientSecure client;
UniversalTelegramBot bot(BOT_TOKEN, client);

void handleNewMessages(int numNewMessages) {
    for (int i = 0; i < numNewMessages; i++) {
        String chat_id = bot.messages[i].chat_id;
        String text = bot.messages[i].text;
        
        if (text == "/snap") {
            camera_fb_t *fb = esp_camera_fb_get();
            if (fb) {
                bot.sendPhotoByBinary(
                    chat_id, "image/jpeg",
                    fb->len, fb->buf
                );
                esp_camera_fb_return(fb);
            }
        } else if (text == "/start") {
            bot.sendMessage(chat_id, "ESP32-CAM Bot ready!\n/snap - Take photo");
        }
    }
}
```

## Main Loop

```cpp
void loop() {
    // Check PIR sensor
    if (digitalRead(PIR_PIN) == HIGH && !motionActive) {
        camera_fb_t *fb = esp_camera_fb_get();
        bot.sendMessage(CHAT_ID, "Motion detected!");
        bot.sendPhotoByBinary(CHAT_ID, "image/jpeg", fb->len, fb->buf);
        esp_camera_fb_return(fb);
        motionActive = true;
    }
    
    // Poll Telegram every 1 second
    if (millis() - lastBotTime > 1000) {
        int numMessages = bot.getUpdates(bot.last_message_received + 1);
        handleNewMessages(numMessages);
        lastBotTime = millis();
    }
}
```

## Security Considerations

- Use HTTPS for Telegram API (WiFiClientSecure)
- Store bot token in NVS, not source code
- Whitelist allowed chat IDs to prevent unauthorized access
