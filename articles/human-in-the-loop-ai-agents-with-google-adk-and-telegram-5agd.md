---
title: "Human-in-the-Loop AI Agents with Google ADK and Telegram"
url: "https://dev.to/jameszh/human-in-the-loop-ai-agents-with-google-adk-and-telegram-5agd"
author: "James Zhang"
category: "ai-agent-telegram-bot"
---

# Human-in-the-Loop AI Agents with Google ADK and Telegram

**Author:** James Zhang
**Published:** March 16, 2026

## Overview
Extending Google's ADK `human_in_loop` sample into a production-ready system with real chat UI and Telegram notifications with approval buttons.

## Key Concepts

### Agent Definition

```python
root_agent = Agent(
    model='gemini-2.5-flash',
    name='reimbursement_agent',
    instruction="""
      If the amount is less than $100, automatically approve.
      If greater than $100, ask for approval from the manager.
      If approved, call reimburse(). If rejected, inform the employee.
    """,
    tools=[reimburse, LongRunningFunctionTool(func=ask_for_approval)],
)
```

### Capturing Long-Running Calls

```python
async for event in runner.run_async(
    session_id=req.session_id,
    user_id=req.user_id,
    new_message=content,
):
    for part in event.content.parts:
        if part.function_call and part.function_call.id in (event.long_running_tool_ids or []):
            long_running_fc = part.function_call
        if part.function_response and long_running_fc and part.function_response.id == long_running_fc.id:
            initial_response = part.function_response
            ticket_id = initial_response.response.get("ticketId")
```

### Telegram Approval Message

```python
keyboard = {
    "inline_keyboard": [[
        {"text": "Approve", "callback_data": f"approve:{ticket_id}"},
        {"text": "Reject",  "callback_data": f"reject:{ticket_id}"},
    ]]
}
await _telegram_post("sendMessage", {
    "chat_id": TELEGRAM_CHAT_ID,
    "text": f"*Reimbursement Approval Required*\n\n*Purpose:* {purpose}\n*Amount:* ${amount:.2f}",
    "parse_mode": "Markdown",
    "reply_markup": keyboard,
})
```

### Feeding Decision Back to Agent

```python
updated_part = types.Part(
    function_response=types.FunctionResponse(
        id=ticket["function_call_id"],
        name=ticket["function_call_name"],
        response={
            "status": decision,
            "ticketId": ticket_id,
            "approver_feedback": f"{decision.capitalize()} via Telegram",
        },
    )
)

async for event in runner.run_async(
    session_id=ticket["session_id"],
    user_id=ticket["user_id"],
    new_message=types.Content(parts=[updated_part], role="user"),
):
    ...
```

### Browser Polling

```javascript
async function pollStatus(ticketId, pendingMsgEl) {
  while (true) {
    await new Promise(r => setTimeout(r, 2000));
    const res = await fetch(`/status/${ticketId}`);
    const data = await res.json();
    if (data.status === 'approved' || data.status === 'rejected') {
      pendingMsgEl.remove();
      addMessage(data.result, data.status);
      break;
    }
  }
}
```

### Critical Lesson
"You must match the `function_call_id` exactly when sending back the updated response."

### Setup

```bash
cp .env.example .env
pip install google-adk fastapi uvicorn httpx python-dotenv
uvicorn api:app --reload
```
