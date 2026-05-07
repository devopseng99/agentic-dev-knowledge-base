---
title: "Build a ChatBot Using Python, Django"
url: "https://dev.to/documatic/build-a-chatbot-using-python-django-46hb"
author: "Hana Belay"
category: "ai-agent-django"
---

# Build a ChatBot Using Python, Django

**Author:** Hana Belay
**Published:** November 17, 2022

## Overview
A comprehensive guide to implementing a chatbot in a Django application using ChatterBot, Django Channels with WebSocket support, Celery for background tasks, and Redis as message broker. Includes Tailwind CSS for the UI.

## Key Concepts
- ChatterBot library for automated response generation
- Django Channels for WebSocket (ASGI) support
- Celery for background task processing
- Redis as message broker and channel layer

## Code Examples

### Project Setup
```bash
mkdir chatbot
cd chatbot
git clone https://github.com/earthcomfy/blog-template .
docker-compose up --build
docker-compose run --rm web python manage.py startapp chat
```

### ASGI Configuration (asgi.py)
```python
import os
from channels.auth import AuthMiddlewareStack
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.security.websocket import AllowedHostsOriginValidator
from decouple import config
from django.core.asgi import get_asgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", config("DJANGO_SETTINGS_MODULE"))

django_asgi_app = get_asgi_application()

application = ProtocolTypeRouter({
    "http": django_asgi_app,
})
```

### Settings Configuration
```python
ASGI_APPLICATION = "config.asgi.application"

CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels_redis.core.RedisChannelLayer",
        "CONFIG": {
            "hosts": [config("REDIS_BACKEND")],
        },
    },
}

INSTALLED_APPS = [
    "daphne",
    "django.contrib.admin",
    # ... other apps
    "tailwind",
    "chat",
]

TAILWIND_APP_NAME = "theme"
```

### Chat Template (chat/templates/chat/chat.html)
```html
{% extends 'base.html' %}
{% block body %}
<div class="p-6 w-[800px]">
  <h1 class="text-3xl tracking-tight font-light" id="chat-header"></h1>
  <div id="chat-log" class="mt-4 w-full relative p-6 overflow-y-auto h-[30rem] bg-gray-50 border border-gray-200"></div>
  <div class="mt-4">
    <input id="chat-message-input" class="py-2 outline-none bg-gray-50 border border-gray-300"
           type="text" placeholder="Write your message here."/>
    <button id="chat-message-submit" class="py-2 px-4 ml-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-800 hover:bg-blue-900"
            type="submit">Send</button>
  </div>
</div>
{% endblock %}
```

### WebSocket Client JavaScript
```javascript
var wss_protocol = window.location.protocol == "https:" ? "wss://" : "ws://";
var chatSocket = new WebSocket(wss_protocol + window.location.host + "/ws/chat/");
var messages = [];

chatSocket.onopen = function(e) {
  document.querySelector("#chat-header").innerHTML = "Welcome to Django Chatbot";
};

chatSocket.onmessage = function(e) {
  var data = JSON.parse(e.data);
  var message = data["text"];
  messages.push(message);

  var str = '<ul class="space-y-2">';
  messages.forEach(function(msg) {
    str += `<li class="flex ${msg.source == "bot" ? "justify-start" : "justify-end"}">
      <div class="relative max-w-xl px-4 py-2 rounded-lg shadow-md ${
        msg.source == "bot" ? "text-gray-700 bg-white border border-gray-200" : "bg-blue-600 text-white"
      }">
        <span class="block font-normal">${msg.msg}</span>
      </div>
    </li>`;
  });
  str += '</ul>';
  document.querySelector("#chat-log").innerHTML = str;
};

chatSocket.onclose = function(e) {
  alert("Socket closed unexpectedly, please reload the page.");
};

document.querySelector("#chat-message-input").focus();
document.querySelector("#chat-message-input").onkeyup = function(e) {
  if (e.keyCode === 13) {
    document.querySelector("#chat-message-submit").click();
  }
};

document.querySelector("#chat-message-submit").onclick = function(e) {
  var messageInputDom = document.querySelector("#chat-message-input");
  var message = messageInputDom.value;
  chatSocket.send(JSON.stringify({text: message}));
  messageInputDom.value = "";
};
```

### URL Configuration
```python
# chat/urls.py
from django.urls import path
from .views import ChatView

app_name = "chat"
urlpatterns = [
    path("", ChatView.as_view(), name="chat_view")
]

# project urls.py
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include("chat.urls", namespace="chat")),
]
```

### View
```python
from django.views.generic import TemplateView

class ChatView(TemplateView):
    template_name: str = "chat/chat.html"
```

### Tailwind Setup
```bash
docker-compose run --rm web python manage.py tailwind init
docker-compose run --rm web python manage.py tailwind install
```
