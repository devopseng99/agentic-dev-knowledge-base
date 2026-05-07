---
title: "I built a game similarity engine with Django and PostgreSQL"
url: "https://dev.to/alexeyzam15/i-built-a-game-similarity-engine-with-django-and-postgresql-3d5m"
author: "alexeyzam15"
category: "gaming-agents"
---
# I built a game similarity engine with Django and PostgreSQL
**Author:** Alexey Zamaraev  **Published:** April 28, 2026

## Overview
Created GamesPeek, a recommendation system that helps players find games matching their preferences by analyzing 45,000+ titles across weighted similarity criteria. Rather than relying on popularity metrics, the engine delivers personalized suggestions based on specific game attributes.

## Key Concepts
- **Weighted Similarity Algorithm**: Genres (30%), Keywords (25%), Themes (20%), Developers (10%), Player perspectives (8%), Game modes (7%)
- **Materialized Vectors in PostgreSQL**: Precomputed similarity vectors for optimized query performance at scale
- **IGDB API**: Game information data source providing metadata for 45,000+ titles
- **Redis Caching**: Caches similarity computations to reduce database load on repeated queries
- **Side-by-side Comparison**: Feature allowing direct comparison of two games' attributes
- **Advanced Filtering**: Platform, genre, release year, rating filters on top of similarity results

## Tech Stack
- Backend: Python + Django
- Database: PostgreSQL with materialized vectors
- Cache: Redis
- Data Source: IGDB API
- Frontend: Bootstrap 5

## GitHub Repository
https://github.com/AlexeyZam15/GamesPeek_site (MIT license)
- Live Application: https://gamespeek.dpdns.org
