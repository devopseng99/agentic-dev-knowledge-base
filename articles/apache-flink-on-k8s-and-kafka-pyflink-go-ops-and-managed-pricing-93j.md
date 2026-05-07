---
title: "Apache Flink on K8s and Kafka: PyFlink, Go, ops, and managed pricing"
url: "https://dev.to/rosgluk/apache-flink-on-k8s-and-kafka-pyflink-go-ops-and-managed-pricing-93j"
author: "Rost"
category: "flink-kafka-agents"
---

# Apache Flink on K8s and Kafka: PyFlink, Go, ops, and managed pricing
**Author:** Rost
**Published:** March 24, 2026

## Overview
Comprehensive guide covering Apache Flink for stateful computations over data streams, targeting DevOps and Go/Python developers. Compares deployment models (standalone, K8s, AWS managed, Confluent Cloud), explains core architecture, and provides complete PyFlink and Go integration examples.

## Key Concepts

### PyFlink Kafka Streaming Job

```python
from pyflink.common import Duration, Types
from pyflink.common.serialization import SimpleStringSchema
from pyflink.datastream import StreamExecutionEnvironment
from pyflink.datastream.connectors.kafka import KafkaSource, KafkaSink, KafkaRecordSerializationSchema

class RollingCount(KeyedProcessFunction):
    def open(self, runtime_context):
        desc = ValueStateDescriptor("rolling_count", Types.LONG())
        self.count_state = runtime_context.get_state(desc)

    def process_element(self, value, ctx):
        obj = json.loads(value)
        current = self.count_state.value() or 0
        current += 1
        self.count_state.update(current)
        obj["rolling_count"] = current
        yield json.dumps(obj)

def main():
    env = build_env()
    source = (KafkaSource.builder()
        .set_bootstrap_servers("kafka:9092")
        .set_topics("events.raw")
        .set_group_id("realtime-sessions-v1")
        .set_value_only_deserializer(SimpleStringSchema())
        .build())

    stream = (env.from_source(source, watermark_strategy=watermark_strategy, source_name="kafka-events-raw")
        .key_by(lambda s: json.loads(s)["user_id"])
        .process(RollingCount(), output_type=Types.STRING()))
    stream.sink_to(sink)
    env.execute("realtime-sessions-pyflink")
```

### Kubernetes FlinkDeployment CR

```yaml
apiVersion: flink.apache.org/v1beta1
kind: FlinkDeployment
metadata:
  name: realtime-sessions
spec:
  image: my-registry.example.com/flink/realtime-sessions:2026-03-06
  flinkVersion: v2_2
  flinkConfiguration:
    taskmanager.numberOfTaskSlots: "2"
    state.backend.type: "rocksdb"
    execution.checkpointing.interval: "60 s"
  jobManager:
    resource: { cpu: 1, memory: "2048m" }
  taskManager:
    resource: { cpu: 2, memory: "4096m" }
  job:
    jarURI: local:///opt/flink/usrlib/realtime-sessions.jar
    parallelism: 4
    upgradeMode: savepoint
```

### Go Kafka Producer/Consumer

```go
writer := &kafka.Writer{
    Addr:         kafka.TCP("kafka:9092"),
    Topic:        "events.raw",
    RequiredAcks: kafka.RequireAll,
}
err := writer.WriteMessages(ctx, kafka.Message{
    Key:   []byte("user:u1"),
    Value: []byte(`{"user_id":"u1","event_time_ms":1710000000000,"event":"click"}`),
})
```

### Deployment Options & Pricing
| Option | Best For | Complexity |
|--------|----------|-----------|
| Standalone cluster | Small teams | Medium-High |
| Kubernetes + Operator | Platform teams | Medium |
| AWS Managed Flink | AWS-native | Low-Medium |
| Confluent Cloud Flink | Kafka-first | Low |

### LLM/AI Integration
Flink serves as real-time context builder for LLM systems, producing fresh features, embeddings, and behavioral aggregates. PyFlink supports loading ML models inside Python UDFs for online inference.
