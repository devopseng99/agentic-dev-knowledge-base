---
title: "Build a Multi-Agent Telecom Support System with CopilotKit & LangGraph JS"
url: "https://dev.to/copilotkit/build-a-multi-agent-telecom-support-system-with-copilotkit-langgraph-js-52oc"
author: "Arindam Majumder"
category: "multi-agent-frameworks"
---

# Build a Multi-Agent Telecom Support System with CopilotKit & LangGraph JS

**Author:** Arindam Majumder
**Date Published:** February 9, 2026

---

## Overview

This tutorial demonstrates creating a customer support system where multiple specialized agents coordinate to handle telecom service requests dynamically, moving beyond rigid rule-based automation.

## Key Problem Statement

"Customer support is chaotic...Customers don't follow patterns. A simple question might need escalation, and an urgent issue might have a quick fix."

The traditional approach of pattern-matching automation fails when customer inquiries deviate from expected templates, requiring escalation to humans.

---

## Architecture & Components

### The Four-Agent System

1. **Intent Agent** - Classifies customer messages and determines urgency
2. **Customer Lookup Agent** - Retrieves customer profiles and service details
3. **Reply Agent** - Generates personalized responses and processes service changes
4. **Escalation Agent** - Routes complex issues to human teams with full context

### Technology Stack

- **Next.js** - Frontend framework with TypeScript
- **CopilotKit SDK** - Agent integration (@copilotkit/react-core, @copilotkit/runtime, @copilotkit/react-ui)
- **LangGraph** - Stateful multi-agent workflows
- **OpenAI** - Language model for reasoning
- **Turborepo & pnpm** - Monorepo management

---

## Frontend Implementation

### Step 1: Install CopilotKit Packages

```bash
pnpm install @copilotkit/react-core @copilotkit/react-ui @copilotkit/runtime
```

### Step 2: Root Layout Setup

```typescript
import { CopilotKit } from "@copilotkit/react-core";
import "@copilotkit/react-ui/styles.css";

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <CopilotKit runtimeUrl="/api/copilotkit">
          {children}
        </CopilotKit>
      </body>
    </html>
  );
}
```

### Step 3: CopilotKit Runtime Endpoint

Create `src/app/api/copilotkit/route.ts`:

```typescript
import {
  CopilotRuntime,
  ExperimentalEmptyAdapter,
  copilotRuntimeNextJSAppRouterEndpoint,
} from "@copilotkit/runtime";
import { LangGraphAgent } from "@copilotkit/runtime/langgraph";
import { NextRequest } from "next/server";

const serviceAdapter = new ExperimentalEmptyAdapter();

const runtime = new CopilotRuntime({
  agents: {
    starterAgent: new LangGraphAgent({
      deploymentUrl: process.env.LANGGRAPH_DEPLOYMENT_URL || "http://localhost:8123",
      graphId: "starterAgent",
      langsmithApiKey: process.env.LANGSMITH_API_KEY || "",
    })
  }
});

export const POST = async (req: NextRequest) => {
  const { handleRequest } = copilotRuntimeNextJSAppRouterEndpoint({
    runtime,
    serviceAdapter,
    endpoint: "/api/copilotkit",
  });

  return handleRequest(req);
};
```

### Step 4: Customer Context with Frontend Tools

The guide emphasizes: "if you want agents to actually modify your UI in real-time, your state management needs to be solid."

Create `src/hooks/CustomerContext.tsx` using React Context:

```typescript
"use client";

import React, { createContext, useContext, useState, useCallback, useRef, useEffect } from "react";
import { useAgent, useFrontendTool } from "@copilotkit/react-core/v2";
import { initialCustomers } from "@/data/ticketsData";

interface Customer {
  id: number;
  customerID: string;
  gender: string;
  SeniorCitizen: string;
  Partner: "Yes" | "No";
  MonthlyCharges: string;
  InternetService: "DSL" | "Fiber optic";
  PaperlessBilling: "Yes" | "No";
  StreamingTV: "Yes" | "No";
}

type AgentState = {
  customers: Customer[];
};

const CustomerContext = createContext<CustomerContextType | undefined>(undefined);

export function CustomerProvider({ children }: { children: React.ReactNode }) {
  const { agent } = useAgent({ agentId: "starterAgent" });

  useEffect(() => {
    if (!agent.state.customers) {
      agent.setState({
        ...agent.state,
        customers: initialCustomers,
      });
    }
  }, [agent]);

  const [localCustomers, setLocalCustomers] = useState<Customer[] | null>(null);
  const customers = localCustomers ?? agent.state.customers ?? [];
  const customersRef = useRef<Customer[]>([]);

  useEffect(() => {
    customersRef.current = customers;
  }, [customers]);

  const recalculateCharges = useCallback((customer: Customer) => {
    const calculation = calculateMonthlyCharges(customer);
    const monthlyCharges = calculation.total;
    const tenure = parseInt(customer.tenure) || 0;
    const totalCharges = monthlyCharges * tenure;
    return { monthlyCharges, totalCharges };
  }, []);

  const addAddon = useCallback((customerId: string, addon: AddonService) => {
    let updatedCustomer: Customer | null = null;

    const updatedCustomers = customersRef.current.map((customer) => {
      if (customer.customerID === customerId) {
        const updates: Partial<Customer> = {};
        if (addon === "MultipleLines" && customer.PhoneService === "No") {
          return customer;
        }
        updates[addon] = "Yes";
        const updated = { ...customer, ...updates };
        const { monthlyCharges, totalCharges } = recalculateCharges(updated);
        updated.MonthlyCharges = monthlyCharges.toFixed(2);
        updated.TotalCharges = totalCharges.toFixed(2);
        updatedCustomer = updated;
        return updated;
      }
      return customer;
    });

    if (updatedCustomer) {
      setLocalCustomers(updatedCustomers);
      agent.setState({ ...agent.state, customers: updatedCustomers });
    }
    return updatedCustomer;
  }, [recalculateCharges, agent]);

  useFrontendTool({
    name: "addAddonToCustomer",
    description: "Add a service addon. This enables a specific service and recalculates charges automatically.",
    parameters: [
      {
        name: "customerID",
        type: "string",
        description: "The unique customer ID (e.g., '5575-GNVDE')",
        required: true,
      },
      {
        name: "addonName",
        type: "string",
        description: "The addon service name. Valid options: PhoneService, MultipleLines, OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies",
        required: true,
      },
    ],
    handler: async ({ customerID, addonName }) => {
      const currentCustomers = customersRef.current;
      const customer = currentCustomers.find((c) => c.customerID === customerID);

      if (!customer) {
        return { success: false, message: `Customer with ID ${customerID} not found` };
      }

      const result = addAddon(customer.customerID, addonName as AddonService);

      if (!result) {
        return { success: false, message: `Failed to add ${addonName}. Check prerequisites.` };
      }

      return {
        success: true,
        message: `Successfully added ${addonName} to customer ${customer.customerID}`,
        newMonthlyCharges: result.MonthlyCharges,
        customer: { id: result.id, customerID: result.customerID, monthlyCharges: result.MonthlyCharges },
      };
    },
  });

  return (
    <CustomerContext.Provider value={{ customers, updateCustomer, addAddon }}>
      {children}
    </CustomerContext.Provider>
  );
}
```

---

## Project Structure

```
support-help/
├── apps/
│   ├── web/                    # Next.js frontend
│   │   ├── src/app/
│   │   │   ├── page.tsx        # Main dashboard
│   │   │   ├── layout.tsx      # CopilotKit provider
│   │   │   └── api/copilotkit/route.ts
│   │   ├── src/components/
│   │   ├── src/hooks/CustomerContext.tsx
│   │   ├── src/data/ticketsData.ts
│   │   └── src/utils/servicePricing.ts
│   └── agent/                  # LangGraph backend
│       ├── src/
│       │   ├── agent.ts        # Main workflow
│       │   ├── agents/
│       │   ├── tools/
│       │   ├── types/state.ts
│       │   └── utils/
│       └── langgraph.json
```

---

## Key Takeaways

1. **Multi-agent systems handle dynamic customer requests** better than rule-based automation by allowing specialized agents to collaborate
2. **Centralized state management is critical** for enabling agents to modify UI in real-time with proper synchronization
3. **Frontend tools bridge the gap** between backend agents and UI by exposing typed functions agents can safely call
4. **Service dependencies require enforcement** at the data layer to maintain system consistency during modifications
5. **Bidirectional state sync** ensures both agents and UI components work from a single source of truth

---

**Repository:** [GitHub - support-help](https://github.com/studio1hq/support-help)
