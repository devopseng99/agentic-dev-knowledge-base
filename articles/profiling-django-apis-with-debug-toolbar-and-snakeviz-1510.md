---
title: "Profiling Django APIs with Debug Toolbar and snakeviz"
url: "https://dev.to/jangwanankit/profiling-django-apis-with-debug-toolbar-and-snakeviz-1510"
author: "Ankit Jangwan"
category: "code-optimization"
---
# Profiling Django APIs with Debug Toolbar and snakeviz
**Author:** Ankit Jangwan  **Published:** April 2, 2026

## Overview
How to use two free, open-source tools to identify and fix performance bottlenecks in Django applications without paid monitoring services. A production system handling 10,000+ scheduled messages daily went from 187 queries/420ms to 2 queries/12ms, and from 178ms to 1.2ms after adding a partial index.

## Key Concepts

### Complete Workflow
1. Debug Toolbar SQL panel - Identify N+1 queries first
2. Debug Toolbar Profiling panel - Find CPU-bound bottlenecks
3. cProfile + snakeviz - Deep analysis for non-web code
4. EXPLAIN ANALYZE - Optimize specific slow queries
5. Verify fixes with measurements

## Key Code Examples

```python
# Install and configure Django Debug Toolbar
pip install django-debug-toolbar

# settings.py
INSTALLED_APPS = ['debug_toolbar', ...]
MIDDLEWARE = ['debug_toolbar.middleware.DebugToolbarMiddleware', ...]
DEBUG_TOOLBAR_PANELS = [
    'debug_toolbar.panels.sql.SQLPanel',
    'debug_toolbar.panels.profiling.ProfilingPanel',
    'debug_toolbar.panels.timer.TimerPanel',
    'debug_toolbar.panels.cache.CachePanel',
]
INTERNAL_IPS = ['127.0.0.1']
# Note: On Python 3.12+, profiling panel needs single-threaded dev server:
# python manage.py runserver --nothreading
```

```python
# N+1 Fix with select_related
# Before: 187 queries in 420ms
messages = Message.objects.filter(status='pending')

# After: 2 queries in 12ms
messages = Message.objects.filter(status='pending').select_related('user')
```

```python
# cProfile + snakeviz for isolated profiling
import cProfile
from django.test import RequestFactory

factory = RequestFactory()
request = factory.get('/api/messages/?status=pending')

profiler = cProfile.Profile()
profiler.enable()
response = message_list_view(request)
profiler.disable()
profiler.dump_stats('message_list.prof')

# Command-line profiling
# python -m cProfile -o output.prof manage.py some_management_command
```

```bash
# snakeviz visualization
pip install snakeviz
snakeviz message_list.prof
```

```sql
-- EXPLAIN ANALYZE to find slow queries
EXPLAIN ANALYZE
SELECT m.id, m.body, m.send_at, u.email
FROM messages m
JOIN users u ON m.user_id = u.id
WHERE m.status = 'pending'
  AND m.send_at > '2026-03-01'
ORDER BY m.send_at ASC
LIMIT 50;
-- Result: Seq Scan on 500,000 rows returning 1,247 (178ms)
```

```sql
-- Add partial index - reduces 178ms to 1.2ms
CREATE INDEX idx_messages_pending ON messages(send_at)
WHERE status = 'pending';
```

```python
# Django migration for partial index
class Migration(migrations.Migration):
    operations = [
        migrations.AddIndex(
            model_name='message',
            index=models.Index(
                fields=['send_at'],
                condition=models.Q(status='pending'),
                name='idx_messages_pending',
            ),
        ),
    ]
```

```python
# Celery Task Profiling
import cProfile

@shared_task
def send_message(message_id):
    pass  # task code

cProfile.run('send_message(42)', 'send_task.prof')
# Fix: switch to .only('id', 'channel', 'recipient', 'body') - 60% DB time reduction
```

## Tools Reference

| Tool | Purpose | Use Case |
|------|---------|----------|
| Debug Toolbar (SQL) | Query analysis per request | First check on slow endpoints |
| Debug Toolbar (Profiling) | Call tree with timing | When query count is fine |
| cProfile + snakeviz | Python flame graphs | Management commands, tasks |
| EXPLAIN ANALYZE | Database execution plans | Specific query bottlenecks |

## Reading cProfile Output
- ncalls: Function invocation count
- tottime: Time excluding sub-calls
- cumtime: Total time with sub-calls
- percall: Average time per invocation
