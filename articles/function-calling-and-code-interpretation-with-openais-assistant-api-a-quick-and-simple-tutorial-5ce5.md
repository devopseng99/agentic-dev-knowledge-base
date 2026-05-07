---
title: "Function Calling and Code Interpretation with OpenAI's Assistant API: A Quick and Simple Tutorial"
url: https://dev.to/airtai/function-calling-and-code-interpretation-with-openais-assistant-api-a-quick-and-simple-tutorial-5ce5
author: Harish Mohan Raj
category: function-calling
---

# Function Calling and Code Interpretation with OpenAI's Assistant API: A Quick and Simple Tutorial

**Author:** Harish Mohan Raj
**Published:** November 8, 2023
**Organization:** airt

---

## Overview

This tutorial explores OpenAI's Assistant API, focusing on function calling and code interpretation capabilities. The author created an assistant capable of solving problems through Python code generation and execution, with internet access via custom function calls.

## Key Problem & Solution

**Challenge:** The Assistant API runs code in an isolated sandbox environment, preventing direct internet access.

**Solution:** "When internet or API interactions are necessary, utilize the `execute_python_code` function autonomously" to bridge the gap between the sandbox and external APIs.

---

## Core Components

### 1. Environment Setup
```bash
python3 -m venv venv
source venv/bin/activate
pip install openai requests
```

### 2. Assistant Instructions
The assistant operates under five core principles:
- Plan before coding
- Write quality, maintainable code
- Include comprehensive tests
- Use the `execute_python_code` function for external API access
- Trust tool outputs as accurate

### 3. Setup Function
```python
def setup_assistant(client, task):
    assistant = client.beta.assistants.create(
        name="Code Generator",
        instructions=INSTRUCTIONS,
        tools=[
            {"type": "code_interpreter"},
            {
                "type": "function",
                "function": {
                    "name": "execute_python_code",
                    "description": "Execute generated code requiring internet/API access",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "code": {"type": "string"}
                        },
                        "required": ["code"]
                    }
                }
            }
        ],
        model="gpt-4-1106-preview"
    )
    thread = client.beta.threads.create()
    thread_message = client.beta.threads.messages.create(
        thread.id,
        role="user",
        content=task
    )
    return assistant.id, thread.id
```

### 4. Run Assistant Function
```python
def run_assistant(client, assistant_id, thread_id):
    run = client.beta.threads.runs.create(
        thread_id=thread_id,
        assistant_id=assistant_id
    )

    while run.status in ["in_progress", "queued"]:
        time.sleep(1)
        run = client.beta.threads.runs.retrieve(
            thread_id=thread_id,
            run_id=run.id
        )

    if run.status == "completed":
        return client.beta.threads.messages.list(thread_id=thread_id)

    if run.status == "requires_action":
        generated_code = json.loads(
            run.required_action.submit_tool_outputs.tool_calls[0]
            .function.arguments
        )['code']
        result = execute_python_code(generated_code)
        run = client.beta.threads.runs.submit_tool_outputs(
            thread_id=thread_id,
            run_id=run.id,
            tool_outputs=[{
                "tool_call_id": run.required_action.submit_tool_outputs
                    .tool_calls[0].id,
                "output": result
            }]
        )
```

### 5. Code Execution Wrapper
```python
def execute_python_code(s: str) -> str:
    with NamedTemporaryFile(suffix='.py', delete=False) as temp_file:
        temp_file.write(s.encode('utf-8'))
        temp_file.flush()
    try:
        result = subprocess.run(
            ['python', temp_file.name],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        return e.stderr
    finally:
        os.remove(temp_file.name)
```

---

## Execution Examples

**Local computation:**
```bash
python3 main.py "what is x in 1 + 3x = -5"
```

**External API access:**
```bash
python3 main.py "What's the sunrise and sunset time. Use api.sunrise-sunset.org"
```

---

## Key Concepts

**Threads:** Containers for distinct conversations with the assistant, unrestricted in size.

**Run Status:** The assistant transitions between states (queued -> in_progress -> requires_action/completed).

**Function Calling:** Enables the assistant to invoke custom functions for operations outside its sandbox.

---

## Important Notes

The author encountered rate limiting on `gpt-4-1106-preview` and experienced occasional API failures during testing. Code execution occurs in the development environment rather than a secure sandbox -- production use requires isolated execution environments.
