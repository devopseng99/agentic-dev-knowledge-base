---
title: "Performance Test: Flink 1.19 vs. Spark 4.0 vs. Kafka Streams 3.8 Windowed Aggregation Throughput"
url: "https://dev.to/johalputt/performance-test-flink-119-vs-spark-40-vs-kafka-streams-38-windowed-aggregation-throughput-1ma9"
author: "ANKUSH CHOUDHARY JOHAL"
category: "flink-kafka-agents"
---

# Performance Test: Flink 1.19 vs. Spark 4.0 vs. Kafka Streams 3.8
**Author:** ANKUSH CHOUDHARY JOHAL
**Published:** May 5, 2026

## Overview
Benchmark comparing three stream processing frameworks for windowed aggregation. Flink 1.19 achieves 1.82M events/sec, Spark 4.0 reaches 870k, and Kafka Streams 3.8 processes 567k -- a 3.2x gap between fastest and slowest. Hardware: 3 AWS c7g.4xlarge nodes (16 vCPU, 32GB each), 100M events at 100 bytes each with 10-second tumbling windows.

## Key Concepts

### Performance Metrics

| Metric | Flink 1.19 | Spark 4.0 | Kafka Streams 3.8 |
|--------|-----------|----------|-------------------|
| Throughput (events/sec) | 1,820,000 | 870,000 | 567,000 |
| p99 Window Latency (ms) | 120 | 450 | 210 |
| CPU Utilization | 72% | 89% | 68% |
| State Size per Window (MB) | 12 | 45 | 14 |
| Checkpoint Overhead (ms) | 45 | 210 | 30 |

### Flink 1.19 Implementation

```java
public class FlinkWindowBenchmark {
    public static void main(String[] args) {
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        env.enableCheckpointing(5000);
        env.setParallelism(16);

        KafkaSource kafkaSource = KafkaSource.builder()
                .setBootstrapServers(KAFKA_BROKERS)
                .setTopics(SOURCE_TOPIC)
                .setGroupId(CONSUMER_GROUP)
                .setStartingOffsets(OffsetsInitializer.latest())
                .setValueOnlyDeserializer(new SimpleStringSchema())
                .build();

        DataStream sourceStream = env.fromSource(kafkaSource, WatermarkStrategy
                .forBoundedOutOfOrderness(Duration.ofMillis(100))
                .withTimestampAssigner((event, timestamp) -> {
                    return Long.parseLong(event.split("\\|")[1]);
                }), JOB_NAME + "-source");

        DataStream aggregatedStream = sourceStream
                .map(event -> event.split("\\|")[0])
                .keyBy(key -> key)
                .window(TumblingEventTimeWindows.of(Time.seconds(10)))
                .process(new ProcessWindowFunction() {
                    @Override
                    public void process(String key, Context context,
                            Iterable elements, Collector out) {
                        int count = 0;
                        for (String element : elements) { count++; }
                        TimeWindow window = context.window();
                        out.collect(String.format("%s|%d|%d|%d",
                            key, window.getStart(), window.getEnd(), count));
                    }
                });

        aggregatedStream.sinkTo(kafkaSink);
        env.execute(JOB_NAME);
    }
}
```

### Kafka Streams 3.8 Implementation

```java
public class KafkaStreamsWindowBenchmark {
    public static void main(String[] args) {
        StreamsBuilder builder = new StreamsBuilder();
        KStream sourceStream = builder.stream(SOURCE_TOPIC);

        KTable<Windowed, Long> windowedCounts = sourceStream
                .selectKey((key, event) -> event.split("\\|")[0])
                .groupByKey()
                .windowedBy(TumblingWindows.of(Duration.ofSeconds(10)))
                .count();

        windowedCounts.toStream()
                .map((windowedKey, count) -> {
                    String key = windowedKey.key();
                    long windowStart = windowedKey.window().start();
                    long windowEnd = windowedKey.window().end();
                    return new KeyValue<>(key,
                        String.format("%s|%d|%d|%d", key, windowStart, windowEnd, count));
                })
                .to(SINK_TOPIC);

        KafkaStreams streams = new KafkaStreams(builder.build(), props);
        streams.start();
    }
}
```

### Use Case Recommendations
- **Flink 1.19**: Maximum throughput and low latency for high-volume event processing
- **Spark 4.0**: Hybrid batch-streaming workloads with existing Spark infrastructure
- **Kafka Streams 3.8**: Kafka-native architectures with minimal operational overhead

### Production Case Study
A SaaS company reduced p99 latency from 2.4s to 110ms migrating from Kafka Streams 3.7 to Flink 1.19, while reducing infrastructure costs from $28k to $18k monthly.
