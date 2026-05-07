---
title: "Real-Time User Behavior Insights with Amazon Kinesis and Apache Flink"
url: "https://dev.to/aws-builders/real-time-user-behavior-insights-with-amazon-kinesis-and-apache-flink-a-guide-to-sessionizing-clickstream-data-5gcc"
author: "Abdullah Paracha"
category: "immutable-arch-rust-flink"
---
# Real-Time User Behavior Insights with Amazon Kinesis and Apache Flink
**Author:** Abdullah Paracha  **Published:** July 19, 2024

## Overview
Sessionizing clickstream data using Amazon Managed Service for Apache Flink. Kinesis Data Streams ingests click events; Flink SQL identifies session boundaries via LAG function; Lambda stores sessions to DynamoDB. Online retailer XShop use case for real-time user behavior analysis.

## Key Concepts

```bash
# Simulate clickstream
DATA_STREAM="click-stream"
USER_IDS=(user1 user2 user3)
EVENTS=(checkout search category detail navigate)
for i in $(seq 1 5000); do
    export USER_ID="${USER_IDS[RANDOM%${#USER_IDS[@]}]}"
    export EVENT_NAME="${EVENTS[RANDOM%${#EVENTS[@]}]}"
    export EVENT_TIMESTAMP=$(($(date +%s) * 1000))
    JSON=$(cat click.json | envsubst)
    aws kinesis put-record --stream-name $DATA_STREAM --data "${JSON}" --partition-key 1 --region us-west-2
done
```

```sql
%flink.ssql(type = update)
CREATE TABLE click_stream (
  user_id STRING,
  event_timestamp BIGINT,
  event_name STRING,
  event_type STRING,
  device_type STRING,
  event_time AS TO_TIMESTAMP(FROM_UNIXTIME(event_timestamp/1000)),
  WATERMARK FOR event_time AS event_time - INTERVAL '5' SECOND
) WITH (
  'connector' = 'kinesis',
  'stream' = 'click-stream',
  'aws.region' = 'us-west-2',
  'scan.startup.mode' = 'latest-offset',
  'format' = 'json'
);
```

Session boundary detection via LAG:
```sql
SELECT 
  *, 
  CASE WHEN event_timestamp - LAG(event_timestamp) OVER (
    PARTITION BY user_id 
    ORDER BY event_time
  ) >= (10 * 1000) THEN 1 ELSE 0 END as new_session 
FROM click_stream;
```

Session ID generation:
```sql
SELECT 
  *, 
  user_id || '_' || CAST(
    SUM(new_session) OVER (
      PARTITION BY user_id 
      ORDER BY event_time
    ) AS STRING
  ) AS session_id 
FROM (
  SELECT 
    *, 
    CASE WHEN event_timestamp - LAG(event_timestamp) OVER (
      PARTITION BY user_id ORDER BY event_time
    ) >= (10 * 1000) THEN 1 ELSE 0 END as new_session 
  FROM click_stream
) 
WHERE new_session = 1
```

Lambda (DynamoDB storage):
```python
def lambda_handler(event, context):
    records = event['Records']
    for record in records:
        payload = base64.b64decode(record['kinesis']['data'])
        data_item = loads(payload)
        ddb_item = {
            'session_id': {'S': data_item['session_id']},
            'session_time': {'S': data_item['session_time']},
            'user_id': {'S': data_item['user_id']}
        }
        dynamodb_client.put_item(TableName=table_name, Item=ddb_item)
```
