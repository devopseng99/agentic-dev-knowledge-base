---
title: "Building a Custom Telegram Bot with AI: Beyond Simple Commands"
url: "https://dev.to/eqhoids/building-a-custom-telegram-bot-with-ai-beyond-simple-commands-ead"
author: "Ekrem MUTLU"
category: "ai-agent-telegram-bot"
---

# Building a Custom Telegram Bot with AI: Beyond Simple Commands

**Author:** Ekrem MUTLU
**Published:** March 17, 2026

## Overview
Building sophisticated Telegram bots with AI including multimodal capabilities (text, voice, images), conversation memory, tool use, personality, and Docker deployment.

## Key Concepts

### Text Message Handler

```python
from telegram import Update
from telegram.ext import ApplicationBuilder, ContextTypes, MessageHandler, filters
import openai

async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user_message = update.message.text
    await update.message.reply_text(response)

if __name__ == '__main__':
    application = ApplicationBuilder().token(TELEGRAM_BOT_TOKEN).build()
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    application.run_polling()
```

### Voice Message Handler

```python
import speech_recognition as sr
from pydub import AudioSegment

async def handle_voice(update: Update, context: ContextTypes.DEFAULT_TYPE):
    voice = await update.message.voice.get_file()
    await voice.download_to_drive('voice.ogg')
    sound = AudioSegment.from_ogg("voice.ogg")
    sound.export("voice.wav", format="wav")
    r = sr.Recognizer()
    with sr.AudioFile('voice.wav') as source:
        audio = r.record(source)
    try:
        text = r.recognize_google(audio)
        await update.message.reply_text(response)
    except sr.UnknownValueError:
        await update.message.reply_text("Could not understand audio")
```

### AI Response Generation

```python
openai.api_key = OPENAI_API_KEY

async def generate_response(prompt):
    completion = openai.Completion.create(
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=150,
        temperature=0.7,
    )
    return completion.choices[0].text.strip()
```

### Conversation Memory

```python
conversation_history = {}

async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user_id = update.message.from_user.id
    user_message = update.message.text
    if user_id not in conversation_history:
        conversation_history[user_id] = []
    conversation_history[user_id].append({"role": "user", "content": user_message})
    prompt = "".join([f'{m["role"]}: {m["content"]}\n' for m in conversation_history[user_id][-5:]])
    response = await generate_response(prompt)
    conversation_history[user_id].append({"role": "assistant", "content": response})
    await update.message.reply_text(response)
```

### Docker Deployment

```dockerfile
FROM python:3.9-slim-buster
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "your_bot_file.py"]
```

```bash
docker build -t telegram-ai-bot .
docker run -d -e TELEGRAM_BOT_TOKEN=YOUR_TOKEN -e OPENAI_API_KEY=YOUR_KEY telegram-ai-bot
```
