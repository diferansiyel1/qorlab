# PubChem Integration Strategy (Rate Limit + Scale)

This document defines how QorLab uses PubChem while respecting the public API request limits.

## Current implementation (mobile app)

- Client-side request scheduler limits calls to **max 4 requests/second per device** (`PubChemRateLimiter`).
- All PubChem calls are routed through repository/data layer, never directly from UI.
- Repository keeps a TTL cache (18 hours) and serves cached data when network fails.
- `429 Too Many Requests` is retried using `Retry-After` when available.
- App remains functional offline; PubChem enrichments are optional.

## Production scale plan (when MAU grows)

1. Add a thin QorLab PubChem gateway service (server-side proxy).
2. Enforce global token-bucket limit per upstream key/IP (Redis-backed).
3. Cache by normalized query + CID (L1 memory, L2 Redis, L3 object store snapshot).
4. Coalesce duplicate in-flight requests (`singleflight`) to prevent burst fan-out.
5. Return stale-cache response on upstream throttle/outage (stale-while-revalidate).
6. Prewarm cache for top compounds from telemetry-safe aggregate counts (no PII).
7. Add circuit breaker and exponential backoff for persistent 429/5xx.
8. Track SLOs: p95 latency, upstream hit ratio, 429 rate, cache hit rate.

## Product behavior rules

- Free tier sees baseline descriptors.
- Premium tier sees full descriptor panel + synonym intelligence.
- No user account is required for PubChem enrichment.
