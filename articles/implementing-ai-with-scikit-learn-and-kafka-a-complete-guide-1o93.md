---
title: "Implementing AI with Scikit-Learn and Kafka: A Complete Guide"
url: "https://dev.to/amitchandra/implementing-ai-with-scikit-learn-and-kafka-a-complete-guide-1o93"
author: "Amit Chandra"
category: "flink-kafka-agents"
---

# Implementing AI with Scikit-Learn and Kafka: A Complete Guide
**Author:** Amit Chandra
**Published:** September 1, 2024

## Overview
Integrating Scikit-learn with Apache Kafka to build real-time machine learning pipelines. Demonstrates setting up Kafka to stream stock price data and using a trained model to predict closing prices in real-time.

## Key Concepts

### Train the Model

```python
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

data = np.array([
    [1, 100, 110, 90, 105],
    [2, 105, 115, 95, 110],
    [3, 110, 120, 100, 115],
    [4, 115, 125, 105, 120],
    [5, 120, 130, 110, 125],
])
X = data[:, :-1]
y = data[:, -1]

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
model = LinearRegression()
model.fit(X_train, y_train)
```

### Kafka Producer

```python
from kafka import KafkaProducer
import json

producer = KafkaProducer(bootstrap_servers='localhost:9092',
                         value_serializer=lambda v: json.dumps(v).encode('utf-8'))
stock_data = {'open': 130, 'high': 140, 'low': 120}
producer.send('stock-prices', stock_data)
producer.flush()
```

### Kafka Consumer with ML Prediction

```python
from kafka import KafkaConsumer
import json

consumer = KafkaConsumer('stock-prices',
                         bootstrap_servers='localhost:9092',
                         value_deserializer=lambda v: json.loads(v.decode('utf-8')))

for message in consumer:
    data = message.value
    input_data = np.array([[data['open'], data['high'], data['low']]])
    prediction = model.predict(input_data)
    print(f'Predicted Close Price: {prediction[0]}')
```

### Why Combine Kafka with Scikit-learn
- Stream real-time data for immediate processing
- Automate predictions on incoming data
- Scalable architecture for large data volumes
- Ideal for financial, IoT, and social media applications
