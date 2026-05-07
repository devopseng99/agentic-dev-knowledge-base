---
title: "Building an Async Rust Runtime on io_uring: 7.5ms vs Tokio's 14.9ms"
url: "https://dev.to/sumant1122/building-an-async-rust-runtime-on-iouring-75ms-vs-tokios-149ms-2f64"
author: "Sumant"
category: "code-optimization"
---
# Building an Async Rust Runtime on io_uring: 7.5ms vs Tokio's 14.9ms
**Author:** Sumant  **Published:** May 5, 2026

## Overview
Documents the creation of RingCore, a minimal async runtime built directly on Linux's io_uring interface. Explores what happens when Rust code suspends via .await, demonstrating that direct kernel-level I/O can outperform Tokio in certain scenarios.

## Key Concepts

### io_uring: The Kernel Innovation
Introduced in Linux 5.1, replaces expensive context-switching with a shared-memory ring buffer:
- Submission Queue (SQ): Application writes I/O requests
- Completion Queue (CQ): Kernel writes results back
- Multiple I/O operations batched into a single system call

### The Future/Waker Model
When .await suspends code, Rust's Future trait returns Poll::Pending along with a Waker (a callback stored in a map). The executor retrieves this Waker when the kernel signals completion and invokes it to resume execution.

### Four Architecture Layers

**Layer 1: Kernel Communication** - Raw syscalls via libc::syscall() for SYS_IO_URING_SETUP and SYS_IO_URING_ENTER, with mmap to access kernel ring buffers.

**Layer 2: Futures Wrapper** - Each io_uring operation becomes a Future. First call: submits SQE, stores Waker in map, returns Pending. Subsequent calls: check if CQE arrived.

**Layer 3: Executor** - Classic event loop: polls ready tasks, submits SQEs, harvests CQEs, wakes corresponding futures.

**Layer 4: User API** - High-level TcpListener and TcpStream with async methods.

## Key Code Examples

```rust
// Layer 1: Raw kernel communication
let ring_fd = unsafe {
    libc::syscall(
        libc::SYS_io_uring_setup,
        QUEUE_DEPTH as libc::c_long,
        &params as *const _ as libc::c_long,
    )
} as i32;

let sq_ptr = unsafe {
    libc::mmap(
        std::ptr::null_mut(),
        sq_size,
        libc::PROT_READ | libc::PROT_WRITE,
        libc::MAP_SHARED | libc::MAP_POPULATE,
        ring_fd,
        libc::IORING_OFF_SQ_RING as libc::off_t,
    )
};
```

```rust
// Layer 2: Future implementation
impl Future for Op {
    type Output = i32;

    fn poll(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        if !self.submitted {
            RING.with(|ring| {
                let mut ring = ring.borrow_mut();
                ring.push_sqe(self.sqe);
            });
            WAKER_MAP.with(|map| {
                map.borrow_mut().insert(self.user_data, cx.waker().clone());
            });
            self.submitted = true;
            return Poll::Pending;
        }

        match self.result.take() {
            Some(res) => Poll::Ready(res),
            None => {
                WAKER_MAP.with(|map| {
                    map.borrow_mut().insert(self.user_data, cx.waker().clone());
                });
                Poll::Pending
            }
        }
    }
}
```

```rust
// Layer 3: Executor event loop
pub fn run(&mut self) {
    loop {
        while let Some(task) = self.ready_queue.pop_front() {
            let waker = task.waker();
            let mut cx = Context::from_waker(&waker);
            match task.future.borrow_mut().as_mut().poll(&mut cx) {
                Poll::Ready(_) => { /* Task complete */ }
                Poll::Pending => { /* Task waiting */ }
            }
        }

        let completed = self.ring.submit_and_wait(1);

        for cqe in completed {
            WAKER_MAP.with(|map| {
                if let Some(waker) = map.borrow_mut().remove(&cqe.user_data) {
                    store_result(cqe.user_data, cqe.res);
                    waker.wake();
                }
            });
        }

        if self.all_tasks_complete() { break; }
    }
}
```

```rust
// Layer 4: User-friendly API
impl TcpStream {
    pub async fn read(&self, buf: &mut [u8]) -> io::Result<usize> {
        let result = Op::read(self.fd, buf).await;
        if result < 0 {
            Err(io::Error::from_raw_os_error(-result))
        } else {
            Ok(result as usize)
        }
    }
}
```

## Benchmark Results

### File I/O (100MB read)
| Runtime | Real Time | System Time |
|---------|-----------|-------------|
| std::fs | 0.057s | 0.016s |
| Tokio | 0.461s | 0.376s |
| RingCore | 0.088s | 0.036s |

Tokio is 5x slower because it uses thread pools for blocking file I/O rather than true async operations.

### Network (sequential requests)
| Test | std | Tokio | RingCore |
|------|-----|-------|---------|
| 100 sequential | 12.8ms | 14.9ms | 7.5ms |
| 1,000 concurrent | 48.3ms | 1,080ms | 67.9ms |

Requirements: Linux 5.10+, x86_64. Dependencies: libc and std only.
