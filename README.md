# Helm Charts

This repository hosts Helm charts for various applications.

## Usage

Add this repository to your Helm client:

```bash
helm repo add dev-charts https://dalamudx.github.io/helm-charts
helm repo update
```

## Available Charts

| Chart | Description | Chart Version | App Version |
|---|---|---|---|
| **affine** | Helm chart for AFFiNE - The next-gen knowledge base. | ![Chart](https://img.shields.io/badge/Chart-1.0.4-informational?style=flat-square) | ![App](https://img.shields.io/badge/App-0.26.3-informational?style=flat-square) |
| **n8n** | Helm chart for n8n - A workflow automation platform that gives technical teams the flexibility of code with the speed of no-code. | ![Chart](https://img.shields.io/badge/Chart-1.0.33-informational?style=flat-square) | ![App](https://img.shields.io/badge/App-2.14.2-informational?style=flat-square) |

## Installation

```bash
# Install affine
helm install affine-release dev-charts/affine -f your-values.yaml

# Install n8n
helm install n8n-release dev-charts/n8n -f your-values.yaml

```
