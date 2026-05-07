---
title: "ReductStore v1.19: Open Data Backbone for Robotics and ROS"
url: "https://dev.to/atimin/reductstore-v119-open-data-backbone-for-robotics-and-ros-1efk"
author: "Alexey Timin"
category: "robot-building"
---
# ReductStore v1.19: Open Data Backbone for Robotics and ROS
**Author:** Alexey Timin  **Published:** April 9, 2026

## Overview
ReductStore 1.19.0 introduces major changes including open-source licensing under Apache 2.0, a hierarchical data model supporting nested entry names, and new integration capabilities for robotics systems. The release emphasizes structured data storage without flattening topic hierarchies.

## Key Concepts
1. **Apache 2.0 Licensing** - ReductStore Core is now open source
2. **Hierarchical Data Model** - Path-based organization similar to ROS topics and Zenoh key expressions
3. **Entry Attachments** - Storage of schemas and metadata preserving downstream context
4. **Zenoh Native API** - Direct ingestion and querying over Zenoh protocol
5. **ReductBridge** - New ROS1/ROS2 integration with automatic message labeling

```bash
docker pull reduct/store:v1.19.0
docker run \
 --env "RS_ZENOH_ENABLED=ON" \
 --env "RS_ZENOH_CONFIG={}" \
 --env "RS_ZENOH_SUB_KEYEXPRS=**" \
 -p 8383:8383 -p 36597:36597 -p 7446:7446 reduct/store:v1.19.0
```

```python
import json
import zenoh

KEY = "factory/line1/camera"
PAYLOAD = b"<binary payload>"
LABELS = {"robot": "alpha", "status": "ok"}

with zenoh.open(zenoh.Config()) as session:
    session.put(
        KEY,
        PAYLOAD,
        attachment=json.dumps(LABELS).encode(),
    )
```

```python
import json
import zenoh

KEY = "factory/line1/when-query"
CONSOLIDATION = zenoh.ConsolidationMode.NONE
attachment = json.dumps({"when": {"&status": {"$eq": "ok"}}}).encode()

with zenoh.open(zenoh.Config()) as session:
    replies = [
        reply
        for reply in session.get(
            KEY,
            timeout=5.0,
            attachment=attachment,
            consolidation=CONSOLIDATION,
        )
        if reply.ok
    ]

    for reply in replies:
        print(reply.ok.payload.to_bytes())
```

GitHub: https://github.com/reductstore/reductstore/releases/tag/v1.19.0
GitHub (ReductBridge): https://github.com/reductstore/reduct-bridge
