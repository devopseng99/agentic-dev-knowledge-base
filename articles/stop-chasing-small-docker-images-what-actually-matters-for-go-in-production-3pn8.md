---
title: "Stop Chasing Small Docker Images: What Actually Matters for Go in Production"
url: "https://dev.to/chiman_jain/stop-chasing-small-docker-images-what-actually-matters-for-go-in-production-3pn8"
author: "Chiman Jain"
category: "code-optimization"
---
# Stop Chasing Small Docker Images: What Actually Matters for Go in Production
**Author:** Chiman Jain  **Published:** May 6, 2026

## Overview
The obsession with minimizing Docker image size for Go services misses more impactful optimizations. A 10MB vs 50MB image rarely matters for startup time or memory, but build reproducibility, layer caching, and binary size definitely do.

## Key Concepts

### What Actually Matters
1. **Build reproducibility** - Same input, same output. Deterministic builds prevent "works on my machine."
2. **Layer cache efficiency** - Order matters. Dependencies before source code.
3. **Binary compilation flags** - CGO_ENABLED=0, GOOS=linux, trimpath reduce binary size by 30-40%.
4. **Multi-stage builds** - Separate build environment from runtime.

### What Doesn't Matter as Much
- Alpine vs distroless vs scratch (5-15MB difference in a 30-100MB total image)
- Chasing sub-10MB images at the cost of debuggability
- Excluding ca-certificates (breaks HTTPS in scratch images)

## Key Code Examples

```dockerfile
# Good multi-stage Go Dockerfile
FROM golang:1.24-alpine AS builder

WORKDIR /app

# IMPORTANT: Copy go.mod/go.sum first for layer caching
# These change less frequently than source code
COPY go.mod go.sum ./
RUN go mod download  # Cached unless go.mod changes

# Now copy source - cache misses from here
COPY . .

# Compilation flags that actually matter:
# CGO_ENABLED=0 - no C library dependencies, portable binary
# -trimpath - removes build machine paths from binary (smaller + reproducible)
# -ldflags="-s -w" - strip debug info and DWARF (~30% smaller binary)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w" \
    -o /app/server ./cmd/server
```

```dockerfile
# Runtime stage
FROM gcr.io/distroless/static-debian12

# Copy binary only - no Go runtime needed (statically linked)
COPY --from=builder /app/server /server

# Copy only what you need
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8080
ENTRYPOINT ["/server"]
```

```bash
# Measure what matters
# Binary size before and after trimpath + ldflags
go build -o server_debug ./cmd/server
go build -trimpath -ldflags="-s -w" -o server_opt ./cmd/server
ls -lh server_debug server_opt
# Typical: 18MB vs 11MB for medium Go service

# Check what's in the binary (if debugging is needed)
go tool objdump -s main.main server_debug | head -50
```

```go
// Avoid init() complexity that bloats startup time
// BAD: Heavy initialization in init()
func init() {
    db = connectToDatabase()    // Blocks startup
    cache = loadEntireCache()   // Memory spike at startup
    config = parseAllConfigs()  // Error during init = crash
}

// GOOD: Lazy initialization
var dbOnce sync.Once
var db *sql.DB

func getDB() *sql.DB {
    dbOnce.Do(func() {
        db = connectToDatabase()
    })
    return db
}
```

## The Real Performance Wins for Go in Production
1. GOGC tuning: `GOGC=200` for GC-heavy services reduces GC frequency by 2x
2. GOMAXPROCS: Matches vCPU count (auto-detected in modern Go)
3. Connection pool sizing: db.SetMaxOpenConns(25), db.SetMaxIdleConns(5)
4. Buffered I/O: bufio.NewReader for high-frequency small reads

## Binary Size Comparison
| Build Flags | Binary Size | Includes Debug? |
|------------|-------------|----------------|
| Default | 18MB | Yes |
| -trimpath | 16MB | Yes |
| -ldflags="-s -w" | 12MB | No |
| Both | 11MB | No |
