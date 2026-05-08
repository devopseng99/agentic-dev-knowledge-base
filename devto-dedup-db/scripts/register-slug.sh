#!/bin/bash
# Usage: ./register-slug.sh <slug> <title> <url> <category>
# Inserts a new slug into SurrealDB (IGNORE if already exists)

SLUG="${1:?}"
TITLE="${2:-}"
URL="${3:-}"
CATEGORY="${4:-}"

SURREAL_URL="${SURREAL_URL:-http://surrealdb.devto-dedup.svc.cluster.local:8000}"
SURREAL_USER="${SURREAL_USER:-devto}"
SURREAL_PASS="${SURREAL_PASS:-changeme-devto-dedup-2026}"

# Escape single quotes
TITLE_ESC="${TITLE//\'/\\\'}"

curl -sf -X POST "$SURREAL_URL/sql" \
  -u "$SURREAL_USER:$SURREAL_PASS" \
  -H "surreal-ns: devto" \
  -H "surreal-db: articles" \
  -H "Content-Type: text/plain" \
  -d "INSERT IGNORE INTO articles { slug: '$SLUG', title: '$TITLE_ESC', url: '$URL', category: '$CATEGORY' };" \
  > /dev/null 2>&1
