---
title: "YOLOv8 + CoreML on iOS: Shipping Offline Computer Vision That Actually Works in the Field"
url: "https://dev.to/toddsullivan/yolov8-coreml-on-ios-shipping-offline-computer-vision-that-actually-works-in-the-field-3e22"
author: "Todd Sullivan"
category: "robot-perception"
---
# YOLOv8 + CoreML on iOS: Shipping Offline Computer Vision That Actually Works in the Field
**Author:** Todd Sullivan  **Published:** May 1, 2026

## Overview
Sullivan documents deploying YOLOv8 nano via CoreML for an offline livestock-counting application. The piece examines practical challenges in on-device vision, including confidence threshold tuning and coordinate system conversions.

## Key Concepts
- **On-device inference advantages:** No cloud dependency, reduced latency, privacy preservation
- **Model selection:** YOLOv8 nano (~6MB) chosen for Neural Engine compatibility and acceptable COCO accuracy
- **Confidence threshold tuning:** Lowered from default 0.35-0.45 to 0.25 to capture partially-occluded subjects
- **Editable results philosophy:** Allow user correction of false positives rather than pursuing perfect detection
- **Tap-to-identify workflow:** Users identify object class by tapping; app returns all same-class detections

```python
pip install ultralytics coremltools
yolo export model=yolov8n.pt format=coreml nms=True
```

```swift
let config = MLModelConfiguration()
config.computeUnits = .all  // prefer Neural Engine

let mlModel = try MLModel(contentsOf: modelURL, configuration: config)
let vnModel = try VNCoreMLModel(for: mlModel)

let request = VNCoreMLRequest(model: vnModel)
request.imageCropAndScaleOption = .scaleFit

let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation)
try handler.perform([request])

let results = request.results as? [VNRecognizedObjectObservation]
```

```swift
// Vision uses bottom-left origin; UIKit uses top-left
let visionPoint = CGPoint(x: normalisedPoint.x, y: 1.0 - normalisedPoint.y)

let tapped = observations
    .filter { $0.boundingBox.contains(visionPoint) }
    .max(by: { $0.confidence < $1.confidence })
```

Performance: 50-80ms inference on 640px image on modern iPhone
