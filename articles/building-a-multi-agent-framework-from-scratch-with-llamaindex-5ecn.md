---
title: "Building a Multi-Agent Framework from Scratch with LlamaIndex"
url: "https://dev.to/yukooshima/building-a-multi-agent-framework-from-scratch-with-llamaindex-5ecn"
author: "Yusen Meng"
category: "multi-agent system Python"
---

# Building a Multi-Agent Framework from Scratch with LlamaIndex

**Author:** Yusen Meng
**Published:** October 29, 2024

## Overview
A comprehensive tutorial demonstrating construction of a progressively sophisticated multi-agent system using LlamaIndex, culminating in an Anki flashcard generation application. The framework is built across four iterative versions, each adding complexity and specialized capabilities.

## Key Concepts

### Version 1: Basic Single-Agent System

```python
class QACard(BaseModel):
    question: str
    answer: str
    extra: str

class Flashcard_model(BaseModel):
    cards: List[QACard]
```

```python
def get_shared_llm():
    return OpenAI(
        model="gpt-4o-mini",
        temperature=0,
        api_base="http://127.0.0.1:4000/v1",
        api_key="sk-test"
    )
```

```python
def qa_generator_factory() -> OpenAIAgent:
    system_prompt = """You are an educational content creator specializing
    in Anki flashcard generation..."""
    return OpenAIAgent.from_tools(
        [],
        llm=get_shared_llm(),
        system_prompt=system_prompt,
    )
```

```python
@retry(stop=stop_after_attempt(3),
       wait=wait_exponential(multiplier=1, min=4, max=10))
def transformer(message: str) -> dict:
    chat_prompt_tmpl = ChatPromptTemplate(
        message_templates=[
            ChatMessage.from_str(message, role="user")
        ]
    )
    llm = get_shared_llm()
    structured_data = llm.structured_predict(
        Flashcard_model, chat_prompt_tmpl
    )
    return structured_data.model_dump()
```

```python
def generate_anki_cards(input_text: str) -> dict:
    agent = qa_generator_factory()
    response = agent.chat(
        f"Generate Anki flashcards from the following text:\n\n{input_text}"
    )
    structured_response = transformer(str(response))
    return structured_response
```

### Version 2: Two-Agent System with Reviewer

```python
class Speaker(str, Enum):
    QA_GENERATOR = "Q&A Generator"
    REVIEWER = "Reviewer"
```

```python
def reviewer_factory() -> OpenAIAgent:
    system_prompt = """You are the Reviewer agent. Your task is to review
    and refine Anki flashcards, ensuring they follow these rules:
    1. Each card should test ONE piece of information
    2. Questions must be simple, direct, testing single facts
    3. Answers must be brief and precise
    4. Extra field must include detailed explanations..."""
    return OpenAIAgent.from_tools(
        [],
        llm=get_shared_llm(),
        system_prompt=system_prompt,
    )
```

```python
def generate_anki_cards(input_text: str) -> dict:
    state = get_initial_state(input_text)

    generator = qa_generator_factory()
    response = generator.chat(
        f"Generate Anki flashcards from the following text:\n\n{state['input_text']}"
    )
    state["qa_cards"] = str(response)

    reviewer = reviewer_factory()
    review_response = reviewer.chat(
        f"Review and improve these flashcards:\n\n{state['qa_cards']}"
    )
    state["qa_cards"] = str(review_response)

    return transformer(state["qa_cards"])
```

### Version 3: Multi-Agent Orchestra with Orchestrator

```python
def orchestrator_factory(state: dict) -> OpenAIAgent:
    system_prompt = f"""You are the Orchestrator agent. Your task is to
    coordinate the interaction between all agents to create high-quality flashcards.

    Current State:
    {pformat(state, indent=2)}

    Available agents:
    * Topic Analyzer - Breaks down complex topics
    * Q&A Generator - Creates flashcards
    * Reviewer - Improves card quality

    Output only the next agent to run ("Topic Analyzer", "Q&A Generator",
    "Reviewer", or "END")"""
    return OpenAIAgent.from_tools(
        [],
        llm=get_shared_llm(),
        system_prompt=system_prompt,
    )
```

```python
def generate_anki_cards(input_text: str) -> dict:
    state = get_initial_state(input_text)
    memory = setup_memory()

    while True:
        current_history = memory.get()

        orchestrator = orchestrator_factory(state)
        next_agent = str(orchestrator.chat(
            "Decide which agent to run next based on the current state.",
            chat_history=current_history
        )).strip().strip('"').strip("'")
        print(f"\nOrchestrator selected: {next_agent}")

        if next_agent == "END":
            break

        try:
            if next_agent == Speaker.TOPIC_ANALYZER.value:
                analyzer = topic_analyzer_factory(state)
                response = analyzer.chat(
                    f"Analyze this text for flashcard topics:\n\n{state['input_text']}",
                    chat_history=current_history
                )
                state["topics"] = str(response)

            elif next_agent == Speaker.QA_GENERATOR.value:
                generator = qa_generator_factory()
                response = generator.chat(
                    f"Generate flashcards for this topic:\n\n{state['topics']}",
                    chat_history=current_history
                )
                state["qa_cards"] = str(response)
                state["review_status"] = "needs_review"

            elif next_agent == Speaker.REVIEWER.value:
                reviewer = reviewer_factory()
                response = reviewer.chat(
                    f"Review these flashcards:\n\n{state['qa_cards']}",
                    chat_history=current_history
                )
                state["qa_cards"] = str(response)
                state["review_status"] = "reviewed"

                memory.put(ChatMessage(
                    role="assistant",
                    content=str(response)
                ))

        except Exception as e:
            print(f"\nError in {next_agent}: {str(e)}")
            continue

    final_cards = transformer(state["qa_cards"])
    return final_cards
```

### Version 4: Enhanced with Code Expert and Formatter

```python
class Speaker(str, Enum):
    QA_GENERATOR = "Q&A Generator"
    REVIEWER = "Reviewer"
    TOPIC_ANALYZER = "Topic Analyzer"
    ORCHESTRATOR = "Orchestrator"
    CODE_AND_EXTRA_FIELD_EXPERT = "Code and Extra Field Expert"
    FORMATTER = "Formatter"
```

```python
def code_and_extra_field_expert_factory() -> OpenAIAgent:
    system_prompt = """You are the Code and Extra Field Expert agent. Your
    task is to enhance Anki flashcards by adding relevant code snippets and
    comprehensive extra content.

    Instructions:
    1. Add clear, concise code examples that illustrate key concepts
    2. Ensure code snippets are well-commented and easy to understand
    3. In the extra field, provide:
       - Step-by-step explanations of code snippets
       - Common use cases and scenarios
       - Potential pitfalls and edge cases
       - Best practices and optimization tips
    4. Use appropriate markdown formatting for code blocks
    5. Include relevant documentation links
    6. Ensure explanations are clear for a 15-year-old"""
    return OpenAIAgent.from_tools(
        [],
        llm=get_shared_llm(),
        system_prompt=system_prompt,
    )
```
