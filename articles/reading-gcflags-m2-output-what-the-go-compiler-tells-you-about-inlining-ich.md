---
title: "Reading -gcflags='-m=2' Output: What the Go Compiler Tells You About Inlining"
url: "https://dev.to/gabrielanhaia/reading-gcflags-m2-output-what-the-go-compiler-tells-you-about-inlining-ich"
author: "Gabriel Anhaia"
category: "code-optimization"
---
# Reading -gcflags='-m=2' Output: What the Go Compiler Tells You About Inlining
**Author:** Gabriel Anhaia  **Published:** May 5, 2026

## Overview
Explains how to interpret Go compiler optimization output using the -gcflags='-m=2' flag. This tool reveals which functions the compiler inlines, which it rejects, and why - eliminating guesswork about performance decisions.

## Key Concepts

### What the Flag Does
- -gcflags='-m': prints compiler optimization decisions
- -m=2: adds verbosity with reasons for inlining acceptance/rejection, plus cost budget
- -m=3: adds devirtualization and PGO insights

### Output Line Types
1. `can inline X with cost N` - Function is small enough to inline; cost is AST node proxy (budget ~80)
2. `cannot inline X` - Function rejected; reasons include complexity or recursion
3. `inlining call to X` - Actual inlining at a specific call site

### Three Key Patterns

**Pattern 1: PGO Devirtualization**
Profile-guided optimization converts interface calls to direct calls when profiling shows concentration on one concrete type:
```
./main.go:18:9: devirtualizing w.Write to *main.counter
```

**Pattern 2: Closures and Escape Analysis**
Closures returned from functions escape to heap by default, but inlining the constructor can allow stack allocation.

**Pattern 3: -l=4 for Aggressive Inlining**
Raises cost budgets and enables mid-stack inlining, useful for tight libraries with function chains.

## Key Code Examples

```go
// Interface dispatch example - enable PGO to see devirtualization
type Writer interface {
    Write(p []byte) (int, error)
}

type counter struct{ n int }

func (c *counter) Write(p []byte) (int, error) {
    c.n += len(p)
    return len(p), nil
}

func emit(w Writer, msg string) {
    w.Write([]byte(msg))
}

func main() {
    var w Writer = &counter{}
    for i := 0; i < 1_000_000; i++ {
        emit(w, "x\n")
    }
}
```

```go
// Closure escape analysis example
package count

func makeAdder(x int) func(int) int {
    return func(y int) int {
        return x + y
    }
}

func sum(n int) int {
    add := makeAdder(10)
    total := 0
    for i := 0; i < n; i++ {
        total = add(i)
    }
    return total
}
// Output shows:
// ./count.go:3:6: can inline makeAdder with cost 10
// ./count.go:4:9: func literal escapes to heap
// ./count.go:3:14: moved to heap: x
// ./count.go:10:18: inlining call to makeAdder
```

```bash
# Basic usage
go build -gcflags='-m=2' ./pkg/...

# Aggressive inlining (may increase binary size)
go build -gcflags='-m=2 -l=4' ./...
```

## Workflow for Reading Output
1. Target smallest package containing the hot path
2. Build with -gcflags='-m=2' and pipe to file
3. Grep for `inlining call to` and expected hot functions
4. Search `cannot inline` for rejection reasons
5. Check `moved to heap` and `escapes to heap` for escape decisions
6. Verify `devirtualizing` lines if using PGO

## Key Takeaways
- Compiler explains itself; most developers never ask
- Stop guessing about wrapper functions, closures, and interface performance
- PGO devirtualization requires sufficient traffic concentration
- -m=2 output is stable across Go versions for year-to-year comparison
