---
title: "How to Create an AI Companion Telegram Bot"
url: "https://dev.to/manozzo/how-to-create-an-ai-companion-telegram-bot-2d78"
author: "Rodrigo Manozzo"
category: "ai-agent-telegram-bot"
---

# How to Create an AI Companion Telegram Bot

**Author:** Rodrigo Manozzo
**Published:** December 10, 2024

## Overview
Building an AI-powered Telegram bot using Ollama (self-hosted Llama model) and Node.js on a VM without GPU requirements.

## Key Concepts

### Ollama Setup

```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama serve
ollama pull llama:3.2:1b
```

### Node.js & PM2 Setup

```bash
sudo apt update
sudo apt install -y nodejs npm
sudo npm install -g pm2
mkdir ai-telegram-bot
cd ai-telegram-bot
npm init -y
npm install dotenv node-telegram-bot-api
```

### Ollama Service

```javascript
const axios = require("axios");

const apiUrl = "http://localhost:11434/api/generate";

async function queryOllama(message) {
  try {
    const response = await axios.post(apiUrl, {
      model: "llama3.2:1b",
      prompt: message,
      stream: false,
    });
    const respData = response.data.response.toString();
    return respData;
  } catch (error) {
    console.error(error);
    throw new Error("Failed to query Ollama");
  }
}

module.exports = { queryOllama };
```

### Telegram Bot Service

```javascript
require("dotenv").config();
const TelegramBot = require("node-telegram-bot-api");
const { queryOllama } = require("./ollamaService");

const token = process.env.TELEGRAM_BOT_TOKEN;
const bot = new TelegramBot(token, { polling: true });

bot.on("message", async (msg) => {
  const chatId = msg.chat.id;
  switch (msg.text) {
    case "/start":
      bot.sendMessage(chatId, "Welcome to Ollama Bot! Send me a message.");
      break;
    case "/help":
      bot.sendMessage(chatId, "Send me a message and I will respond using llama3.2.");
      break;
    default:
      bot.sendChatAction(chatId, "typing");
      try {
        const response = await queryOllama(msg.text);
        bot.sendMessage(chatId, response);
      } catch (error) {
        bot.sendMessage(chatId, "Oops, something went wrong. Please try again.");
      }
  }
});
```

### Deployment with PM2

```bash
pm2 start src/services/telegramBotService.js --name ai-telegram-bot
pm2 save
pm2 logs ai-telegram-bot
```
