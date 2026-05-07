---
title: "How to Set Up Voice AI Webhook Handling for Real Estate Inquiries Effectively"
url: "https://dev.to/callstacktech/how-to-set-up-voice-ai-webhook-handling-for-real-estate-inquiries-effectively-266b"
author: "CallStack Tech"
category: "agent-webhook-integration"
---

# How to Set Up Voice AI Webhook Handling for Real Estate Inquiries Effectively

**Author:** CallStack Tech
**Published:** January 7, 2026

## Overview
Webhooks fire faster than CRM can ingest them, causing duplicate leads, lost context, and race conditions. Uses VAPI for call orchestration, Twilio for phone routing, and Redis-backed queues. Key constraint: respond within 200ms, acknowledge immediately, process asynchronously.

## Key Concepts

### Race Condition Problem
Twilio fires `completed` status at disconnect (50-100ms latency). VAPI's final transcript arrives 200-800ms later, causing duplicate records. Solution: deduplication lock with timestamps.

### Webhook Timeouts
Maximum handler timeout: 3 seconds. Acknowledge immediately and queue external API calls asynchronously.

## Code Examples

### Twilio Signature Validation

```javascript
const validateTwilioRequest = (req, res, next) => {
  const twilioSignature = req.headers['x-twilio-signature'];
  const url = `${req.protocol}://${req.get('host')}${req.originalUrl}`;
  const isValid = twilio.validateRequest(
    process.env.TWILIO_AUTH_TOKEN,
    twilioSignature,
    url,
    req.body
  );
  if (!isValid) {
    return res.status(403).send('Forbidden - Invalid signature');
  }
  next();
};
```

### VAPI Webhook Handler

```javascript
app.post('/webhook/vapi', async (req, res) => {
  const { type, call, transcript } = req.body;
  res.status(200).send();  // Acknowledge immediately

  try {
    if (type === 'transcript' && transcript.role === 'user') {
      await processLeadIntent(call.id, transcript.text);
    }
    if (type === 'end-of-call-report') {
      await finalizeLeadRecord(call.id, call.analysis);
    }
  } catch (error) {
    console.error('Webhook processing failed:', error);
  }
});
```

### Lead Intent Processing with Idempotency

```javascript
async function processLeadIntent(callId, transcriptText) {
  const budgetMatch = transcriptText.match(/\$?([\d,]+)k?/i);
  const locationMatch = transcriptText.match(/\b(downtown|suburb|waterfront)\b/i);

  if (budgetMatch && locationMatch) {
    const leadData = {
      callId,
      budget: parseInt(budgetMatch[1].replace(/,/g, '')),
      location: locationMatch[1],
      timestamp: Date.now(),
      status: 'qualified'
    };

    await fetch(process.env.CRM_WEBHOOK_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Idempotency-Key': callId
      },
      body: JSON.stringify(leadData)
    });
  }
}
```

### Voice AI Assistant Configuration

```javascript
const assistantConfig = {
  model: {
    provider: "openai",
    model: "gpt-4",
    temperature: 0.3,
    systemPrompt: "Extract: property type, budget range, location preference, timeline."
  },
  voice: { provider: "11labs", voiceId: "professional-female" },
  transcriber: { provider: "deepgram", model: "nova-2", language: "en-US" }
};
```
