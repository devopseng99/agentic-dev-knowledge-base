#!/bin/bash
# ============================================================
# Setup script: Deploy SurrealDB dedup store to K8s + seed it
# ============================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
MANIFESTS_DIR="$(dirname "$SCRIPT_DIR")"
ARTICLES_DIR="/var/lib/rancher/ansible/db/rd-main/rd-fine-10000-devto/articles"

SURREAL_URL="http://localhost:8000"  # via kubectl port-forward
SURREAL_NS="devto"
SURREAL_DB="articles"
SURREAL_USER="${SURREAL_USER:-devto}"
SURREAL_PASS="${SURREAL_PASS:-changeme-devto-dedup-2026}"

echo "=== Step 1: Create node directory ==="
ssh -i ~/.ssh/id_rsa_devops_ssh hr1@192.168.29.147 \
  "sudo mkdir -p /opt/k8s-pers/vol1/surrealdb-devto && sudo chown 1000:1000 /opt/k8s-pers/vol1/surrealdb-devto"

echo "=== Step 2: Apply K8s manifests ==="
kubectl apply -f "$MANIFESTS_DIR/namespace.yaml"
kubectl apply -f "$MANIFESTS_DIR/secret.yaml"
kubectl apply -f "$MANIFESTS_DIR/pv.yaml"
kubectl apply -f "$MANIFESTS_DIR/deployment.yaml"

echo "=== Step 3: Wait for SurrealDB pod ==="
kubectl rollout status deployment/surrealdb -n devto-dedup --timeout=120s

echo "=== Step 4: Port-forward for seeding ==="
kubectl port-forward svc/surrealdb 8000:8000 -n devto-dedup &
PF_PID=$!
sleep 3

echo "=== Step 5: Create schema ==="
curl -sf -X POST "$SURREAL_URL/sql" \
  -u "$SURREAL_USER:$SURREAL_PASS" \
  -H "surreal-ns: $SURREAL_NS" \
  -H "surreal-db: $SURREAL_DB" \
  -H "Content-Type: text/plain" \
  -d "
    DEFINE TABLE articles SCHEMAFULL;
    DEFINE FIELD slug ON articles TYPE string;
    DEFINE FIELD title ON articles TYPE string;
    DEFINE FIELD url ON articles TYPE string;
    DEFINE FIELD category ON articles TYPE string;
    DEFINE FIELD collected_at ON articles TYPE datetime VALUE time::now() READONLY;
    -- No separate unique index needed: slug IS the record ID (articles:⟨slug⟩)
    -- record::exists(r'articles:slug') does O(1) ID lookup
  "
echo "Schema created."

echo "=== Step 6: Bulk seed existing articles ==="
count=0
batch=""
batch_size=100

for f in "$ARTICLES_DIR"/*.md; do
  slug=$(basename "$f" .md)
  title=$(grep '^title:' "$f" 2>/dev/null | head -1 | sed 's/^title: *"//' | sed 's/"$//' | sed "s/'/\\\\'/g")
  url=$(grep '^url:' "$f" 2>/dev/null | head -1 | sed 's/^url: *"//' | sed 's/"$//')
  category=$(grep '^category:' "$f" 2>/dev/null | head -1 | sed 's/^category: *"//' | sed 's/"$//')

  batch="${batch} INSERT IGNORE INTO articles { id: articles:⟨${slug}⟩, slug: '${slug}', title: '${title}', url: '${url}', category: '${category}' };"
  count=$((count + 1))

  if [ $((count % batch_size)) -eq 0 ]; then
    curl -sf -X POST "$SURREAL_URL/sql" \
      -u "$SURREAL_USER:$SURREAL_PASS" \
      -H "surreal-ns: $SURREAL_NS" \
      -H "surreal-db: $SURREAL_DB" \
      -H "Content-Type: text/plain" \
      -d "$batch" > /dev/null
    echo "  Seeded $count articles..."
    batch=""
  fi
done

# Final batch
if [ -n "$batch" ]; then
  curl -sf -X POST "$SURREAL_URL/sql" \
    -u "$SURREAL_USER:$SURREAL_PASS" \
    -H "surreal-ns: $SURREAL_NS" \
    -H "surreal-db: $SURREAL_DB" \
    -H "Content-Type: text/plain" \
    -d "$batch" > /dev/null
fi

echo "Seeded $count articles total."

# Verify
total=$(curl -sf -X POST "$SURREAL_URL/sql" \
  -u "$SURREAL_USER:$SURREAL_PASS" \
  -H "surreal-ns: $SURREAL_NS" \
  -H "surreal-db: $SURREAL_DB" \
  -H "Content-Type: text/plain" \
  -d "SELECT count() FROM articles GROUP ALL;" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d[0]['result'][0]['count'])" 2>/dev/null || echo "?")

echo "=== Done: $total records in SurrealDB ==="
kill $PF_PID 2>/dev/null || true
