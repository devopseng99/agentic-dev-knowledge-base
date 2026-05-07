---
title: "Building an 8-Layer Security Architecture for a $15 Hardware Device"
url: "https://dev.to/makepkg/building-an-8-layer-security-architecture-for-a-15-hardware-device-3p8k"
author: "makepkg"
category: "esp32-hardware"
---
# Building an 8-Layer Security Architecture for a $15 Hardware Device

**Author:** makepkg  **Published:** 2026-02-15

## Overview

A defense-in-depth security approach for SecureGen, a hardware TOTP authenticator and password manager built on an ESP32 microcontroller. Rather than relying on single security mechanisms, the author implements eight independent protective layers that each address different attack vectors — all on a $15 device with ~15KB memory overhead and ~150ms performance impact per critical operation.

## Key Concepts

1. **ECDH Key Exchange (Layer 1)**: Elliptic Curve Diffie-Hellman using P-256 curve generates unique session-specific encryption keys, preventing man-in-the-middle attacks
2. **Session Encryption (Layer 2)**: Double encryption combining BLE's built-in AES-128 with application-layer AES-256 using random initialization vectors
3. **Dynamic API Endpoints (Layer 3)**: SHA-256 obfuscated endpoint URLs that change on every device boot, defeating automated vulnerability scanners
4. **Header Obfuscation (Layer 4)**: Dynamically remapping HTTP headers and injecting misleading framework identifiers
5. **Anti-Fingerprinting (Layer 5)**: Fake headers, randomized response patterns, and varied encoding
6. **Honey Pot (Layer 6)**: Decoy endpoints simulating vulnerabilities while logging intrusion attempts
7. **Method Tunneling (Layer 7)**: All requests routed through POST with encrypted method specifications
8. **Timing Attack Protection (Layer 8)**: Constant-time comparisons plus random delays to prevent timing-based inference

```c
// ECDH Key Generation
mbedtls_ecdh_context ctx;
mbedtls_ecdh_setup(&ctx, MBEDTLS_ECP_DP_SECP256R1);
mbedtls_ecdh_gen_public(&ctx, &olen, public_key, 65,
                        mbedtls_ctr_drbg_random, &ctr_drbg);
```

```cpp
// Dynamic Endpoint Generation
String generate_endpoint(const char* base, uint32_t seed) {
    char hash_input[64];
    snprintf(hash_input, sizeof(hash_input), "%s-%u", base, seed);
    uint8_t hash[32];
    mbedtls_sha256((uint8_t*)hash_input, strlen(hash_input), hash, 0);
    // Convert to hex string...
}
```

```c
// Constant-Time Comparison (prevents timing attacks)
bool constant_time_compare(const char* a, const char* b) {
    int result = strlen(a) ^ strlen(b);
    for(size_t i = 0; i < max_len; i++) {
        result |= (i < len_a ? a[i] : 0) ^ (i < len_b ? b[i] : 0);
    }
    return result == 0;
}
```

GitHub: https://github.com/makepkg/SecureGen
