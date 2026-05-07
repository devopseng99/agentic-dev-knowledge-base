---
title: "Routing Medical Claims with an Intelligent Agent: Deterministic Logic Meets Structured AI Output"
url: "https://dev.to/exploredataaiml/routing-medical-claims-with-an-intelligent-agent-deterministic-logic-meets-structured-ai-output-14hh"
author: "Aniket Hingane"
category: "domain-agents"
---

# Routing Medical Claims with an Intelligent Agent
**Author:** Aniket Hingane
**Published:** March 14, 2026

## Overview
ClaimsRouter-AI is an agentic system for hospital medical claims routing that separates deterministic computation from language model reasoning. It processes claims through three stages: deterministic tool chain, LLM synthesis using Google Gemini, and Pydantic validation. Processes 50 synthetic claims in under one second.

## Key Concepts
Five deterministic tools run in fixed sequence before the LLM engages, producing a complete trace. Weighted priority scoring uses aging 35%, financial impact 45%, denial risk 20%.

```python
class ClaimRecord(BaseModel):
    claim_id: str = Field(..., description="Unique claim identifier", min_length=6)
    patient_id: str
    service_date: date
    submission_date: date
    charged_amount: float = Field(..., gt=0)
    allowed_amount: Optional[float] = Field(None, ge=0)
    paid_amount: Optional[float] = Field(None, ge=0)
    payer_type: PayerType
    denial_code: Optional[str] = None
    claim_status: ClaimStatus
    cpt_codes: List[str]
    icd10_codes: List[str]
    days_in_ar: int = Field(..., ge=0)

    @property
    def underpayment_amount(self) -> float:
        if self.allowed_amount is not None and self.paid_amount is not None:
            return max(0.0, self.allowed_amount - self.paid_amount)
        return 0.0
```

```python
def compute_aging_band(claim: ClaimRecord) -> ToolCallResult:
    days = claim.days_in_ar
    if days <= 30:
        band = AgingBand.CURRENT
        urgency_score = 20.0
    elif days <= 60:
        band = AgingBand.FIRST_BUCKET
        urgency_score = 45.0
    elif days <= 90:
        band = AgingBand.SECOND_BUCKET
        urgency_score = 70.0
    else:
        band = AgingBand.CRITICAL
        urgency_score = min(100.0, 70.0 + (days - 90) * 0.3)
    return ToolCallResult(
        tool_name="compute_aging_band",
        input_summary=f"days_in_ar={days}",
        result_value=urgency_score,
        result_label=band.value,
        confidence=1.0,
    )
```
