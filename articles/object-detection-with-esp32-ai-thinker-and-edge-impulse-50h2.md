---
title: "Object Detection with ESP32-AI Thinker and Edge Impulse"
url: "https://dev.to/darshan_rathod/object-detection-with-esp32-ai-thinker-and-edge-impulse-50h2"
author: "Darshan Rathod"
category: "esp32-hardware"
---
# Object Detection with ESP32-AI Thinker and Edge Impulse

**Author:** Darshan Rathod  **Published:** 2025-03-06

## Overview

Deploying a real-time object detection model on ESP32-AI Thinker using Edge Impulse. Runs on-device inference for visual classification without any cloud connection after deployment.

## Key Concepts

- **ESP32-AI Thinker**: ESP32-CAM variant with OV2640 camera; popular budget ML hardware
- **Edge Impulse Studio**: Cloud-based ML platform for embedded ML; handles training, optimization, deployment
- **FOMO (Faster Objects, More Objects)**: Lightweight object detection model designed for MCUs — runs at 10+ FPS on ESP32
- **Image Preprocessing**: 96×96 RGB images (smaller = more feasible on ESP32's limited RAM)
- **INT8 Quantization**: Required to fit model in 520KB SRAM
- **Centroid Detection**: FOMO outputs object centroids (not bounding boxes) to save computation

## Edge Impulse Pipeline

1. **Data Collection**: Capture labeled images via ESP32-CAM or webcam
2. **Design Impulse**: Set image input block (96×96 RGB) + FOMO object detection block
3. **Train**: Run training on Edge Impulse cloud (GPU-backed)
4. **Deploy**: Export as Arduino library
5. **Flash**: Include library in ESP32 Arduino sketch

## Inference Code

```cpp
#include <your-project_inferencing.h>
#include "edge-impulse-sdk/dsp/image/image.hpp"

// Capture frame from ESP32-CAM OV2640
camera_fb_t *fb = esp_camera_fb_get();

// Run object detection
ei::signal_t signal;
signal.total_length = EI_CLASSIFIER_INPUT_WIDTH * EI_CLASSIFIER_INPUT_HEIGHT;
signal.get_data = &get_signal_data;

ei_impulse_result_t result;
run_classifier(&signal, &result, false);

// Process detections
for (int i = 0; i < EI_OBJECT_DETECTION_COUNT; i++) {
    if (result.bounding_boxes[i].value > 0.5) {
        ei_printf("Found %s at (%.0f, %.0f)\n",
            result.bounding_boxes[i].label,
            result.bounding_boxes[i].x,
            result.bounding_boxes[i].y);
    }
}
```

## Performance on ESP32-CAM

- Model size: ~100KB (INT8 FOMO)
- Inference time: ~100ms (10 FPS)
- RAM usage: ~200KB
- Detectable classes: Up to 10 (limited by training data)
