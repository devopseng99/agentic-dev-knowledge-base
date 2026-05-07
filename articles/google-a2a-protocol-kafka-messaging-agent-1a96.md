---
title: "Google A2A Protocol: Kafka Messaging Agent"
url: "https://dev.to/vishalmysore/google-a2a-protocol-kafka-messaging-agent-1a96"
author: "vishalmysore"
category: "flink-kafka-agents"
---

# Google A2A Protocol: Kafka Messaging Agent
**Author:** vishalmysore
**Published:** May 9, 2025

## Overview
Integrating Google's Agent-to-Agent (A2A) protocol with Apache Kafka using Spring Boot. The A2A protocol enables seamless communication and task delegation between different AI agents. Combined with Kafka's messaging capabilities, it creates a system for distributed task processing with three services: Order, Payment, and Alert.

## Key Concepts

### Architecture: Kafka-A2A Bridge

```java
@Component
public class SpringKafkaAgent {
    private final LocalA2ATaskClient client;

    private void processMessage(String messageType, String topic, String key, String value) {
        String taskDescription = String.format("kafka-message:%s topic:%s key:%s value:%s",
                messageType, topic, key, value);
        Task task = client.sendTask(taskDescription);
        Task result = client.getTask(task.getId(), 5);
    }

    @KafkaListener(topics = "orders", groupId = "a2a-group")
    public void consumeOrderMessages(ConsumerRecord<String, String> record, Acknowledgment ack) {
        try {
            processMessage("order-processing", record.topic(), record.key(), record.value());
            ack.acknowledge();
        } catch (Exception e) {
            log.error("Error processing order message", e);
        }
    }
}
```

### A2A-Enabled Services

```java
@Service
@Agent(groupName = "order support", groupDescription = "actions related to order support")
public class OrderService {
    private A2AActionCallBack callBack;

    @Action(description = "Process a new order")
    public String processNewOrder(String orderId, String status, String amount) {
         if(callBack != null) {
           callBack.sendtStatus("Processing Order ID: " + orderId, ActionState.IN_PROGRESS);
           callBack.sendtStatus("Completed Order ID: " + orderId, ActionState.COMPLETED);
         }
         return "Processed order: " + orderId;
    }
}
```

### Kafka Configuration

```java
@Configuration
@EnableKafka
public class EmbeddedKafkaConfig {
    @Bean
    public ConsumerFactory<String, String> consumerFactory() {
        Map<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "a2a-group");
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        return new DefaultKafkaConsumerFactory<>(props);
    }
}
```

### Key Benefits
- **Decoupling**: Kafka provides message queuing, A2A provides task processing
- **Scalability**: Both Kafka and A2A designed for horizontal scaling
- **Flexibility**: Easy to add new message types and services
- **Monitoring**: Built-in task status tracking and logging

GitHub: [a2ajava](https://github.com/vishalmysore/a2ajava)
