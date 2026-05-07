---
title: "Building a Secure Flight Booking System with LLM Agent in Langflow"
url: "https://dev.to/permit_io/building-a-secure-flight-booking-system-with-llm-agent-in-langflow-3ml"
author: "Gabriel L. Manor"
category: "langflow-agent"
---

# Building a Secure Flight Booking System with LLM Agent in Langflow

**Author:** Gabriel L. Manor
**Published:** March 10, 2025

## Overview

Tutorial for building a flight booking application using Langflow and Permit.io, emphasizing security across four critical perimeters: prompt filtering, RAG protection, secure external access, and response enforcement.

## Key Concepts

### Access Control Policy

**Flight Resource:**
```json
{
  "actions": ["search", "info", "viewprice", "viewavailability"],
  "attributes": {
    "type": "String",
    "sensitivity": "String"
  }
}
```

**Booking Resource:**
```json
{
  "actions": ["create", "modify", "cancel", "view"],
  "attributes": {
    "type": "String",
    "sensitivity": "String"
  }
}
```

### Three Core Flows

1. **Flight Search Flow** -- Validates JWT tokens, checks permissions, queries Astra DB, formats results
2. **Flight Information Flow** -- Uses Local Expert Agent for policy inquiries, enforces access controls
3. **Flight Booking Flow** -- Most restrictive security layer with JWT validation + permission checks + API integration

### Docker PDP Container

```bash
docker pull permitio/pdp-v2:latest

docker run -it -p 7766:7000 \
    --env PDP_DEBUG=True \
    --env PDP_API_KEY=<YOUR_API_KEY> \
    permitio/pdp-v2:latest
```

### Agent Configuration

**City Selection Agent:**
```
Model: gpt-4o-mini
Instructions: "You are a flight search assistant. Your job is to:
1. Extract departure and arrival cities from user queries
2. Validate that these are real cities with airports
3. Format the search request for our database
4. Handle cases where cities are unclear or invalid"
```

**Local Expert Agent:**
```
Mode: gpt-4o-mini
Instructions: "You are a knowledgeable Local Expert that provides accurate
flight policy and service information. You should:
1. Answer questions about baggage policies
2. Explain flight rules and restrictions
3. Provide information about services and amenities
4. Always maintain privacy by not revealing sensitive pricing or route details"
```

### Parse Data Template

```
Template:
"""
Flight {row_number}: {departure_city} to {arrival_city}
Departure: {departure_time}
Airline: {airline}
Flight Number: {flight_number}
Price: ${price}
Available Seats: {seats}
"""
```

### Condition Sets

```
Membership Tier Access:
user.membership_tier includes resource.class AND user.verified == true

Regional Restrictions:
user.region == "domestic"

Sensitive Data Access:
user.membership_tier includes "premium"
```

The four security perimeters work synergistically: JWT validation handles input, data protection restricts information, permission checks control API interactions, and combined enforcement shapes results based on authorization levels.
