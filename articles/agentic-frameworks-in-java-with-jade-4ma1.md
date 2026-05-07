---
title: "Agentic Frameworks in Java with JADE"
url: "https://dev.to/vishalmysore/agentic-frameworks-in-java-with-jade-4ma1"
author: "vishalmysore"
category: "rust-go-java-agents"
---

# Agentic Frameworks in Java with JADE
**Author:** vishalmysore
**Published:** September 11, 2024

## Overview
Multi-agent systems using JADE (Java Agent Development Framework) with FIPA standards. Two agents (OpenAI and Gemini) communicate about philosophy and sports. Covers behavior types: OneShotBehaviour, CyclicBehaviour, TickerBehaviour, FSMBehaviour.

## Key Concepts

```java
protected void setup() {
    addBehaviour(new OneShotBehaviour() {
        public void action() {
            ACLMessage msg = new ACLMessage(ACLMessage.INFORM);
            msg.addReceiver(new AID("ReceiverAgent", AID.ISLOCALNAME));
            msg.setContent("Hello from HelloAgent!");
            send(msg);
        }
    });
}
```

| JADE | JMS |
|------|-----|
| Agent-based systems | Message passing API |
| FIPA-compliant | Java EE platform |
| Asynchronous, non-blocking | Both sync and async |
