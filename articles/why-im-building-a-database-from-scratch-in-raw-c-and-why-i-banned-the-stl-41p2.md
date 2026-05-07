---
title: "Why I'm Building a Database From Scratch in Raw C++ (And Why I Banned the STL)"
url: "https://dev.to/hari5616/why-im-building-a-database-from-scratch-in-raw-c-and-why-i-banned-the-stl-41p2"
author: "Hari5616"
category: "code-optimization"
---
# Why I'm Building a Database From Scratch in Raw C++ (And Why I Banned the STL)
**Author:** Hari5616  **Published:** May 2, 2026

## Overview
Documents building a custom database engine in raw C++ without STL containers, driven by performance requirements that STL abstractions couldn't meet. Covers the specific performance problems with std::vector, std::unordered_map, and std::string in a database context, and the custom alternatives.

## Key Concepts

### Why Ban the STL?

**std::vector grows by 2x** - For a page buffer pool managing fixed-size 4KB pages, doubling wastes memory and causes expensive copies. A custom circular buffer with power-of-2 size avoids this.

**std::unordered_map has poor cache behavior** - Each bucket is a linked list. For a hot buffer pool index accessed millions of times per second, pointer chasing kills CPU cache efficiency. A flat open-addressing hash map with linear probing is 3-5x faster.

**std::string has SSO overhead** - The Small String Optimization (SSO) wastes 24 bytes per string for database column names. A custom string_view + string pool uses shared storage.

**Allocator overhead** - STL containers call malloc/free per node. A custom arena allocator for a query's lifetime allocates once and frees at query end.

### The Trade-Offs
This approach is justified for database internals. For application code, STL is almost always the right choice. Profile before custom implementation.

## Key Code Examples

```cpp
// Custom fixed-size arena allocator for query lifetime
class QueryArena {
    static constexpr size_t BLOCK_SIZE = 1 << 20;  // 1MB blocks

    struct Block {
        std::byte* data;
        size_t used;
        Block* next;
    };

    Block* current_;

public:
    explicit QueryArena() {
        current_ = allocate_block();
    }

    ~QueryArena() {
        // Free all blocks at once - no per-object free
        while (current_) {
            Block* next = current_->next;
            ::free(current_->data);
            ::free(current_);
            current_ = next;
        }
    }

    template<typename T>
    T* alloc(size_t count = 1) {
        size_t bytes = sizeof(T) * count;
        size_t aligned = (bytes + 7) & ~7;  // 8-byte alignment

        if (current_->used + aligned > BLOCK_SIZE) {
            Block* new_block = allocate_block();
            new_block->next = current_;
            current_ = new_block;
        }

        T* ptr = reinterpret_cast<T*>(current_->data + current_->used);
        current_->used += aligned;
        return ptr;
    }
};
```

```cpp
// Flat hash map with open addressing - better cache locality than std::unordered_map
template<typename K, typename V, typename Hash = std::hash<K>>
class FlatHashMap {
    struct Slot {
        K key;
        V value;
        bool occupied = false;
    };

    std::unique_ptr<Slot[]> slots_;
    size_t capacity_;
    size_t size_;

public:
    explicit FlatHashMap(size_t initial_capacity = 64)
        : capacity_(next_power_of_two(initial_capacity))
        , size_(0) {
        slots_ = std::make_unique<Slot[]>(capacity_);
    }

    V* find(const K& key) {
        size_t h = Hash{}(key) & (capacity_ - 1);
        // Linear probing - stays in cache
        for (size_t i = 0; i < capacity_; ++i) {
            size_t idx = (h + i) & (capacity_ - 1);
            if (!slots_[idx].occupied) return nullptr;
            if (slots_[idx].key == key) return &slots_[idx].value;
        }
        return nullptr;
    }
    // ... insert, erase, resize
};
```

```cpp
// Custom circular buffer for fixed-size buffer pool
template<typename T, size_t Capacity>
class CircularBuffer {
    static_assert((Capacity & (Capacity - 1)) == 0, "Capacity must be power of 2");

    T data_[Capacity];
    uint32_t head_ = 0;
    uint32_t tail_ = 0;
    uint32_t size_ = 0;

public:
    bool push(T&& item) {
        if (size_ == Capacity) return false;
        data_[tail_ & (Capacity - 1)] = std::move(item);
        ++tail_;
        ++size_;
        return true;
    }

    T* pop() {
        if (size_ == 0) return nullptr;
        T* item = &data_[head_ & (Capacity - 1)];
        ++head_;
        --size_;
        return item;
    }
};
```

## Performance Results
Buffer pool lookup with 1M operations/second:
- std::unordered_map: 180ns per operation (pointer chasing)
- FlatHashMap (open addressing): 35ns per operation (cache friendly)
- Speedup: 5.1x

Query temporary allocations (1000 queries, 10MB each):
- malloc/free per node: 45ms total allocation overhead
- Arena allocator: 2ms total (1 malloc at start, 1 free at end)
- Speedup: 22.5x
