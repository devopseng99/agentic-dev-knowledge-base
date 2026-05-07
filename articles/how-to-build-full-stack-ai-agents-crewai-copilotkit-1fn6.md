---
title: "How To Build Full-Stack AI Agents (CrewAI + CopilotKit)"
url: "https://dev.to/copilotkit/how-to-build-full-stack-ai-agents-crewai-copilotkit-1fn6"
author: "Bonnie"
category: "enterprise-clones"
---

# How To Build Full-Stack AI Agents (CrewAI + CopilotKit)
**Author:** Bonnie
**Published:** March 27, 2025

## Overview
End-to-end tutorial for building a restaurant finder app combining CrewAI backend agents with CopilotKit frontend.

## Key Concepts

### Backend Setup
```bash
git clone https://github.com/TheGreatBonnie/restaurant-finder.git
crewai install
crewai run
```

### Frontend Setup
```bash
git clone https://github.com/TheGreatBonnie/restaurant-finder-ui.git
pnpm install
pnpm run dev
```

### CopilotKit Integration
```typescript
import "@copilotkit/react-ui/styles.css";
import { CopilotKit } from "@copilotkit/react-core";

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <CopilotKit
          showDevConsole={false}
          agent={process.env.NEXT_PUBLIC_AGENT_NAME}
          publicApiKey={process.env.NEXT_PUBLIC_CPK_PUBLIC_API_KEY}
        >
          {children}
        </CopilotKit>
      </body>
    </html>
  );
}
```

### GitHub Repositories
- https://github.com/TheGreatBonnie/restaurant-finder
- https://github.com/TheGreatBonnie/restaurant-finder-ui
- https://github.com/CopilotKit

### Key Architecture
- Human-in-the-loop: Agents request user confirmation before finalizing
- Modular: Separate backend agents from frontend presentation
- State management via CopilotKit hooks (useCoAgent)
