---
title: "How I Built Philosophy AI Agent for WLH Project"
url: "https://dev.to/pravesh_sudha_3c2b0c2b5e0/how-i-built-philosophy-ai-agent-for-wlh-project-43ci"
author: "Pravesh Sudha"
category: "hackathons"
---

# How I Built Philosophy AI Agent for WLH Project
**Author:** Pravesh Sudha
**Published:** July 26, 2025

## Overview
A voice-based AI Philosopher built with AssemblyAI + Gemini for the World's Largest Hackathon. Users speak philosophical questions and receive spoken AI responses. Deployed on AWS EC2 with Nginx reverse proxy.

## Key Concepts

### Deployment Script
```bash
#!/bin/bash
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv nginx git
cd /home/ubuntu
git clone https://github.com/Pravesh-Sudha/dev-to-challenges.git
cd dev-to-challenges/philo-agent
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install gunicorn

sudo tee /etc/systemd/system/voiceapp.service > /dev/null <<EOF
[Unit]
Description=Gunicorn instance to serve Philosophy Voice App
After=network.target
[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/dev-to-challenges/philo-agent
Environment="PATH=/home/ubuntu/dev-to-challenges/philo-agent/venv/bin"
ExecStart=/home/ubuntu/dev-to-challenges/philo-agent/venv/bin/gunicorn --workers 4 --bind 127.0.0.1:8000 app:app
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload && sudo systemctl start voiceapp && sudo systemctl enable voiceapp
```

Tech: Flask, AssemblyAI (STT), Gemini API, gTTS, Gunicorn, Nginx, Let's Encrypt SSL

### GitHub Repository
- https://github.com/Pravesh-Sudha/dev-to-challenges

**Live App:** https://philosophy.praveshsudha.com
