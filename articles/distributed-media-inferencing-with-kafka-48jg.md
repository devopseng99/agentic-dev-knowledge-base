---
title: "Distributed Media Inferencing with Kafka"
url: "https://dev.to/jayash_tripathy_921c22d37/distributed-media-inferencing-with-kafka-48jg"
author: "Jayash Tripathy"
category: "flink-kafka-agents"
---

# Distributed Media Inferencing with Kafka
**Author:** Jayash Tripathy
**Published:** November 6, 2025

## Overview
Multi-threaded Kafka consumer system that pulls messages and runs YOLO11 inference for Vision AI applications. Decouples frame extraction from inference using Kafka's event-driven architecture, enabling independent scaling and fault tolerance.

## Key Concepts

### Producer: Frame Extraction

```python
def start(self, media_paths):
    with ThreadPoolExecutor(max_workers=10) as executor:
        futures = [
            executor.submit(self.produce_media_frames, media_path)
            for media_path in media_paths
        ]
```

Key design: send only lightweight JSON metadata to Kafka (video name + frame number), store actual frames on disk. JPEG images exceed 100KB each -- keeping Kafka messages small maintains throughput.

### Consumer: YOLO11 Inference

```python
# Per consumer thread:
message = kafka_consumer.poll()
metadata = json.loads(message)
frame_path = f"media/raw_frames/{metadata.video_name}/{metadata.frame_no}.jpg"
frame_image = load_from_disk(frame_path)

model = YOLO("yolo11n.pt")
detections = model.predict(frame_image)
annotated_frame = draw_detections(detections)
save_to_disk(annotated_frame, output_path)
kafka_consumer.commit()
```

### Kafka Topic Setup

```python
def setup():
    admin = AdminClient({"bootstrap.servers": kafka_config.bootstrap_servers})
    admin.create_topics([NewTopic(kafka_config.frame_topic, 3, 1)])
```

3 partitions enable parallel processing:
```
Partition 0 -> Consumer Thread 1 -> GPU/CPU -> Annotated Frames
Partition 1 -> Consumer Thread 2 -> GPU/CPU -> Annotated Frames
Partition 2 -> Consumer Thread 3 -> GPU/CPU -> Annotated Frames
```

### Architecture Benefits
- Asynchronous decoupling of extraction and inference
- Horizontal scaling: add producers for high video input, add inference workers for slow processing
- Fault tolerance: continued operation if one process fails
- Consumer groups provide automatic load balancing and rebalancing
