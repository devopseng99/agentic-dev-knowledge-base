---
title: "[Beginner] Docker Tutorial for jetson-containers on Jetson AGX Orin"
url: "https://dev.to/vonusma/beginner-docker-tutorial-for-jetson-containers-on-jetson-agx-orin-5bl8"
author: "Sergio Andres Usma"
category: "jetson-robotics"
---
# [Beginner] Docker Tutorial for jetson-containers on Jetson AGX Orin
**Author:** Sergio Andres Usma  **Published:** 2026-04-05

## Overview
Beginner-focused guide demonstrating Docker usage with the jetson-containers project on NVIDIA Jetson AGX Orin 64GB running Ubuntu 22.04 and JetPack 6.2.2. Provides practical, copy-pasteable commands for managing containers while emphasizing data safety through backups and volume management.

## Key Concepts
- Core Docker Terminology: Images (read-only templates), containers (running instances), Dockerfiles, volumes (persistent host directories), registries
- Data Backup Strategies: Directory and file backup procedures with timestamps
- Docker Verification: Checking installation and GPU support on Jetson
- Repository Setup: Cloning jetson-containers from GitHub
- Image Building: Docker build processes with caching options
- Container Lifecycle Management: Starting, stopping, executing, and removing containers
- Volume Management: Host-mounted directories and named Docker volumes

```bash
# Verify Docker Installation
docker version
docker info

# Backup with Timestamp
cp -a ~/projects/my-app \
  ~/backups/jetson-containers/my-app_$(date +%Y%m%d-%H%M%S)

# Test ARM64 Support
docker run --rm arm64v8/ubuntu:22.04 uname -a

# Clone Repository
cd ~
git clone https://github.com/dusty-nv/jetson-containers.git
cd jetson-containers

# Build Image
docker build -t my-jetson-image -f Dockerfile .

# Run Container with GPU Access
docker run -it --rm \
  --gpus all \
  --network host \
  --ipc host \
  -v ~/projects/my-app:/workspace/my-app \
  --name my-jetson-container \
  my-jetson-image \
  /bin/bash

# Execute Commands in Running Container
docker exec -it my-jetson-container /bin/bash

# Rebuild Without Cache
docker build --no-cache -t my-jetson-image -f Dockerfile .
```

## GitHub Repos
- https://github.com/dusty-nv/jetson-containers.git
