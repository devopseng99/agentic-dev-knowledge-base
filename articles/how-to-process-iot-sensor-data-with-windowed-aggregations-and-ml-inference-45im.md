---
title: "How To Process IoT Sensor Data with Windowed Aggregations and ML Inference"
url: "https://dev.to/sudoconsultants/how-to-process-iot-sensor-data-with-windowed-aggregations-and-ml-inference-45im"
author: "Sidra Saleem"
category: "immutable-arch-rust-flink"
---
# How To Process IoT Sensor Data with Windowed Aggregations and ML Inference
**Author:** Sidra Saleem  **Published:** February 28, 2025

## Overview
Real-time analytics pipeline for IoT sensor data: Amazon Kinesis → Amazon EMR with Apache Flink → windowed aggregations → SageMaker ML inference → DynamoDB. Demonstrates manufacturing predictive maintenance use case.

## Key Concepts

```bash
aws kinesis create-stream --stream-name iot-sensor-stream --shard-count 1
aws emr create-cluster \
  --name "Flink-EMR-Cluster" \
  --release-label emr-6.5.0 \
  --applications Name=Flink \
  --ec2-attributes KeyName=your-key-pair \
  --instance-type m5.xlarge \
  --instance-count 3 \
  --use-default-roles
```

```python
import boto3, json, random, time

kinesis = boto3.client('kinesis', region_name='us-east-1')

def generate_sensor_data():
    return {
        'sensor_id': random.randint(1, 100),
        'temperature': round(random.uniform(20.0, 40.0), 2),
        'humidity': round(random.uniform(30.0, 70.0), 2),
        'timestamp': int(time.time())
    }

def publish_to_kinesis(stream_name, data):
    return kinesis.put_record(
        StreamName=stream_name,
        Data=json.dumps(data),
        PartitionKey=str(data['sensor_id'])
    )
```

```java
DataStream<Tuple2<Integer, Double>> aggregatedStream = kinesisStream
        .map(json -> {
            SensorData sensorData = SensorData.fromJson(json);
            return new Tuple2<>(sensorData.getSensorId(), sensorData.getTemperature());
        })
        .keyBy(0)
        .timeWindow(Time.minutes(5))
        .apply(new WindowFunction<Tuple2<Integer, Double>, Tuple2<Integer, Double>, Integer, TimeWindow>() {
            @Override
            public void apply(Integer key, TimeWindow window, Iterable<Tuple2<Integer, Double>> input, Collector<Tuple2<Integer, Double>> out) {
                double sum = 0;
                int count = 0;
                for (Tuple2<Integer, Double> record : input) {
                    sum += record.f1;
                    count++;
                }
                out.collect(new Tuple2<>(key, sum / count));
            }
        });
```

```java
public class MLInference {
    public static double predict(double temperature, double humidity) {
        AmazonSageMakerRuntime sagemaker = AmazonSageMakerRuntimeClientBuilder.defaultClient();
        InvokeEndpointRequest request = new InvokeEndpointRequest()
                .withEndpointName("your-sagemaker-endpoint")
                .withContentType("application/json")
                .withBody(String.format("{\"temperature\": %f, \"humidity\": %f}", temperature, humidity));
        InvokeEndpointResult result = sagemaker.invokeEndpoint(request);
        return Double.parseDouble(new String(result.getBody().array()));
    }
}
```
