---
title: "Function Calling and Tool Use: Turning LLMs into Action-Taking Agents"
url: https://dev.to/qvfagundes/function-calling-and-tool-use-turning-llms-into-action-taking-agents-30ca
author: Vinicius Fagundes
category: function-calling
---

# Function Calling and Tool Use: Turning LLMs into Action-Taking Agents

**Author:** Vinicius Fagundes
**Published:** December 4, 2025
**Series:** The Modern Data Engineering AI Roadmap (Part 5 of 13)

---

## Overview

Function calling transforms LLMs from passive text generators into active agents capable of executing real-world actions. Rather than merely generating text, models can now decide when to invoke external tools and what parameters to pass, enabling integration with databases, APIs, and business logic systems.

---

## Key Concepts

### Universal Capability Across Providers

"Function calling is a **two-step conversation** between you and the LLM." The capability works universally across:

- OpenAI (GPT-4, GPT-3.5)
- Anthropic (Claude)
- Open-source models (Llama, Mistral)
- Google (Gemini)

### The Protocol Flow

1. **Define functions** via JSON schemas
2. **LLM decides** which function to call
3. **Execute** the selected function
4. **Return results** to the LLM for final response generation

---

## Implementation Examples

### Provider-Agnostic Approach with LiteLLM

```python
from litellm import completion
import json

def get_weather(city: str, units: str = "celsius") -> dict:
    """Get current weather for a city"""
    weather_data = {
        "Tokyo": {"temp": 22, "condition": "partly cloudy"},
        "London": {"temp": 15, "condition": "rainy"},
    }
    return weather_data.get(city, {"temp": 20, "condition": "unknown"})

tools = [
    {
        "type": "function",
        "function": {
            "name": "get_weather",
            "description": "Get the current weather for a specific city",
            "parameters": {
                "type": "object",
                "properties": {
                    "city": {"type": "string"},
                    "units": {"type": "string", "enum": ["celsius", "fahrenheit"]}
                },
                "required": ["city"]
            }
        }
    }
]

def run_agent(model: str, user_query: str):
    messages = [{"role": "user", "content": user_query}]

    response = completion(
        model=model,
        messages=messages,
        tools=tools,
        tool_choice="auto"
    )

    message = response.choices[0].message

    if message.tool_calls:
        tool_call = message.tool_calls[0]
        function_name = tool_call.function.name
        function_args = json.loads(tool_call.function.arguments)

        result = get_weather(**function_args)

        messages.append(message)
        messages.append({
            "role": "tool",
            "tool_call_id": tool_call.id,
            "content": json.dumps(result)
        })

        final_response = completion(model=model, messages=messages)
        return final_response.choices[0].message.content

    return message.content
```

### Multi-Tool Customer Support Agent

```python
def search_knowledge_base(query: str, max_results: int = 5) -> list:
    """Search documentation for relevant articles"""
    knowledge_base = {
        "password reset": [
            {"title": "How to Reset Password", "content": "Click 'Forgot Password'..."}
        ],
        "billing": [
            {"title": "Understanding Your Bill", "content": "Your bill includes..."}
        ]
    }
    results = []
    query_lower = query.lower()
    for key, articles in knowledge_base.items():
        if key in query_lower:
            results.extend(articles[:max_results])
    return results[:max_results]

def get_order_status(order_id: str) -> dict:
    """Get current status of an order"""
    orders = {
        "ORD-12345": {
            "status": "shipped",
            "tracking": "TRK789XYZ",
            "estimated_delivery": "2024-03-15"
        }
    }
    return orders.get(order_id, {"error": "Order not found"})

def create_support_ticket(
    customer_email: str,
    issue_category: str,
    description: str,
    priority: str = "medium"
) -> dict:
    """Create a new support ticket"""
    ticket_id = f"TKT-{datetime.now().strftime('%Y%m%d%H%M%S')}"
    return {
        "ticket_id": ticket_id,
        "status": "open",
        "created_at": datetime.now().isoformat()
    }
```

---

## Production Patterns

### Argument Validation

```python
def validate_function_call(
    function_name: str,
    arguments: dict,
    function_schemas: list
) -> tuple[bool, Optional[str]]:
    """Validate that function call matches schema"""

    schema = next((s for s in function_schemas if s["name"] == function_name), None)
    if not schema:
        return False, f"Function {function_name} not found"

    required_params = schema["parameters"].get("required", [])
    for param in required_params:
        if param not in arguments:
            return False, f"Missing required parameter: {param}"

    return True, None
```

### Error Handling with Retry Logic

```python
def execute_function_with_retry(
    function_name: str,
    arguments: dict,
    max_retries: int = 3,
    backoff_factor: float = 2.0
) -> dict:
    """Execute function with exponential backoff retry"""

    for attempt in range(max_retries):
        try:
            result = func(**arguments)
            return {"success": True, "data": result}
        except Exception as e:
            if attempt == max_retries - 1:
                return {"success": False, "error": str(e)}
            wait_time = backoff_factor ** attempt
            time.sleep(wait_time)
```

### Rate Limiting

```python
class RateLimiter:
    """Simple rate limiter for function calls"""

    def __init__(self, max_calls: int, time_window: int):
        self.max_calls = max_calls
        self.time_window = time_window
        self.calls = defaultdict(list)
        self.lock = threading.Lock()

    def is_allowed(self, function_name: str) -> bool:
        with self.lock:
            now = datetime.now()
            cutoff = now - timedelta(seconds=self.time_window)
            self.calls[function_name] = [
                call_time for call_time in self.calls[function_name]
                if call_time > cutoff
            ]
            if len(self.calls[function_name]) < self.max_calls:
                self.calls[function_name].append(now)
                return True
            return False
```

---

## Provider Comparison

| Feature | OpenAI | Anthropic | Llama (Native) |
|---------|--------|-----------|----------------|
| API field name | `functions` | `tools` | Prompt-based |
| Schema format | `parameters` | `input_schema` | Description in prompt |
| Response parsing | `message.function_call` | `tool_use` block | JSON extraction |
| Native support | Yes | Yes | No (Prompt engineering) |

---

## Setup & Installation

```bash
# Core libraries
pip install openai
pip install anthropic
pip install litellm

# Type safety
pip install pydantic

# Optional frameworks
pip install langchain
pip install llama-index
```

**For Ollama (local Llama models):**
```bash
curl -fsSL https://ollama.ai/install.sh | sh
ollama pull llama3.1
ollama serve
```

---

## Business Impact

**Cost Reduction:**
- Function calling is cheaper than extensive prompt engineering
- Single function call replaces hundreds of tokens in examples
- Reusable tools across conversations

**Quality Improvements:**
- Structured JSON outputs eliminate parsing errors
- Type safety and validation ensure correctness
- Deterministic tool execution

**Performance Gains:**
- Direct API calls outperform prompt-based simulation
- Real-time data access eliminates staleness
- Composable, maintainable tools reduce complexity

---

## Real-World Example: Customer Support Automation

**Before function calling:**
- Manual knowledge base searches
- Email/ticket system for all queries
- 10-15 minute response time
- High support costs

**After function calling:**
- Instant knowledge base lookup
- Automated order status checks
- 30-second response time
- 70% reduction in support tickets

---

## Key Takeaways

1. **Provider Independence:** Function calling is universal; use abstraction layers to avoid vendor lock-in
2. **Start Small:** Begin with 1-2 simple functions before expanding
3. **Validation First:** Always validate arguments before execution
4. **Production Ready:** Implement retry logic, rate limiting, and comprehensive logging
5. **Orchestration:** LLMs automatically choose the right tool for sequential multi-step workflows

Function calling bridges the gap from conversational AI to actionable agents that integrate with business systems and take real-world actions.
