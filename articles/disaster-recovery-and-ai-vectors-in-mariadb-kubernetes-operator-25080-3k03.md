---
title: "Disaster Recovery and AI Vectors in MariaDB Kubernetes Operator 25.08.0"
url: "https://dev.to/alejandro_du/disaster-recovery-and-ai-vectors-in-mariadb-kubernetes-operator-25080-3k03"
author: "Alejandro Duarte"
category: "k8s-native-agents"
---

# Disaster Recovery and AI Vectors in MariaDB Kubernetes Operator 25.08.0
**Author:** Alejandro Duarte
**Published:** August 7, 2025

## Overview
MariaDB Kubernetes Operator v25.08.0 adds physical backups via PhysicalBackup CRD and VolumeSnapshots, plus VECTOR data type support in MariaDB 11.8 for AI/RAG applications. Includes new mariadb-cluster Helm chart.

## Key Concepts
- PhysicalBackup Custom Resources for efficient large dataset restoration
- Kubernetes-native VolumeSnapshots via CSI drivers
- VECTOR data type for high-dimensional vectors (RAG, similarity search)
- LangChain and Spring AI integrations for MariaDB as vector store
- mariadb-cluster Helm chart for streamlined provisioning
