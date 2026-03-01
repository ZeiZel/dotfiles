---
name: devops
description: DevOps and infrastructure - Docker, Kubernetes, CI/CD, Terraform, monitoring, cloud architecture, security hardening, GitOps
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch
---

# DevOps & Infrastructure Skill

## Core Principles

- **Infrastructure as Code**: Everything in Git, nothing manual
- **GitOps**: Git as single source of truth for infra state
- **Immutable infrastructure**: Replace, don't patch
- **Shift left security**: Scan in CI, not after deploy
- **Observability triad**: Logs + Metrics + Traces

## Docker Best Practices

```dockerfile
# ✅ Multi-stage build, non-root, minimal image
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --production=false
COPY . .
RUN npm run build

FROM node:22-alpine AS runner
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
WORKDIR /app
COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/package.json ./
USER appuser
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD wget -q --spider http://localhost:3000/health || exit 1
CMD ["node", "dist/server.js"]
```

- Pin base image versions with SHA digest for production
- Use `.dockerignore` (node_modules, .git, .env, tests)
- One process per container
- HEALTHCHECK in every Dockerfile
- Scan images with Trivy/Grype in CI

## Kubernetes Essentials

- Resource requests AND limits on every container
- Liveness + readiness + startup probes
- Pod Disruption Budgets for HA
- Network Policies to restrict pod-to-pod traffic
- Secrets via External Secrets Operator (not plain k8s secrets)
- HPA for auto-scaling with custom metrics
- Use `topologySpreadConstraints` for zone distribution

## CI/CD Pipeline Template

```yaml
# Stages: lint → test → build → scan → deploy
stages:
  - lint:        # ESLint, type check, Hadolint
  - test:        # Unit, integration, coverage gate (>80%)
  - build:       # Docker build, tag with git SHA
  - scan:        # Trivy (image), Snyk (deps), SAST
  - deploy-stg:  # Auto-deploy to staging
  - e2e:         # Playwright/Cypress on staging
  - deploy-prod: # Manual approval or auto with canary
```

## Terraform Conventions

- Remote state (S3 + DynamoDB lock / Terraform Cloud)
- Modules for reusable infrastructure
- Separate workspaces per environment
- `terraform plan` in CI, `terraform apply` only from CD
- Pin provider versions
- Use `checkov` or `tfsec` for security scanning

## Monitoring Stack

| Layer | Tool | Purpose |
|-------|------|---------|
| Metrics | Prometheus + Grafana | System & app metrics, alerting |
| Logs | Loki / ELK | Centralized log aggregation |
| Traces | Jaeger / Tempo | Distributed tracing |
| Uptime | Uptime Kuma / Datadog | External health checks |
| Alerts | Alertmanager / PagerDuty | On-call routing |

## Key Alerts to Set Up

- CPU/Memory > 80% sustained
- Error rate > 1% of requests
- Latency P99 > threshold
- Disk usage > 85%
- Certificate expiry < 30 days
- Pod restart count > 3 in 5 min
- Failed deployments

## Security Hardening

- [ ] All traffic over TLS (cert-manager + Let's Encrypt)
- [ ] Secrets rotation automated
- [ ] Container images scanned and signed
- [ ] RBAC with least privilege
- [ ] Audit logs enabled on cluster
- [ ] No containers running as root
- [ ] Network policies enforced
- [ ] Supply chain security (Sigstore, SBOM)
