---
title: "Best User Agents for Web Scraping & How to Use Them"
url: "https://dev.to/luisgustvo/best-user-agents-for-web-scraping-how-to-use-them-1o6j"
author: "luisgustvo"
category: "agent-web-scraping-automation"
---

# Best User Agents for Web Scraping & How to Use Them

**Author:** luisgustvo
**Published:** March 11, 2025

## Overview

A comprehensive guide to user agent selection and rotation for web scraping, with Python implementation examples covering requests, Selenium, and fake_useragent library.

## Key Concepts

### What Is a User Agent?

A string sent in HTTP request headers identifying browser, OS, and other details:

```
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36
```

### Setting a Static User Agent with requests

```python
import requests

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"
}

response = requests.get("https://httpbin.org/headers", headers=headers)
print(response.text)
```

### Rotating User Agents

```python
import requests
import random

user_agents = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0"
]

headers = {"User-Agent": random.choice(user_agents)}
response = requests.get("https://httpbin.org/headers", headers=headers)
print(response.text)
```

### Using fake_useragent Library

```python
from fake_useragent import UserAgent
import requests

ua = UserAgent()
headers = {"User-Agent": ua.random}
response = requests.get("https://httpbin.org/headers", headers=headers)
print(response.text)
```

### Setting User Agent in Selenium

```python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

chrome_options = Options()
chrome_options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36")

driver = webdriver.Chrome(options=chrome_options)
driver.get("https://httpbin.org/headers")
print(driver.page_source)
driver.quit()
```

### Verifying User Agents with Logging

```python
import requests
import random
import time

user_agents = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0"
]

for i in range(5):
    user_agent = random.choice(user_agents)
    headers = {"User-Agent": user_agent}
    response = requests.get("https://httpbin.org/headers", headers=headers)
    print(f"Request {i+1} - User-Agent: {user_agent}")
    time.sleep(2)
```

### Best Practices

- Use proxies to prevent IP bans
- Implement delays and random intervals between requests
- Rotate headers and request patterns to mimic human behavior
- Avoid excessive scraping that triggers rate limits
- Monitor response codes to detect blocks and adapt
