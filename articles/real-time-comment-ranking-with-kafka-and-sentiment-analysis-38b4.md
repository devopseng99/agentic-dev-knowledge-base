---
title: "Real-Time Comment Ranking with Kafka and Sentiment Analysis"
url: "https://dev.to/dantethebrave/real-time-comment-ranking-with-kafka-and-sentiment-analysis-38b4"
author: "Dante"
category: "flink-kafka-agents"
---

# Real-Time Comment Ranking with Kafka and Sentiment Analysis
**Author:** Dante
**Published:** October 9, 2025

## Overview
AI-driven solution combining NLTK/VADER sentiment analysis with Apache Kafka to automatically rank comments in real-time, elevating positive contributions and suppressing negativity.

## Key Concepts

### Comment Producer

```python
from kafka import KafkaProducer
import json

producer = KafkaProducer(
    bootstrap_servers=['localhost:9092'],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

def send_comment(comment_text, user_id):
    producer.send('comments_raw', {'user_id': user_id, 'comment': comment_text})
    producer.flush()
```

### Sentiment Analysis Consumer

```python
from kafka import KafkaConsumer, KafkaProducer
from nltk.sentiment import SentimentIntensityAnalyzer
import json

consumer = KafkaConsumer(
    'comments_raw',
    bootstrap_servers=['localhost:9092'],
    value_deserializer=lambda v: json.loads(v.decode('utf-8'))
)

producer = KafkaProducer(
    bootstrap_servers=['localhost:9092'],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

analyzer = SentimentIntensityAnalyzer()

for message in consumer:
    data = message.value
    score = analyzer.polarity_scores(data['comment'])['compound']
    result = {
        'user_id': data['user_id'],
        'comment': data['comment'],
        'sentiment_score': score
    }
    producer.send('comments_scored', result)
```

### Ranking Consumer

```python
consumer = KafkaConsumer(
    'comments_scored',
    bootstrap_servers=['localhost:9092'],
    value_deserializer=lambda v: json.loads(v.decode('utf-8'))
)

ranked_comments = []
for msg in consumer:
    ranked_comments.append(msg.value)
    ranked_comments.sort(key=lambda x: x['sentiment_score'], reverse=True)
    print("Top comment:", ranked_comments[0]['comment'])
```

### Pipeline
Frontend -> Kafka `comments_raw` -> Python AI worker (VADER) -> Kafka `comments_scored` -> CMS backend (reorder + display)

### Suggested Enhancements
- Deep learning models (transformers) for nuanced understanding
- Toxicity classification for harmful speech
- Elasticsearch/Kibana visualization dashboards
- Community health scores
