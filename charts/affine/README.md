# AFFiNE

Helm chart for AFFiNE - The next-gen knowledge base.

## Introduction

This chart bootstraps an [AFFiNE](https://github.com/toeverything/AFFiNE) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Chart Info

| Field | Value |
|-------|-------|
| Version | ![Chart](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fgithub.com%2Fdalamudx%2Fhelm-charts%2Fraw%2Frefs%2Fheads%2Fmain%2Fcharts%2Faffine%2FChart.yaml&query=%24.version&style=flat-square&label=Chart) ![App](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fgithub.com%2Fdalamudx%2Fhelm-charts%2Fraw%2Frefs%2Fheads%2Fmain%2Fcharts%2Faffine%2FChart.yaml&query=%24.appVersion&style=flat-square&label=App) |
| Source | <a href="https://github.com/toeverything/AFFiNE">https://github.com/toeverything/AFFiNE</a><br><a href="https://github.com/dalamudx/helm-charts">https://github.com/dalamudx/helm-charts</a> |

## Prerequisites

- Kubernetes >=1.24.0-0
- Helm 3.0+
- PostgreSQL 16+ (Required)
  - For AI features: `pgvector/pgvector:pg16` is required
- Redis 6.x or 7.x (Required)

## Installing the Chart

To install the chart with the release name `my-affine`:

```bash
helm install my-affine dev-charts/affine -f your-values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `my-affine` deployment:

```bash
helm uninstall my-affine
```

## Parameters


| Key | Type | Default | Description |
|-----|------|---------|-------------|
| app.externalUrl | string | `""` | Public URL — **required** (e.g. `https://affine.example.com`) |
| app.logLevel | string | `"log"` | Log level: `verbose` \| `debug` \| `log` \| `warn` \| `error` |
| db.database.existingSecret | string | `""` | Existing Secret containing `postgres-password` key |
| db.database.host | string | `"pg-postgresql"` | PostgreSQL host |
| db.indexer.enabled | bool | `false` | Enable external search indexer |
| db.indexer.provider | string | `"manticoresearch"` | Indexer provider: `manticoresearch` \| `elasticsearch` |
| db.redis.existingSecret | string | `""` | Existing Secret containing `redis-password` key |
| db.redis.host | string | `"redis-master"` | Redis host |
| front.httpRoute.enabled | bool | `false` | Enable Gateway API HTTPRoute |
| global.registry | string | `"ghcr.io"` | Image registry |
| global.tag | string | `""` | Image tag (defaults to chart appVersion) |
| persistence.enabled | bool | `false` | Enable PVC for blob/avatar storage |

*(See [values.yaml](https://github.com/dalamudx/helm-charts/raw/refs/heads/main/charts/affine/values.yaml) for the full list of configuration options.)*
