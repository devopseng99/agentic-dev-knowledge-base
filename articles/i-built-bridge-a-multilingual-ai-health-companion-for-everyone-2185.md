---
title: "I Built Bridge, a Multilingual AI Health Companion for Everyone"
url: "https://dev.to/koushikxd/i-built-bridge-a-multilingual-ai-health-companion-for-everyone-2185"
author: "Koushikxd"
category: "healthcare-ai"
---
# I Built Bridge, a Multilingual AI Health Companion for Everyone
**Author:** Koushikxd  **Published:** March 13, 2026

## Overview
Bridge is an AI-powered health application helping patients and caregivers manage medical information across language barriers. Addresses real-world healthcare challenges like deciphering illegible prescriptions and understanding foreign medication labels. Features health profile setup, medicine tracking, health image scanning, and a care network for caregivers.

## Key Concepts
- Multilingual Support using lingo.dev for localization
- Structured AI Output providing concise, actionable guidance
- Profile-Based Analysis connecting scan results to user health profiles (allergies, conditions, restrictions)
- Care Network enabling caregivers to monitor linked profiles
- Voice Integration: speech-to-text and text-to-speech for accessibility
- Health Image Scanning: prescriptions, medicine labels, meal photos, menus via OCR and vision AI
- Tech: Next.js, React, TypeScript, Convex, Better Auth, Google Gemini, Tesseract OCR, lingo.dev
- GitHub: https://github.com/koushikxd/bridge

```typescript
const engine = new mod.LingoDotDevEngine({
  apiKey: process.env.LINGODOTDEV_API_KEY,
})

return await engine.localizeText(message, {
  sourceLocale: "en",
  targetLocale: normalizedLanguage,
  fast: true,
})
```

```typescript
const result = await analyzeWithVision(input)
const localizedResult = await localizeAnalysisResult(
  result,
  input.preferredLanguage
)

return { ...localizedResult, tier: "vision" }
```
