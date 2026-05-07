---
title: "Getting started with Apache Flink: A guide to stream processing"
url: "https://dev.to/mage_ai/getting-started-with-apache-flink-a-guide-to-stream-processing-e19"
author: "Mage AI"
category: "flink-kafka-agents"
---

# Getting started with Apache Flink: A guide to stream processing
**Author:** Mage AI
**Published:** May 15, 2023

## Overview
Apache Flink is an open-source, high-performance framework designed for large-scale data processing, excelling at real-time stream processing with low-latency and stateful computations. This guide covers setup, key concepts, and a complete Kafka-to-Cassandra word count example.

## Key Concepts

### Complete Code Example: Kafka to Cassandra Word Count

```java
import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.connectors.cassandra.CassandraSink;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer;
import org.apache.flink.util.Collector;
import org.apache.kafka.common.serialization.SimpleStringSchema;
import java.util.Properties;

public class KafkaToCassandraExample {
    public static void main(String[] args) throws Exception {
        final StreamExecutionEnvironment env =
            StreamExecutionEnvironment.getExecutionEnvironment();

        Properties properties = new Properties();
        properties.setProperty("bootstrap.servers", "localhost:9092");
        properties.setProperty("group.id", "test");

        DataStream<String> stream = env.addSource(
            new FlinkKafkaConsumer<>("topic", new SimpleStringSchema(), properties));

        DataStream<Tuple2<String, Integer>> processedStream = stream
                .flatMap(new Tokenizer())
                .keyBy(0)
                .sum(1);

        CassandraSink.addSink(processedStream)
                .setQuery("INSERT INTO wordcount.word_count (word, count) values (?, ?);")
                .setHost("127.0.0.1")
                .build();

        env.execute("Kafka to Cassandra Word Count Example");
    }

    public static final class Tokenizer implements FlatMapFunction<String, Tuple2<String, Integer>> {
        @Override
        public void flatMap(String value, Collector<Tuple2<String, Integer>> out) {
            String[] words = value.toLowerCase().split("\\W+");
            for (String word : words) {
                if (word.length() > 0) {
                    out.collect(new Tuple2<>(word, 1));
                }
            }
        }
    }
}
```

### Flink Key Concepts
- **DataStream API**: Primary tool for stream applications
- **Windows**: Finite sets of events (count, time, or session based)
- **Event Time vs Processing Time**: Event time is when events occurred; processing time is system clock
- **Watermarks**: Mechanisms for handling late and out-of-order events
- **Checkpoints/Savepoints**: Fault tolerance and state management
- **CEP**: Complex Event Processing for pattern detection
- **StateFun**: Distributed stateful applications framework
