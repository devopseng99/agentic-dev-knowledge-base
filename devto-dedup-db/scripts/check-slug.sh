#!/bin/bash
# Usage: ./check-slug.sh <slug>
# Returns: 0 = exists (skip), 1 = new (collect it)
# Requires: SURREAL_URL, SURREAL_USER, SURREAL_PASS env vars
#   OR uses kubectl port-forward if SURREAL_URL not set

SLUG="${1:?Usage: check-slug.sh <slug>}"
SURREAL_URL="${SURREAL_URL:-http://surrealdb.devto-dedup.svc.cluster.local:8000}"
SURREAL_USER="${SURREAL_USER:-devto}"
SURREAL_PASS="${SURREAL_PASS:-changeme-devto-dedup-2026}"

result=$(curl -sf -X POST "$SURREAL_URL/sql" \
  -u "$SURREAL_USER:$SURREAL_PASS" \
  -H "surreal-ns: devto" \
  -H "surreal-db: articles" \
  -H "Content-Type: text/plain" \
  -d "SELECT slug FROM articles WHERE slug = '$SLUG' LIMIT 1;" \
  2>/dev/null | python3 -c "
import sys, json
d = json.load(sys.stdin)
rows = d[0].get('result', [])
print('EXISTS' if rows else 'NEW')
" 2>/dev/null)

if [ "$result" = "EXISTS" ]; then
  exit 0   # already collected
else
  exit 1   # new, go get it
fi
