---
name: system-design
description: System design and architecture - scalability, distributed systems, database selection, caching, messaging, load balancing, CAP theorem, trade-off analysis
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch
---

# System Design Skill

## Approach Framework

For every design task, follow this structure:

### 1. Requirements Clarification
- Functional requirements (what the system does)
- Non-functional requirements (scale, latency, availability, consistency)
- Back-of-the-envelope estimation (QPS, storage, bandwidth)

### 2. High-Level Design
- Draw component diagram (services, databases, caches, queues)
- Define API contracts between services
- Identify data flow and ownership

### 3. Deep Dive
- Database schema design
- Scaling strategy (horizontal vs vertical)
- Caching layer (what, where, invalidation)
- Failure modes and mitigations

### 4. Trade-off Discussion
- CAP theorem position for each service
- Consistency vs availability decisions
- Cost vs performance trade-offs

## Database Selection Guide

| Need | Choose | Why |
|------|--------|-----|
| Relational data, ACID | PostgreSQL | Battle-tested, extensible, JSON support |
| High-write throughput | ScyllaDB / Cassandra | Linear scaling, tunable consistency |
| Document-flexible schema | MongoDB | Schema evolution, developer velocity |
| Cache / sessions | Redis / Valkey | In-memory speed, data structures |
| Search / full-text | Elasticsearch / Meilisearch | Inverted index, faceted search |
| Time-series metrics | TimescaleDB / ClickHouse | Compression, time-window queries |
| Graph relationships | Neo4j / DGraph | Traversal queries, relationship-first |
| Vector/embeddings | Pgvector / Qdrant / Pinecone | ANN search for AI/ML |

## Scaling Patterns

- **Horizontal scaling**: Stateless services behind LB
- **Database sharding**: By user_id, region, or time
- **Read replicas**: For read-heavy workloads
- **CQRS**: Separate read/write models for complex domains
- **Event Sourcing**: Audit trail, temporal queries
- **Saga pattern**: Distributed transactions across services
- **Bulkhead**: Isolate critical from non-critical paths

## Caching Strategy

```
Client → CDN (static) → API Gateway (rate limit cache)
  → Application cache (Redis) → Database (connection pool)
```

- **Cache-aside**: App reads cache, miss → read DB → populate cache
- **Write-through**: Write to cache and DB simultaneously
- **Write-behind**: Write to cache, async write to DB
- **TTL**: Always set, even if long (prevent stale forever)
- **Cache invalidation**: Event-driven via pub/sub preferred over TTL-only

## Messaging & Event Patterns

| Pattern | Use | Tool |
|---------|-----|------|
| Pub/Sub | Broadcast events | Kafka, NATS, Redis Streams |
| Work Queue | Distribute tasks | BullMQ, Celery, SQS |
| Event Streaming | Event sourcing, CDC | Kafka, Redpanda |
| Request/Reply | Sync over async | NATS, RabbitMQ |

## Reliability Patterns

- **Circuit breaker**: Prevent cascade failures
- **Retry with exponential backoff + jitter**
- **Timeout budgets**: Total timeout distributed across calls
- **Health checks**: Shallow (process) + deep (dependencies)
- **Graceful degradation**: Feature flags to disable non-critical
- **Chaos engineering**: Regularly test failure scenarios

## Capacity Estimation Template

```
Users: X monthly active users
DAU: ~30% of MAU = Y
Peak QPS: DAU × actions_per_day / 86400 × peak_multiplier(3-5)
Storage: records_per_day × avg_record_size × retention_days
Bandwidth: QPS × avg_response_size
```

## Output Format

When asked about system design, produce:
1. **Requirements** table (functional + non-functional)
2. **Architecture diagram** (Mermaid or ASCII)
3. **Data model** (key entities, relationships)
4. **API design** (key endpoints)
5. **Scaling plan** (what happens at 10x, 100x)
6. **Trade-offs** (what we gain, what we sacrifice)
