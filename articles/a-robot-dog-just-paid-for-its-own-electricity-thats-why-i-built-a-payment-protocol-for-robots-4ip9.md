---
title: "A Robot Dog Just Paid for Its Own Electricity. That's Why I Built a Payment Protocol for Robots."
url: "https://dev.to/mr_hamlin/a-robot-dog-just-paid-for-its-own-electricity-thats-why-i-built-a-payment-protocol-for-robots-4ip9"
author: "Mr Hamlin"
category: "robot-building"
---
# A Robot Dog Just Paid for Its Own Electricity. That's Why I Built a Payment Protocol for Robots.
**Author:** Mr Hamlin  **Published:** March 16, 2026

## Overview
The author created the Robot Task Protocol (RTP), an open standard enabling AI agents to discover, commission, and pay for physical robot tasks using x402 micropayments on USDC. The initiative emerged from observing that every robotics project builds custom payment infrastructure rather than using standardized protocols.

## Key Concepts
- RTP operates as a middleware connecting AI agent intent to physical robot execution
- Six live endpoints: Register, Discover, Dispatch, Complete, Status, Profile
- Settles exclusively in USDC on Base to avoid token speculation and maintain price stability
- Integrates with existing DePIN infrastructure (Peaq, Auki)
- Escrow-based task settlement with automatic refunds on failure
- Low registration barriers for robot operators

GitHub (RTP Spec): github.com/plagtech/rtp-spec
