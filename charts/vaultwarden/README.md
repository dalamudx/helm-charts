# Vaultwarden

Helm chart for Vaultwarden - an unofficial Bitwarden-compatible server written in Rust.

## Introduction

This chart bootstraps a [Vaultwarden](https://github.com/dani-garcia/vaultwarden) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Chart Info

| Field | Value |
|-------|-------|
| Version | ![Chart](https://img.shields.io/badge/Chart-1.0.0-informational?style=flat-square) ![App](https://img.shields.io/badge/App-1.35.5-informational?style=flat-square) |
| Source | <a href="https://github.com/dani-garcia/vaultwarden">https://github.com/dani-garcia/vaultwarden</a><br><a href="https://github.com/dalamudx/helm-charts">https://github.com/dalamudx/helm-charts</a> |

## Prerequisites

- Kubernetes >=1.24.0-0
- Helm 3.0+
- Persistent volume support if `storage.enabled=true`
- An external PostgreSQL or MySQL service if `database.type` is not `sqlite`

## Installing the Chart

To install the chart with the release name `my-vaultwarden`:

```bash
helm install my-vaultwarden dev-charts/vaultwarden -f your-values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `my-vaultwarden` deployment:

```bash
helm uninstall my-vaultwarden
```

## Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| adminToken.existingSecret | string | `""` | Existing Secret containing the admin token. |
| config.dataFolder | string | `"/data"` | Base data folder used by Vaultwarden. |
| config.domain | string | `""` | Public Vaultwarden URL, including scheme and optional path. |
| config.rocket.address | string | `"0.0.0.0"` | Rocket bind address. |
| config.rocket.port | int | `8080` | Rocket bind port. |
| config.rocket.workers | int | `10` | Number of Rocket worker threads. |
| config.webVaultEnabled | bool | `true` | Enable the built-in web vault UI. |
| config.webVaultFolder | string | `"web-vault/"` | Folder containing the bundled web vault assets. |
| database.connectionRetries | int | `15` | Number of startup retries while waiting for the database. |
| database.external.host | string | `""` | External PostgreSQL/MySQL host used in non-sqlite modes. |
| database.sqlite.path | string | `"/data/db.sqlite3"` | SQLite database file path. |
| database.type | string | `"sqlite"` | Database backend used by Vaultwarden. |
| fullnameOverride | string | `""` | Override the fully qualified release name. |
| httpRoute.enabled | bool | `false` | Enable Gateway API HTTPRoute-based external access. |
| image.registry | string | `"docker.io"` | Container image registry. |
| image.repository | string | `"vaultwarden/server"` | Container image repository. |
| image.tag | string | `""` | Container image tag. Defaults to the chart appVersion when empty. |
| ingress.enabled | bool | `false` | Enable Ingress-based external access. |
| nameOverride | string | `""` | Override the chart name. |
| service.port | int | `80` | Service port exposed inside the cluster. |
| service.targetPort | string | `nil` | Target container port. Defaults to `config.rocket.port` when unset. |
| service.type | string | `"ClusterIP"` | Kubernetes Service type. |
| smtp.enabled | bool | `false` | Enable SMTP-dependent features such as invitations and email 2FA. |
| sso.enabled | bool | `false` | Enable OpenID Connect SSO support. |
| storage.enabled | bool | `false` | Enable persistent storage for Vaultwarden data. |
| storage.existingClaim | string | `""` | Existing PVC to mount instead of creating one. |
| storage.size | string | `"10Gi"` | Persistent volume size when the chart manages storage. |
| websocket.enabled | bool | `true` | Enable Vaultwarden websocket notifications. |
| workload.dnsConfig | object | `{}` | Optional pod DNS configuration override. |
| workload.dnsPolicy | string | `""` | Optional pod DNS policy override. |
| workload.kind | string | `"Deployment"` | Workload kind. Valid values: `Deployment` or `StatefulSet`. |
| workload.replicaCount | int | `1` | Number of Vaultwarden replicas. Keep `1` unless you explicitly accept the upstream multi-replica caveats. |

*(See [values.yaml](https://github.com/dalamudx/helm-charts/raw/refs/heads/main/charts/vaultwarden/values.yaml) for the full list of configuration options.)*
