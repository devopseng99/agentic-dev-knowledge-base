---
title: "Profiling Flask application to improve performance"
url: "https://dev.to/heyaliona/profiling-flask-application-to-improve-performance-4970"
author: "aliona matveeva"
category: "code-optimization"
---
# Profiling Flask application to improve performance
**Author:** aliona matveeva  **Published:** February 28, 2021

## Overview
A Flask application had severe performance issues with requests taking 3-10 seconds. Profiling revealed the real bottleneck was service-database interaction, not the marshmallow serialization library that was initially blamed. Key lesson: profile before optimizing, not after.

## Key Concepts

### Code Profilers
Tools for dynamic code analysis that identify performance bottlenecks by gathering metrics on program execution.

### Initial Misconception
The author initially blamed marshmallow serialization and switched to toasted-marshmallow, only to have performance worsen: 3 seconds -> 6 seconds. Profiling revealed the real problem was database interaction.

### Available Tools

| Tool | Description |
|------|-------------|
| werkzeug profiler | Built-in Flask integration, two-line setup |
| flask-profiler | Web interface with filters |
| cProfile | Python standard library profiler |
| snakeviz | Browser-based visualization |
| RunSnakeRun | Alternative visualization |
| gprof2dot | Generates call graphs |

## Key Code Examples

```python
# Werkzeug Built-in Profiler - two-line setup
from werkzeug.middleware.profiler import ProfilerMiddleware
app = ProfilerMiddleware(app)

# With options (profile to file directory)
app = ProfilerMiddleware(
    app,
    profile_dir='/tmp/profiles',
    restrictions=[0.1]  # only top 10% of functions
)
```

```bash
# snakeviz - browser-based visualization
pip install snakeviz
snakeviz profile_dir/

# Drill down into execution time distribution across function calls
```

## Key Takeaway
"Automatic profilers are not perfect...but at least with profilers you can detect the weak area which in most cases is more than enough."

Profile first, optimize second. The bottleneck is rarely where you think it is.
