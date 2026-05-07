---
title: "iOS & OS Agents in the Era of Multi-Modal Generative AI"
url: "https://dev.to/francedot/ios-os-agents-in-the-era-of-multi-modal-generative-ai-154p"
author: "Francesco Bonacci"
category: "multi-modal-agent-vision"
---

# iOS & OS Agents in the Era of Multi-Modal Generative AI

**Author:** Francesco Bonacci
**Published:** March 5, 2024

## Overview

Explores how vision models enable OS-level agents to navigate and control applications on devices through multi-modal capabilities. Introduces NavAIGuide-TS, a TypeScript framework for iOS, Android, web, and desktop UI automation.

## Key Concepts

### Two-Step Agent Process

1. Predict next action from current page state using visual analysis
2. Generate automation code through accessibility IDs and XPath selectors

### NavAIGuide-TS Framework

Three core agents:
- `startTaskPlanner_Agent` - formulates cross-app plans
- `predictNextNLAction_Visual_Agent` - analyzes screenshots and predicts actions
- `generateCodeSelectorsWithRetry_Agent` - converts natural language to code selectors

### Visual Agent Output (JSON)

```json
{
  "previousActionSuccess": false,
  "previousActionSuccessExplanation": "The keyboard is not visible in the second screenshot.",
  "endGoalMet": false,
  "actionType": "tap",
  "actionTarget": "Search bar",
  "actionDescription": "Retry tapping the search bar with corrected coordinates.",
  "actionTargetVisualDescription": "A white search bar at the top with a magnifying glass icon"
}
```

### iOS Agent Usage (TypeScript)

```typescript
import { iOSAgent } from "@navaiguide/ios";

const iosAgent = new iOSAgent({
  appiumBaseUrl: 'http://127.0.0.1',
  appiumPort: 4723,
  iOSVersion: "17.3.0",
  deviceUdid: "<DEVICE_UDID>"
});

const fitnessPlannerQuery = "Help me run a 30-day fitness challenge.";
await iosAgent.runAsync({
  query: fitnessPlannerQuery
});
```

### Installation

```bash
npm install @navaiguide/ios
```

### Appium Setup

```bash
npm install -g appium
appium driver install xcuitest
```

### Prerequisites

- macOS with Xcode 15
- Real iOS device (simulators unsupported)
- Apple Developer Free Account
- Developer Mode enabled on device
- UI Automation enabled in Settings/Developer
