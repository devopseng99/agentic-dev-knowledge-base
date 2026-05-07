---
title: "Architecture Teardown: How Replicate and Modal Host AI Models Using Kubernetes 1.34"
url: "https://dev.to/johalputt/architecture-teardown-how-replicate-and-modal-host-ai-models-using-kubernetes-134-nga"
author: "ANKUSH CHOUDHARY JOHAL"
category: "ai-image-video-generation"
---
# Architecture Teardown: How Replicate and Modal Host AI Models Using Kubernetes 1.34
**Author:** ANKUSH CHOUDHARY JOHAL  **Published:** 2026-05-06

## Overview
Technical analysis examining how Replicate and Modal leverage Kubernetes 1.34's capabilities to host AI image/video generation models at scale.

## Key Concepts

### Replicate's Architecture
Replicate uses Cog for containerization, packaging AI models into standardized Docker containers. The platform creates individual Kubernetes Deployments per model version.

Key architectural elements:
- Dynamic Resource Allocation (DRA) for fractional GPU sharing across inference workloads
- Improved scheduler latency reducing pod startup times by ~30%
- Container image caching and persistent volumes for model weights
- Horizontal Pod Autoscaler v2 with custom metrics based on request queue depth
- Scaling logic: HTTP request volume drives scaling decisions

### Modal's Architecture
Modal takes a code-first methodology where developers decorate Python functions with GPU specifications.

Notable features:
- Custom scheduler integrating with K8s 1.34's Topology Manager for GPU-CPU alignment
- gVisor sandboxing with enhanced security profiles
- cgroups v2 for strict resource isolation in multi-tenant environments
- Scale-to-zero capability when no requests pending
- Ephemeral containers for production debugging
- Scaling logic: function invocation queue depth drives scaling

### Shared K8s 1.34 Features Used by Both Platforms
- Dynamic Resource Allocation for fine-grained GPU management
- cgroups v2 for hierarchical resource limits
- Scheduler Framework improvements
- Custom Metrics API integration
- Ephemeral Containers for troubleshooting

### Key Differences
Replicate emphasizes model-centric deployment (per model version), while Modal focuses on function-centric architecture (individual Python functions as deployments).

### Challenges Addressed
- GPU driver compatibility (525+ required)
- Cold start latency through pod pre-warming
- Cost management via resource quotas and node auto-scaling
