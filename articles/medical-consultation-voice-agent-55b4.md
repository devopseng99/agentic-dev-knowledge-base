---
title: "Medical Consultation Voice Agent"
url: "https://dev.to/genjess/medical-consultation-voice-agent-55b4"
author: "GenJess"
category: "healthcare-ai"
---
# Medical Consultation Voice Agent
**Author:** GenJess  **Published:** July 28, 2025

## Overview
A sophisticated voice agent for medical consultations leveraging AssemblyAI's real-time transcription technology. Combines voice AI with medical domain expertise to deliver preliminary health assessments, symptom analysis, medication interaction detection, and risk evaluation through natural conversation. Achieves sub-300ms latency with 95%+ medical accuracy.

## Key Concepts
- Real-time voice transcription with sub-300ms latency
- Medical entity extraction from spoken conversations
- Drug interaction detection and contraindication warnings
- Risk assessment algorithms with emergency protocols
- Hybrid intelligence combining rule-based and AI analysis
- WCAG 2.1 AA accessibility compliance
- GitHub: https://github.com/GenJess/Medical-Voice-Agent-AssemblyAI
- Live Demo: https://medical-voice-agent-assemblyai.vercel.app/

```javascript
const initAssemblyAI = () => {
  const ASSEMBLYAI_API_KEY = import.meta.env.REACT_APP_ASSEMBLYAI_API_KEY;

  if (!ASSEMBLYAI_API_KEY || ASSEMBLYAI_API_KEY === 'your_assemblyai_api_key_here') {
    throw new Error("AssemblyAI API key is missing or not configured.");
  }

  const client = new AssemblyAI({
    apiKey: ASSEMBLYAI_API_KEY
  });

  return client;
};
```

```javascript
const transcriber = client.realtime.transcriber({
  sampleRate: 16000,
  wordBoost: ['medical', 'symptoms', 'medication', 'allergy', 'pain', 'fever', 'headache', 'cough', 'nausea', 'chest pain'],
  end_utterance_silence_threshold: 700,
  disable_partial_transcripts: false,
  language_code: 'en_us'
});
```

```javascript
const startListening = async () => {
  const stream = await navigator.mediaDevices.getUserMedia({
    audio: {
      sampleRate: 16000,
      channelCount: 1,
      echoCancellation: true,
      noiseSuppression: true
    }
  });

  const processor = audioContextRef.current.createScriptProcessor(4096, 1, 1);
  processor.onaudioprocess = (e) => {
    if (transcriberRef.current && isConnected) {
      const inputData = e.inputBuffer.getChannelData(0);
      transcriberRef.current.send(inputData);
    }
  };
};
```

```javascript
const processMedicalContent = async (transcript) => {
  setAgentStatus('processing');
  const extractedInfo = extractMedicalEntities(transcript);
  const aiAssessment = await analyzeMedicalContent(transcript, updatedPatientInfo);
  const aiResponse = await getGeminiResponse(/* ... */);
  setCurrentAdvice(aiResponse);
  speakResponse(aiResponse);
};
```
