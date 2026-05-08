# dev.to Dedup Store — SurrealDB on K8s

Persistent dedup layer for the agentic-dev-knowledge-base collection pipeline.
Replaces the ephemeral `/tmp/existing_articles.txt` flat file with a Rust-native
database hosted in the cluster.

## Why SurrealDB?

| Property | Flat file `/tmp` | SurrealDB |
|----------|-----------------|-----------|
| Survives session close | ❌ lost | ✅ persistent |
| Survives pod restart | ❌ lost | ✅ on local PV |
| Concurrent writes from agents | ❌ race conditions | ✅ atomic INSERT IGNORE |
| Query by category/date | ❌ grep only | ✅ full SurrealQL |
| Stores metadata (title/url/cat) | ❌ slug only | ✅ full record |
| Dedup check latency | ~0ms (local) | ~1ms (cluster) |
| Written in Rust | — | ✅ yes |

## Architecture

```
Collection agents (20 parallel)
        │
        │ HTTP POST /sql
        ▼
SurrealDB pod (devto-dedup ns)
  surrealdb/surrealdb:v2.1.4
  RocksDB backend → /data/devto.db
        │
        ▼
PVC → PV → /opt/k8s-pers/vol1/surrealdb-devto (mgplcb05)
```

## Quick Start

### 1. Deploy
```bash
cd devto-dedup-db
chmod +x scripts/setup.sh
./scripts/setup.sh
```

This will:
- SSH to mgplcb05 to create the node directory
- Apply all K8s manifests
- Port-forward and seed all 3,215 existing slugs
- Verify count

### 2. Verify
```bash
kubectl get pods -n devto-dedup
kubectl logs -n devto-dedup deploy/surrealdb

# Check count via port-forward
kubectl port-forward svc/surrealdb 8000:8000 -n devto-dedup &
curl -s -X POST http://localhost:8000/sql \
  -u devto:changeme-devto-dedup-2026 \
  -H "surreal-ns: devto" -H "surreal-db: articles" \
  -H "Content-Type: text/plain" \
  -d "SELECT count() FROM articles GROUP ALL;"
```

### 3. Test dedup check
```bash
python3 scripts/dedup_client.py exists "my-article-slug-1abc"
# Returns: EXISTS or NEW, exit code 0 or 1
```

## API Reference

SurrealDB exposes a REST API on port 8000.

### Check if slug exists
```bash
curl -X POST http://surrealdb.devto-dedup.svc.cluster.local:8000/sql \
  -u devto:PASSWORD \
  -H "surreal-ns: devto" -H "surreal-db: articles" \
  -H "Content-Type: text/plain" \
  -d "SELECT slug FROM articles WHERE slug = 'my-slug-1abc' LIMIT 1;"
# Returns: [{"result": [{"slug":"my-slug-1abc"}]}] if exists
# Returns: [{"result": []}] if new
```

### Register new slug
```bash
curl -X POST http://surrealdb.devto-dedup.svc.cluster.local:8000/sql \
  -u devto:PASSWORD \
  -H "surreal-ns: devto" -H "surreal-db: articles" \
  -H "Content-Type: text/plain" \
  -d "INSERT IGNORE INTO articles { slug: 'my-slug', title: 'Title', url: 'https://...', category: 'agent-frameworks' };"
```

### Bulk check (20 slugs in one query)
```bash
curl -X POST .../sql -d "SELECT slug FROM articles WHERE slug IN ['slug-a','slug-b','slug-c'];"
```

### Stats by category
```bash
curl -X POST .../sql -d "SELECT category, count() as n FROM articles GROUP BY category ORDER BY n DESC;"
```

## Python Client (for collection agents)

```python
from dedup_client import DedupClient

db = DedupClient()  # auto-detects SurrealDB or falls back to /tmp file

# Single check
if db.exists("my-article-slug"):
    continue  # skip

# Register after collecting
db.register("my-article-slug", title="...", url="https://...", category="agent-frameworks")

# Bulk check (batch of candidates)
results = db.bulk_exists(["slug-a", "slug-b", "slug-c"])
new_slugs = [s for s, exists in results.items() if not exists]

# Stats
print(f"Total: {db.count()}")
print(db.stats())
```

**Fallback behavior:** if SurrealDB is unreachable, automatically falls back to
`/tmp/existing_articles.txt` — collection agents never fail due to DB outage.

## Manifest Files

| File | Purpose |
|------|---------|
| `namespace.yaml` | `devto-dedup` namespace |
| `secret.yaml` | SurrealDB credentials |
| `pv.yaml` | 5Gi PV on mgplcb05 + PVC |
| `deployment.yaml` | SurrealDB Deployment + ClusterIP Service |
| `seed-job.yaml` | One-time K8s Job for schema creation |
| `scripts/setup.sh` | Full deploy + seed script |
| `scripts/dedup_client.py` | Python client with fallback |
| `scripts/check-slug.sh` | Bash one-liner check |
| `scripts/register-slug.sh` | Bash one-liner register |

## Resource Usage

SurrealDB with 3,215–50,000 records and RocksDB backend:
- **Memory:** ~128MB idle, ~256MB under load (limit: 512MB)
- **CPU:** ~50m idle, ~200m during bulk seed (limit: 500m)
- **Disk:** ~50MB for 50K records with metadata (5Gi PV is very generous)
- **mgplcb05 impact:** negligible (node at 29% memory currently)

## Upgrading SurrealDB

```bash
# Update image tag in deployment.yaml then:
kubectl set image deployment/surrealdb surrealdb=surrealdb/surrealdb:v2.2.0 -n devto-dedup
kubectl rollout status deployment/surrealdb -n devto-dedup
```

## Future: Semantic Dedup (Optional)

For catching near-duplicate content (same article re-posted with different slug):

Add **Qdrant** (also Rust-based) alongside SurrealDB:
```
SurrealDB → exact slug dedup (current)
Qdrant    → embedding similarity dedup (future)
```

When collecting an article, embed its title+overview and check cosine similarity
against existing embeddings. Threshold ~0.92 = likely duplicate.

Deploy: `kubectl apply -f qdrant-addon.yaml` (to be created when needed).
