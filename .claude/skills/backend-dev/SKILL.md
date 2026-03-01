---
name: backend-dev
description: Backend development - API design, databases, auth, microservices, Node.js/Python/Go, REST/GraphQL, security, performance
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch
---

# Backend Development Skill

## Principles

- **API-first design**: Define OpenAPI/GraphQL schema before implementation
- **12-Factor App**: Config from env, stateless processes, port binding
- **Defense in depth**: Validate at every boundary (input, service, DB)
- **Fail fast, recover gracefully**: Circuit breakers, retries with backoff

## Stack Options

| Concern | Node.js | Python | Go |
|---------|---------|--------|----|
| Framework | Fastify / Hono / NestJS | FastAPI / Django | Chi / Fiber / Echo |
| ORM | Prisma / Drizzle | SQLAlchemy / Tortoise | GORM / sqlc |
| Validation | Zod | Pydantic | go-playground/validator |
| Auth | Lucia / Better-auth | authlib | gorilla/sessions |

## API Design Rules

1. Use plural nouns for resources: `/api/v1/users`, not `/api/v1/user`
2. Version APIs: `/api/v1/`, `/api/v2/`
3. Use proper HTTP methods and status codes
4. Pagination: cursor-based for large datasets, offset for small
5. Rate limiting on all public endpoints
6. Request IDs for tracing (`X-Request-ID`)
7. Consistent error format:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable description",
    "details": [{ "field": "email", "issue": "invalid format" }]
  }
}
```

## Database Patterns

- Always use migrations (never manual schema changes)
- Index frequently queried columns
- Use transactions for multi-table writes
- Soft delete with `deleted_at` timestamp
- UUID v7 for primary keys (time-sortable)
- Connection pooling mandatory (PgBouncer, built-in pools)
- N+1 queries: detect and fix with eager loading or DataLoader

## Security Checklist

- [ ] Input validation and sanitization on ALL endpoints
- [ ] Parameterized queries (never string interpolation in SQL)
- [ ] Rate limiting (per IP + per user)
- [ ] CORS properly configured (not wildcard in production)
- [ ] Helmet/security headers
- [ ] JWT with short TTL + refresh token rotation
- [ ] Secrets in env vars, never in code
- [ ] Audit logging for sensitive operations
- [ ] OWASP Top 10 awareness

## Service Structure (Node.js example)

```
src/
├── modules/
│   └── users/
│       ├── users.controller.ts   # HTTP layer, input validation
│       ├── users.service.ts      # Business logic
│       ├── users.repository.ts   # Data access
│       ├── users.schema.ts       # Zod/Pydantic schemas
│       ├── users.types.ts        # TypeScript types
│       └── users.test.ts         # Unit tests
├── common/
│   ├── middleware/               # Auth, logging, error handling
│   ├── database/                 # Connection, migrations
│   └── utils/                    # Shared utilities
├── config/                       # Environment config with validation
└── server.ts                     # App entry point
```

## Before Writing Code

1. Define the API contract (OpenAPI spec or GraphQL schema)
2. Write the database migration first
3. Plan error cases and edge cases
4. Consider idempotency for write operations
5. Think about caching strategy (Redis, in-memory, CDN)
