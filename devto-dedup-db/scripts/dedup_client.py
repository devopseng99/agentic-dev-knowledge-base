"""
dedup_client.py — SurrealDB dedup client for dev.to article collection agents.

Usage in collection agents:
  from dedup_client import DedupClient

  db = DedupClient()

  if db.exists("my-article-slug-1abc"):
      print("skip")
  else:
      # collect article, write file
      db.register("my-article-slug-1abc", title="...", url="...", category="...")

Falls back to /tmp/existing_articles.txt if SurrealDB is unreachable.
"""

import os
import requests
import json
from pathlib import Path

SURREAL_URL  = os.environ.get("SURREAL_URL",  "http://surrealdb.devto-dedup.svc.cluster.local:8000")
SURREAL_USER = os.environ.get("SURREAL_USER", "devto")
SURREAL_PASS = os.environ.get("SURREAL_PASS", "changeme-devto-dedup-2026")
SURREAL_NS   = "devto"
SURREAL_DB   = "articles"
FALLBACK_FILE = Path("/tmp/existing_articles.txt")


class DedupClient:
    """
    Checks and registers article slugs against SurrealDB.
    Automatically falls back to flat-file mode if SurrealDB is unreachable.
    """

    def __init__(self):
        self._use_surreal = self._ping()
        if not self._use_surreal:
            print(f"[dedup] SurrealDB unreachable at {SURREAL_URL}, using fallback file")
            self._fallback = self._load_fallback()
        else:
            print(f"[dedup] Connected to SurrealDB at {SURREAL_URL}")
            self._fallback = None

    def _ping(self) -> bool:
        try:
            r = requests.get(f"{SURREAL_URL}/health", timeout=3)
            return r.status_code == 200
        except Exception:
            return False

    def _load_fallback(self) -> set:
        if FALLBACK_FILE.exists():
            return set(FALLBACK_FILE.read_text().splitlines())
        # Build from articles directory
        articles_dir = Path("/var/lib/rancher/ansible/db/rd-main/rd-fine-10000-devto/articles")
        if articles_dir.exists():
            slugs = {f.stem for f in articles_dir.glob("*.md")}
            FALLBACK_FILE.write_text("\n".join(sorted(slugs)))
            return slugs
        return set()

    def _sql(self, query: str) -> list:
        r = requests.post(
            f"{SURREAL_URL}/sql",
            auth=(SURREAL_USER, SURREAL_PASS),
            headers={
                "surreal-ns": SURREAL_NS,
                "surreal-db": SURREAL_DB,
                "Content-Type": "text/plain",
            },
            data=query,
            timeout=5,
        )
        r.raise_for_status()
        return r.json()

    def exists(self, slug: str) -> bool:
        """Returns True if slug already collected."""
        if not self._use_surreal:
            return slug in self._fallback

        slug_safe = slug.replace("'", "\\'")
        try:
            # record::exists() is faster than SELECT — single index lookup, no row scan
            result = self._sql(
                f"RETURN record::exists(r'articles:{slug_safe}');"
            )
            return bool(result[0].get("result"))
        except Exception:
            # On transient error, be conservative: assume new
            return False

    def register(self, slug: str, title: str = "", url: str = "", category: str = "") -> None:
        """Mark a slug as collected (INSERT IGNORE = idempotent)."""
        if not self._use_surreal:
            self._fallback.add(slug)
            with FALLBACK_FILE.open("a") as f:
                f.write(slug + "\n")
            return

        slug_safe    = slug.replace("'", "\\'")
        title_safe   = title.replace("'", "\\'")
        url_safe     = url.replace("'", "\\'")
        cat_safe     = category.replace("'", "\\'")

        try:
            # Use slug as record ID → enables record::exists(r'articles:slug') fast-path
            self._sql(
                f"INSERT IGNORE INTO articles {{ "
                f"id: articles:⟨{slug_safe}⟩, "
                f"slug: '{slug_safe}', "
                f"title: '{title_safe}', "
                f"url: '{url_safe}', "
                f"category: '{cat_safe}' }};"
            )
        except Exception as e:
            print(f"[dedup] register failed for {slug}: {e}")

    def bulk_exists(self, slugs: list[str]) -> dict[str, bool]:
        """Check multiple slugs in one query. Returns {slug: bool}."""
        if not self._use_surreal:
            return {s: s in self._fallback for s in slugs}

        slug_list = ", ".join(f"'{s.replace(chr(39), chr(92)+chr(39))}'" for s in slugs)
        try:
            result = self._sql(
                f"SELECT slug FROM articles WHERE slug IN [{slug_list}];"
            )
            found = {row["slug"] for row in result[0].get("result", [])}
            return {s: s in found for s in slugs}
        except Exception:
            return {s: False for s in slugs}

    def count(self) -> int:
        """Total articles registered."""
        if not self._use_surreal:
            return len(self._fallback)
        try:
            result = self._sql("SELECT count() FROM articles GROUP ALL;")
            return result[0]["result"][0]["count"]
        except Exception:
            return -1

    def stats(self) -> dict:
        """Per-category counts."""
        if not self._use_surreal:
            return {}
        try:
            result = self._sql(
                "SELECT category, count() as n FROM articles GROUP BY category ORDER BY n DESC;"
            )
            return {row["category"]: row["n"] for row in result[0].get("result", [])}
        except Exception:
            return {}


# ── CLI helper ───────────────────────────────────────────────
if __name__ == "__main__":
    import sys
    db = DedupClient()

    if len(sys.argv) == 1:
        print(f"Total articles: {db.count()}")
        stats = db.stats()
        if stats:
            for cat, n in list(stats.items())[:10]:
                print(f"  {cat}: {n}")
    elif sys.argv[1] == "exists":
        slug = sys.argv[2]
        print("EXISTS" if db.exists(slug) else "NEW")
        sys.exit(0 if db.exists(slug) else 1)
    elif sys.argv[1] == "register":
        slug = sys.argv[2]
        title = sys.argv[3] if len(sys.argv) > 3 else ""
        url   = sys.argv[4] if len(sys.argv) > 4 else ""
        cat   = sys.argv[5] if len(sys.argv) > 5 else ""
        db.register(slug, title=title, url=url, category=cat)
        print(f"Registered: {slug}")
