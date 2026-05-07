---
title: "Building an Agentic Medical Analysis System That Actually Thinks"
url: "https://dev.to/aws-builders/building-an-agentic-medical-analysis-system-that-actually-thinks-3dg1"
author: "Marcos Henrique"
category: "healthcare-ai"
---
# Building an Agentic Medical Analysis System That Actually Thinks
**Author:** Marcos Henrique  **Published:** September 29, 2025

## Overview
Explores combining autonomous AI agents with event-driven microservices architecture for medical analysis systems. Advocates for an incremental approach rather than revolutionary implementation, emphasizing that agents should reason about medical data while operating within structured clinical protocols. Positions "AI agents as microservices with brains" applied to healthcare.

## Key Concepts
- Agentic Event-Driven Architecture: moving from deterministic service calls to agent-based decision-making
- Medical Protocol Integration: clinical guidelines embedded directly into agent reasoning
- Structured vs. Vector Memory: DynamoDB-based persistent memory for medically-precise relational context
- Intelligent Event Cascades: agent decisions publishing typed events triggering specialized microservice responses
- Context Management: strategic selection of relevant patient information within LLM context window
- GitHub: https://github.com/wakeupmh/agents-microservices

```typescript
import { VoltAgent, Agent } from "@voltagent/core";
import { VercelAIProvider } from "@voltagent/vercel-ai";
import { BedrockRuntime } from "@aws-sdk/client-bedrock-runtime";

export class MedicalAgentCoordinator {
  private agent: Agent;
  private memory: DynamoDBMemoryStore;
  private eventBridge: EventBridgeClient;

  constructor() {
    this.agent = new Agent({
      name: "medical-analysis-coordinator",
      instructions: `You are a medical analysis coordinator.
 Analyze laboratory results and patient history to determine:
 - Clinical urgency (0-24h, 1-7d, 30-90d)
 - Required specialists (endocrinology, cardiology, nephrology)
 - Risk factors and follow-up needs`,
      llm: new VercelAIProvider(),
      model: novaMicro("nova-micro-v1"),
    });
  }
}
```

```typescript
export const s3TriggerHandler = async (event: S3Event) => {
  for (const record of event.Records) {
    const { bucket, object } = record.s3;

    const labData = await extractLabResults(bucket.name, object.key);

    const analysis = await this.agent.analyze({
      labResults: labData,
      patientHistory: await this.memory.getPatientContext(patientId),
      clinicalProtocols: MEDICAL_GUIDELINES
    });

    await this.publishMedicalEvents(analysis);
  }
};
```

```typescript
interface MedicalAnalysisEvent {
  eventType: 'medical.analysis.complete';
  patientId: string;
  findings: {
    glucose: number;
    priority: 'URGENT' | 'PRIORITY' | 'ROUTINE';
    riskFactors: string[];
  };
  recommendations: {
    specialty: 'endocrinology' | 'cardiology' | 'nephrology' | 'generalist';
    timeframe: '0-24h' | '1-7d' | '30-90d';
  };
}
```

```typescript
export class DynamoDBMemoryStore {
  async updatePatientMemory(event: MedicalAnalysisEvent) {
    const memoryUpdate = {
      patientId: event.patientId,
      lastAnalysis: event.findings,
      riskTrend: this.calculateRiskTrend(event.findings),
      urgentFlags: event.findings.priority === 'URGENT' ?
        [...existing.urgentFlags, event.findings] :
        existing.urgentFlags
    };

    await this.dynamodb.putItem({
      TableName: 'PatientMemory',
      Item: memoryUpdate
    });

    await this.eventBridge.publish('patient.memory.updated', memoryUpdate);
  }
}
```

```typescript
const CLINICAL_PROTOCOLS = {
  glucose: {
    critical_high: {
      threshold: 300,
      urgency: '0-24h',
      specialty: 'endocrinology',
      actions: ['immediate_notification', 'urgent_appointment', 'medication_review']
    },
    critical_low: {
      threshold: 50,
      urgency: '0-24h',
      specialty: 'emergency',
      actions: ['immediate_notification', 'emergency_protocol']
    }
  },
  creatinine: {
    acute_elevation: {
      threshold: 3.0,
      urgency: '0-24h',
      specialty: 'nephrology',
      actions: ['kidney_function_assessment', 'medication_adjustment']
    }
  }
};
```

```typescript
const medicalAnalysisWorkflow = createWorkflowChain({
  id: "medical-analysis-workflow",
  name: "Comprehensive Medical Analysis",
  input: z.object({
    labResults: z.object({
      glucose: z.number(),
      creatinine: z.number(),
      hba1c: z.number()
    }),
    patientId: z.string()
  })
})
.andThen({
  name: "fetch-patient-context",
  execute: async (data) => ({
    ...data,
    patientHistory: await memory.getPatientContext(data.patientId)
  })
})
.andAgent(
  (data) => `Analyze these lab results: ${JSON.stringify(data.labResults)}
for patient with history: ${JSON.stringify(data.patientHistory)}`,
  medicalAgent,
  { schema: MedicalAnalysisSchema }
)
.andThen({
  name: "publish-medical-events",
  execute: async (data) => {
    await eventBridge.publishMedicalEvents(data.analysis);
    return { success: true, eventsPublished: data.analysis.events.length };
  }
});
```
