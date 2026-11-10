# n8n

Helm chart for n8n - A workflow automation platform that gives technical teams the flexibility of code with the speed of no-code.

## Introduction

This chart bootstraps an [n8n](https://n8n.io) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Chart Info

| Field | Value |
|-------|-------|
| Version | ![Chart](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fgithub.com%2Fdalamudx%2Fhelm-charts%2Fraw%2Frefs%2Fheads%2Fmain%2Fcharts%2Fn8n%2FChart.yaml&query=%24.version&style=flat-square&label=Chart) ![App](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fgithub.com%2Fdalamudx%2Fhelm-charts%2Fraw%2Frefs%2Fheads%2Fmain%2Fcharts%2Fn8n%2FChart.yaml&query=%24.appVersion&style=flat-square&label=App) |
| Source | <a href="https://github.com/n8n-io/n8n">https://github.com/n8n-io/n8n</a><br><a href="https://github.com/dalamudx/helm-charts">https://github.com/dalamudx/helm-charts</a> |

## Prerequisites

- Kubernetes >=1.23.0-0
- Helm 3.0+
- PV provisioner support in the underlying infrastructure
- PostgreSQL (Required for production)
- Redis (Required for queue mode)

## Installing the Chart

To install the chart with the release name `my-n8n`:

```bash
helm install my-n8n dev-charts/n8n
```

## Uninstalling the Chart

To uninstall/delete the `my-n8n` deployment:

```bash
helm uninstall my-n8n
```

## Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aiAssistant.baseUrl | string | `""` | Base URL for the legacy n8n AI Assistant backend. Maps to N8N_AI_ASSISTANT_BASE_URL. Leave empty to use the default. |
| aiAssistant.instanceAi.enabled | string | `""` | Default state of the n8n Assistant before an admin chooses in Settings > Assistant. Empty keeps n8n's default: on for self-hosted non-Enterprise, off on Enterprise. Maps to N8N_INSTANCE_AI_ENABLED. See Notes. |
| api.rateLimit.enabled | bool | `false` | Per-API-key rate limiting for the public API (`/api/v1/*`). Maps to N8N_PUBLIC_API_RATE_LIMIT_ENABLED. The limits keep n8n's defaults (1200 reads and 600 writes per key per minute); override them with extraEnvVars. |
| binaryData.mode | string | `""` | Storage mode: `filesystem`, `s3`, `azure` or `database`. Empty lets n8n choose: `filesystem` in regular mode, `database` in queue mode. Maps to N8N_DEFAULT_BINARY_DATA_MODE. |
| binaryData.s3.accessSecret | string | `""` | S3 access secret. |
| binaryData.s3.bucketName | string | `""` | S3 bucket name. |
| binaryData.s3.bucketRegion | string | `"us-east-1"` | S3 bucket region. |
| binaryData.s3.existingSecret | string | `""` | Existing secret for S3 credentials (keys: `access-key-id`, `secret-access-key`). |
| binaryData.s3.host | string | `""` | S3-compatible storage host. |
| db.postgresdb.database | string | `"n8n"` | PostgreSQL database name. |
| db.postgresdb.existingSecret | string | `""` | Existing secret with `postgres-password` key. Overrides `db.postgresdb.password`. |
| db.postgresdb.host | string | `""` | PostgreSQL server host |
| db.postgresdb.password | string | `""` | PostgreSQL password |
| db.redis.existingSecret | string | `""` | Existing secret with `redis-password` key. Overrides `db.redis.password`. |
| db.redis.host | string | `""` | Redis server host |
| db.redis.password | string | `""` | Redis password |
| db.type | string | `"sqlite"` | Database engine. Valid values: `sqlite` \| `postgresdb`. |
| encryptionKey | string | `""` | Encryption key for stored credentials. Leave empty to generate one on first start; it must never change after that. |
| existingEncryptionKeySecret | string | `""` | Name of an existing secret holding `N8N_ENCRYPTION_KEY`. Overrides `encryptionKey`. |
| global.log.level | string | `"info"` | Log level. Options: `error` \| `warn` \| `info` \| `debug`. |
| gracefulShutdownTimeout | int | `30` | Seconds n8n waits for its own shutdown (finishing executions, draining the task broker). Maps to N8N_GRACEFUL_SHUTDOWN_TIMEOUT. Default is 30. |
| n8nPath | string | `"/"` | Base path to serve n8n under, with a trailing slash (e.g. `/n8n/`). Maps to N8N_PATH. |
| nodes.blockDeprecated | bool | `true` | Whether workflows may add or change deprecated nodes. Set to false to import older backups. Maps to N8N_DEPRECATED_NODES_BLOCK. Default is true. |
| nodes.external.allowAll | bool | `false` | Allow all external npm packages in Code node. |
| otel.enabled | bool | `false` | Export execution traces over OTLP. Maps to N8N_OTEL_ENABLED. |
| scheduler.enabled | string | `""` | Run Schedule Trigger from the durable scheduler. Empty keeps n8n's default (on from 2.45). Maps to N8N_SCHEDULER_ENABLED. |
| security.secureCookie | bool | `true` | Whether to use secure cookies (HTTPS only). Set to false in HTTP-only environments. Maps to N8N_SECURE_COOKIE. Default is true. |
| taskRunners.image.tag | string | `""` | Image tag (defaults to chart appVersion). |
| terminationGracePeriodSeconds | string | `""` | Seconds Kubernetes waits before SIGKILL. Empty derives `gracefulShutdownTimeout` + 10s. Maps to the pod spec field of the same name; see Notes for the external runner case. |
| webhook.url | string | `""` | Webhook URL (include http/https schema). |
| worker.suspendExecutionsOnShutdown | bool | `false` | Park in-flight executions at the next node boundary on shutdown, for another worker to resume. Maps to N8N_WORKER_SUSPEND_EXECUTIONS_ON_SHUTDOWN. Ships in n8n 2.43.7-2.43.8 and 2.45.0+. |

*(See [values.yaml](https://github.com/dalamudx/helm-charts/raw/refs/heads/main/charts/n8n/values.yaml) for the full list of configuration options.)*

## Notes

- **Scheduler.** From n8n 2.45 the durable scheduler is on by default, so Schedule Trigger runs from a database queue instead of each instance's memory. Set `scheduler.enabled: false` to keep the in-memory scheduler.
- **n8n Assistant (Instance AI).** From n8n 2.47 it is on by default for self-hosted non-Enterprise instances, and it sends workflow data to a model provider unless `N8N_INSTANCE_AI_MODEL_URL` points at a local model. Set `aiAssistant.instanceAi.enabled: false` to keep it off.
- **Pod shutdown.** n8n force-exits after `gracefulShutdownTimeout` (30s). `terminationGracePeriodSeconds` defaults to that plus 10s, so n8n finishes first instead of the pod being killed mid-shutdown. With `taskRunners.mode: external`, set it to at least 60: the launcher drains on its own timers (30s + 2x10s) on top of n8n's.
- **Worker shutdown.** `worker.suspendExecutionsOnShutdown: true` parks in-flight executions at the next node boundary so another worker resumes them, instead of losing them to the pod restart.
- **Binary data.** `binaryData.mode` is empty by default, which lets n8n pick `filesystem` in regular mode and `database` in queue mode. `s3` needs `binaryData.s3.*`, `azure` needs `binaryData.azure.*` plus `security.azureStorageCustomEndpoints` for a custom endpoint.
- **Tracing.** `otel.enabled` exports execution traces over OTLP to `otel.endpoint`; protocol, sample rate, node spans and header auth are set with the other `otel.*` keys in [values.yaml](https://github.com/dalamudx/helm-charts/raw/refs/heads/main/charts/n8n/values.yaml).
- **Everything else.** Metrics toggles under `serviceMonitor.include.*`, public API rate limiting under `api.rateLimit.*`, workflow defaults under `workflows.*` and the Code node sandbox switches under `security.*` and `nodes.*` stay in [values.yaml](https://github.com/dalamudx/helm-charts/raw/refs/heads/main/charts/n8n/values.yaml).
