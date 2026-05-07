---
title: "Event-Driven Architecture, Event Sourcing, and CQRS: How They Work Together"
url: "https://dev.to/yasmine_ddec94f4d4/event-driven-architecture-event-sourcing-and-cqrs-how-they-work-together-1bp1"
author: "Yasmine Cherif"
category: "immutable-arch-rust-flink"
---
# Event-Driven Architecture, Event Sourcing, and CQRS: How They Work Together
**Author:** Yasmine Cherif  **Published:** December 2, 2024

## Overview
Three complementary patterns for building scalable, decoupled, resilient systems. Python implementation demonstrating all three patterns together in a shopping cart service with immutable event store, command handlers, and query projections.

## Key Concepts

```python
class ItemAddedToCart:
    def __init__(self, item_id, quantity):
        self.item_id = item_id
        self.quantity = quantity

class ItemRemovedFromCart:
    def __init__(self, item_id):
        self.item_id = item_id
```

Immutable event store:
```python
class EventStore:
    def __init__(self):
        self.events = []

    def add_event(self, event):
        self.events.append(event)

    def get_events(self):
        return self.events

event_store = EventStore()
```

Command handlers (write side):
```python
def handle_add_item_command(item_id, quantity):
    event = ItemAddedToCart(item_id, quantity)
    event_store.add_event(event)
    print(f"Item {item_id} added to cart with quantity {quantity}")

def handle_remove_item_command(item_id):
    event = ItemRemovedFromCart(item_id)
    event_store.add_event(event)
    print(f"Item {item_id} removed from cart")
```

Query projections (read side — derived from events):
```python
def get_cart_contents():
    cart = {}
    for event in event_store.get_events():
        if isinstance(event, ItemAddedToCart):
            if event.item_id in cart:
                cart[event.item_id] += event.quantity
            else:
                cart[event.item_id] = event.quantity
        elif isinstance(event, ItemRemovedFromCart):
            if event.item_id in cart:
                del cart[event.item_id]
    return cart

handle_add_item_command('apple', 2)
handle_add_item_command('banana', 3)
handle_remove_item_command('apple')
print("Current cart contents:", get_cart_contents())
```

Benefits: Scalability (independent service scaling), Auditability (complete event history), Flexibility (read/write models evolve separately), Reactivity (real-time component responses).

Challenges: Complexity, Data Duplication (projection storage overhead), Eventual Consistency, Operational Overhead, Schema Evolution.
