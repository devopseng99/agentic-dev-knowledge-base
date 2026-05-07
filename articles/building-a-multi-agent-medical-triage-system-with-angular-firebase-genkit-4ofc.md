---
title: "Building a Multi-Agent Medical Triage System with Angular, Firebase & Genkit"
url: "https://dev.to/maina-duncan/building-a-multi-agent-medical-triage-system-with-angular-firebase-genkit-4ofc"
author: "Duncan Maina"
category: "agent-sdks"
---

# Building a Multi-Agent Medical Triage System with Angular, Firebase & Genkit
**Author:** Duncan Maina
**Published:** February 25, 2026

## Overview
5-agent sequential architecture for healthcare AI (AfyaSense) that isolates responsibilities for safety: Intent Router, Data Extraction, Emergency Guardrails, Diagnostic Engine, and Headless Mapping.

## Key Concepts

### Emergency Bypass Logic
```typescript
if (intakeData.isBleedingOrUnconscious) {
  return { riskLevel: 'EMERGENCY' };
}
```

### Headless Mapping Pipeline
```typescript
const query = `[out:json];node["amenity"="hospital"](around:8000,${lat},${lng})`;
const res = await fetch(`https://overpass-api.de/api/interpreter?data=${encodeURIComponent(query)}`);
```

Key insight: Combining AI with traditional engineering guardrails creates safer, more predictable healthcare systems.
