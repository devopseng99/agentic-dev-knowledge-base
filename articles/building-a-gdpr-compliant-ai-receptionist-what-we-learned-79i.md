---
title: "Building a GDPR-Compliant AI Receptionist: What We Learned"
url: "https://dev.to/voicefleet/building-a-gdpr-compliant-ai-receptionist-what-we-learned-79i"
author: "VoiceFleet"
category: "erp-business-law"
---
# Building a GDPR-Compliant AI Receptionist: What We Learned
**Author:** VoiceFleet  **Published:** February 25, 2026

## Overview
Lessons from developing an AI voice receptionist for European healthcare. Voice data, health information (appointment types, symptoms), and personal identifiers all fall under GDPR's special category protections (Article 9).

## Key Concepts

**Architecture Decisions**

1. EU-Only Hosting
   - All infrastructure (STT, LLM inference, TTS, storage) within EU-West
   - Data never exits EU borders
   - Encrypted database storage at rest

2. Minimal Data Retention
   - Call transcripts auto-delete after 30 days (configurable)
   - Voice recordings stored only with explicit practice consent
   - Fuzzy name/DOB matching avoids unnecessary identifier storage

3. Real-Time Consent
   - AI self-identifies at call start
   - Patients can opt-out and transfer to humans anytime
   - Satisfies transparency requirements

4. Data Processing Agreements
   - Practice acts as data controller; VoiceFleet as processor
   - DPA integrated into standard terms

**EU AI Act Considerations**
Healthcare AI systems influencing appointment scheduling may qualify as "high-risk" — build as if high-risk (documentation, human oversight, bias testing).

**Developer Recommendations**
1. Avoid US-based speech processing APIs for EU healthcare
2. Log AI decision reasoning (not patient data itself)
3. Implement human transfer capability
4. Conduct Data Protection Impact Assessment before launch
