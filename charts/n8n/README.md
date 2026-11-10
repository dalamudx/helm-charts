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
| binaryData.azure.accountKey | string | `""` | Storage account key, used with the account name. |
| binaryData.azure.accountName | string | `""` | Storage account name, used with an account key or managed identity. |
| binaryData.azure.authAutoDetect | bool | `false` | Authenticate via `DefaultAzureCredential` (managed identity, env, Azure CLI) instead of a key. Ignores accountKey and connectionString when enabled. |
| binaryData.azure.connectionString | string | `""` | Azure Storage connection string. Takes precedence over account name/key when set. |
| binaryData.azure.containerName | string | `""` | Blob container to store binary data in. |
| binaryData.azure.endpoint | string | `""` | Custom blob endpoint, e.g. for Azurite. Requires security.azureStorageCustomEndpoints. |
| binaryData.azure.existingSecret | string | `""` | Existing secret with keys `connection-string` and `account-key`. |
| binaryData.localStoragePath | string | `""` | Base storage path for `filesystem` mode, also used for execution data stored on disk. Maps to N8N_STORAGE_PATH. Leave empty to use the default (`~/.n8n/storage`). |
| binaryData.mode | string | `""` | Binary data storage mode. Valid values: `default` (in-memory, deprecated) \| `filesystem` \| `s3` \| `azure` \| `database`. Leave empty to let n8n choose: `filesystem` in regular mode, `database` in queue mode. |
| binaryData.s3.accessKey | string | `""` | S3 access key. |
| binaryData.s3.accessSecret | string | `""` | S3 access secret. |
| binaryData.s3.bucketName | string | `""` | S3 bucket name. |
| binaryData.s3.bucketRegion | string | `"us-east-1"` | S3 bucket region. |
| binaryData.s3.existingSecret | string | `""` | Existing secret for S3 credentials (keys: `access-key-id`, `secret-access-key`). |
| binaryData.s3.forcePathStyle | bool | `true` | Use path-style addressing for S3 requests (needed for MinIO and most S3-compatible stores). Maps to N8N_EXTERNAL_STORAGE_S3_FORCE_PATH_STYLE. Default is true. |
| binaryData.s3.host | string | `""` | S3-compatible storage host. |
| db.postgresdb.database | string | `"n8n"` | PostgreSQL database name. |
| db.postgresdb.existingSecret | string | `""` | Existing secret with `postgres-password` key. Overrides `db.postgresdb.password`. |
| db.postgresdb.host | string | `""` | PostgreSQL server host |
| db.postgresdb.password | string | `""` | PostgreSQL password |
| db.postgresdb.port | int | `5432` | PostgreSQL server port |
| db.postgresdb.schema | string | `"public"` | The PostgreSQL schema. |
| db.postgresdb.ssl.enabled | bool | `false` | Whether to enable SSL. |
| db.postgresdb.username | string | `"postgres"` | PostgreSQL username |
| db.redis.database | int | `0` | Redis database for Bull queue. |
| db.redis.existingSecret | string | `""` | Existing secret with `redis-password` key. Overrides `db.redis.password`. |
| db.redis.host | string | `""` | Redis server host |
| db.redis.password | string | `""` | Redis password |
| db.redis.port | int | `6379` | Redis server port |
| db.redis.username | string | `""` | Redis username |
| db.type | string | `"sqlite"` | Database engine. Valid values: `sqlite` \| `postgresdb`. |
| encryptionKey | string | `""` | If you install n8n first time, you can keep this empty and it will be auto generated and never change again. If you already have a encryption key generated before, please use it here. |
| existingEncryptionKeySecret | string | `""` | The name of an existing secret with encryption key. The secret must contain a key with the name N8N_ENCRYPTION_KEY. |
| global.log.level | string | `"info"` | Log level. Options: `error` \| `warn` \| `info` \| `debug`. |
| global.log.output | list | `["console"]` | Log output target. Options: `console` \| `file`. |
| global.service.annotations | object | `{}` | Service annotations. |
| global.service.enabled | bool | `true` | Enable the Service. |
| global.service.labels | object | `{}` | Service labels. |
| global.service.name | string | `"http"` | Service port name. |
| global.service.port | int | `5678` | Service port. |
| global.service.type | string | `"ClusterIP"` | Service type (ClusterIP, NodePort, LoadBalancer). |
| nodes.external.allowAll | bool | `false` | Allow all external npm packages in Code node. |
| otel.enabled | bool | `false` | Whether to export execution traces over OTLP. Maps to N8N_OTEL_ENABLED. Default is false. |
| otel.endpoint | string | `"http://localhost:4318"` | OTLP collector endpoint. Maps to N8N_OTEL_EXPORTER_OTLP_ENDPOINT. |
| otel.existingHeadersSecret | string | `""` | The name of an existing secret with a `headers` key. Overrides `otel.headers`. |
| otel.headers | string | `""` | OTLP headers, e.g. `authorization=Bearer &lt;TOKEN&gt;`. Stored in a Secret. Maps to N8N_OTEL_EXPORTER_OTLP_HEADERS. |
| otel.protocol | string | `"http/protobuf"` | OTLP protocol: `http/protobuf` or `grpc`. Maps to N8N_OTEL_EXPORTER_OTLP_PROTOCOL. |
| otel.serviceName | string | `"n8n"` | `service.name` reported to the collector. Maps to N8N_OTEL_EXPORTER_SERVICE_NAME. |
| otel.startupConnectivityTimeoutMs | int | `2000` | Milliseconds to wait for the collector at startup before giving up. Maps to N8N_OTEL_STARTUP_CONNECTIVITY_TIMEOUT_MS. |
| otel.traces.includeNodeSpans | bool | `true` | Emit a span per node. Maps to N8N_OTEL_TRACES_INCLUDE_NODE_SPANS. |
| otel.traces.injectOutbound | bool | `true` | Propagate trace context to outbound HTTP requests. Maps to N8N_OTEL_TRACES_INJECT_OUTBOUND. |
| otel.traces.productionOnly | bool | `true` | Trace only production executions of active workflows, not manual/test runs. Maps to N8N_OTEL_TRACES_PRODUCTION_ONLY. |
| otel.traces.sampleRate | float | `1` | Fraction of executions to trace, 0.0-1.0. Maps to N8N_OTEL_TRACES_SAMPLE_RATE. |
| otel.tracingPath | string | `"/v1/traces"` | OTLP traces path. Maps to N8N_OTEL_EXPORTER_OTLP_TRACING_PATH. |
| scheduler.enabled | string | `""` | Enable the durable scheduler. Leave empty to use n8n's default (off before 2.45, on from 2.45). Matters for multi-main and queue-mode setups, where the in-memory scheduler fires each schedule once per instance. Maps to N8N_SCHEDULER_ENABLED. |
| security.azureStorageCustomEndpoints | bool | `false` | Whether Azure Storage Shared Key credentials may target a custom endpoint (private endpoint, custom domain, Azurite). Azure sovereign clouds work without it. Maps to N8N_AZURE_STORAGE_CUSTOM_ENDPOINTS_ENABLED. Default is false. |
| taskRunners.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| taskRunners.image.tag | string | `""` | Image tag (defaults to chart appVersion). |
| webhook.url | string | `""` | Webhook URL (include http/https schema). |

*(See [values.yaml](https://github.com/dalamudx/helm-charts/raw/refs/heads/main/charts/n8n/values.yaml) for the full list of configuration options.)*
