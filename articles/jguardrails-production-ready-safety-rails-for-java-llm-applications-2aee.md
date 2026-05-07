---
title: "JGuardrails: Production-Ready Safety Rails for Java LLM Applications"
url: "https://dev.to/ratila/jguardrails-production-ready-safety-rails-for-java-llm-applications-2aee"
author: "Daniil Ratnikau"
category: "llm-eval-alignment"
---
# JGuardrails: Production-Ready Safety Rails for Java LLM Applications
**Author:** Daniil Ratnikau  **Published:** April 11, 2026

## Overview
JGuardrails is a Java library adding safety mechanisms around LLM calls. A system prompt is a request; guardrails are enforcement. The framework implements a pipeline pattern with 1-5ms overhead per request in pattern mode.

## Key Concepts

### Pipeline Architecture
```
User Input → [InputRails] → LLM Client → [OutputRails] → User
```
Each rail returns PASS, BLOCK, or MODIFY.

### Input Rails

**JailbreakDetector**
- Regex-based pattern matching across 8 languages (English, Russian, German, French, Spanish, Polish, Italian, Chinese planned)
- Handles obfuscation: zero-width spaces, base64, ROT-13, spaced letters
- Three sensitivity levels: LOW, MEDIUM, HIGH

**PiiMasker**
- Detects: emails, phones, credit cards, IBANs, SSNs, IP addresses, dates of birth
- Strategies: REDACT, MASK_PARTIAL, HASH
- Example: `jane@example.com` → `[EMAIL REDACTED]`

**TopicFilter** — Blocklist or allowlist mode with built-in keywords for politics, religion, violence, adult content, drugs, medical/financial advice

**InputLengthValidator** — Prevents context-overflow attacks with configurable character and word limits

### Output Rails
- **ToxicityChecker** — Profanity, hate speech, threats, self-harm detection
- **OutputPiiScanner** — Masks PII in model responses
- **JsonSchemaValidator** — Validates JSON parsability including markdown code blocks
- **OutputLengthValidator** — Truncates or blocks oversized responses

### Installation

```gradle
dependencies {
    implementation("com.github.Ratila1:JGuardrails:v0.1.7")
    implementation("com.github.Ratila1.JGuardrails:jguardrails-spring-ai:v0.1.7")
    implementation("com.github.Ratila1.JGuardrails:jguardrails-langchain4j:v0.1.7")
}
```

### Spring AI Auto-Configuration

```yaml
jguardrails:
  fail-strategy: closed
  blocked-response: "I'm unable to process this request."
  input-rails:
    - type: jailbreak-detect
      sensitivity: high
    - type: pii-mask
      entities: [EMAIL, PHONE, CREDIT_CARD]
      strategy: redact
  output-rails:
    - type: toxicity-check
      categories: [PROFANITY, HATE_SPEECH]
```

### LangChain4j Integration

```java
ChatLanguageModel baseModel = OpenAiChatModel.builder()
    .apiKey(System.getenv("OPENAI_API_KEY"))
    .modelName("gpt-4o")
    .build();

ChatLanguageModel guardedModel = new GuardrailChatModelFilter(baseModel, pipeline);
String response = guardedModel.generate("Tell me about Java 21 virtual threads");
```

### Custom Rails

```java
public class CompanyPolicyRail implements InputRail {
    @Override public String name() { return "company-policy"; }
    @Override public int priority() { return 50; }

    @Override
    public RailResult process(String input, RailContext context) {
        if (input.toLowerCase().contains("confidential")) {
            return RailResult.block(name(), "Input contains restricted keyword");
        }
        return RailResult.pass(input, name());
    }
}
```

### Design Decisions
- Rails execute by priority (lower numbers run first — cheap checks before expensive ones)
- Fail-closed default blocks requests if a rail throws exceptions
- Framework-agnostic: Spring AI, LangChain4j, or custom HTTP clients
- GitHub: https://github.com/Ratila1/JGuardrails (Apache 2.0)
