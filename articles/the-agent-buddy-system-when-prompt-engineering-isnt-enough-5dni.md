---
title: "The Agent Buddy System: When Prompt Engineering Isn't Enough"
url: "https://dev.to/aws/the-agent-buddy-system-when-prompt-engineering-isnt-enough-5dni"
author: "Morgan Willis"
category: "aws-agents"
---

# The Agent Buddy System: When Prompt Engineering Isn't Enough
**Author:** Morgan Willis
**Published:** March 18, 2026

## Overview
Addresses instruction drift in production AI agents -- where agents gradually deviate from guidelines as conversations lengthen. Instead of expanding prompts, introduces a "buddy system" with a second evaluator agent that monitors output quality and provides corrective feedback. Demonstrates with a writing assistant using Strands Agents SDK. Large-scale evaluation (3,000 runs) shows steering achieves 100% accuracy with 66% fewer tokens than SOP-based approaches.

## Key Concepts

### Instruction Drift Problem
- Models pay less attention to earlier instructions as conversations extend
- Prompt engineering has diminishing returns
- Manifests as: style degradation, skipped steps, tone shifts

### Agent Buddy System Architecture
- Two-agent pattern: worker agent + evaluator agent
- LLM-as-judge assesses whether output meets criteria
- Three actions: `Proceed` (accept), `Guide` (reject with feedback), `Interrupt` (escalate)

### Steering Mechanism (Strands SDK)
- Just-in-time guidance injection during agent execution lifecycle
- Intercepts outputs post-generation
- Lifecycle hooks at multiple decision points
- Retry logic with configurable max attempts

### Performance Data
- **Unsteered baseline:** 25% voice adherence by session end
- **Steered version:** 100% voice adherence maintained
- **Large-scale (3,000 runs, Clare Liguori):**
  - Simple prompt: 82.5% accuracy
  - Agent SOPs: 99.8% accuracy, 3x token cost
  - Graph-based workflows: 80.8% accuracy
  - Steering: 100% accuracy, 66% fewer tokens than SOPs

### Common Failures Without Steering
- Skipping prerequisite checks (43% of failures)
- Missing confirmation steps (40% of failures)

### Design Considerations
- Each steering intervention = additional model call
- Guide actions trigger 2-3 round trips per response
- Using different model architectures for worker/evaluator improves catch rate
- Deterministic validation pairs well with LLM steering for high-stakes

## Code Examples

### VoiceSteeringHandler Implementation
```python
class VoiceSteeringHandler(SteeringHandler):
    """Evaluates writing output against a style guide using an LLM judge.

    Intercepts model responses via steer_after_model and uses a separate
    steering agent to check for style violations. If a violation is found,
    it guides the agent to rewrite with targeted feedback.
    """

    def __init__(self, style_guide: str, max_retries: int = 3):
        super().__init__(context_providers=[])
        self.style_guide = style_guide
        self.max_retries = max_retries
        self.retry_count = 0

    async def steer_after_model(
        self, *, agent: "Agent", message: Message, stop_reason: StopReason, **kwargs: Any
    ):
        """Evaluate model output against the style guide."""
        print("\n[STEERING] Evaluating model output...")
        text = " ".join(
            block.get("text", "") for block in message.get("content", [])
        )

        if self.retry_count >= self.max_retries:
            self.retry_count = 0
            return Proceed(reason="Max retries reached, accepting output")

        # Use a separate steering agent as an LLM judge
        steering_agent = Agent(
            system_prompt=f"""You evaluate writing against a style guide.
            Catch clear violations, not nitpicks.

            STYLE GUIDE:
            {self.style_guide}

            REJECT for: banned words/phrases from the style guide, em dashes,
            "It's not X. It's Y." reframing, obvious marketing tone, or meta-commentary.

            APPROVE if: tone is developer-to-developer with no banned words/phrases/patterns.
            When in doubt, APPROVE.

            Respond with APPROVE or REJECT: [quote the violation].""",
            model=agent.model,
            callback_handler=None,
        )

        result = str(steering_agent(f"Evaluate this text:\n\n{text}"))

        if "REJECT:" in result.upper():
            self.retry_count += 1
            feedback = result.split("REJECT:", 1)[-1].strip()
            return Guide(
                reason=f"Fix this issue: {feedback[:300]}. "
                "Only fix the cited issue. Output only the content, nothing else."
            )

        self.retry_count = 0
        return Proceed(reason="Output approved by steering agent")
```

### Agent Configuration with Steering Plugin
```python
model = BedrockModel(
    model_id="us.anthropic.claude-sonnet-4-20250514-v1:0",
    region_name="us-east-1",
)

return Agent(
    model=model,
    system_prompt=f"""You are a writing assistant that writes in a specific voice.
    Follow every rule in the style guide below. Output only the requested writing.
    Never add meta-commentary or questions like "Would you like me to adjust?"

    STYLE GUIDE:
    {style_guide}""",
    plugins=VoiceSteeringHandler(style_guide=style_guide),
)
```
