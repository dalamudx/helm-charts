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
| **affine** | Helm chart for AFFiNE - The next-gen knowledge base. | ![Chart](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fgithub.com%2Fdalamudx%2Fhelm-charts%2Fraw%2Frefs%2Fheads%2Fmain%2Fcharts%2Faffine%2FChart.yaml&query=%24.version&style=flat-square&label=Chart) | ![App](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fgithub.com%2Fdalamudx%2Fhelm-charts%2Fraw%2Frefs%2Fheads%2Fmain%2Fcharts%2Faffine%2FChart.yaml&query=%24.appVersion&style=flat-square&label=App) |
| **n8n** | Helm chart for n8n - A workflow automation platform that gives technical teams the flexibility of code with the speed of no-code. | ![Chart](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fgithub.com%2Fdalamudx%2Fhelm-charts%2Fraw%2Frefs%2Fheads%2Fmain%2Fcharts%2Fn8n%2FChart.yaml&query=%24.version&style=flat-square&label=Chart) | ![App](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fgithub.com%2Fdalamudx%2Fhelm-charts%2Fraw%2Frefs%2Fheads%2Fmain%2Fcharts%2Fn8n%2FChart.yaml&query=%24.appVersion&style=flat-square&label=App) |
| **vaultwarden** | Helm chart for Vaultwarden - an unofficial Bitwarden-compatible server written in Rust. | ![Chart](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fgithub.com%2Fdalamudx%2Fhelm-charts%2Fraw%2Frefs%2Fheads%2Fmain%2Fcharts%2Fvaultwarden%2FChart.yaml&query=%24.version&style=flat-square&label=Chart) | ![App](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fgithub.com%2Fdalamudx%2Fhelm-charts%2Fraw%2Frefs%2Fheads%2Fmain%2Fcharts%2Fvaultwarden%2FChart.yaml&query=%24.appVersion&style=flat-square&label=App) |

## Installation

```bash
# Install affine
helm install affine-release dev-charts/affine -f your-values.yaml

# Install n8n
helm install n8n-release dev-charts/n8n -f your-values.yaml

# Install Vaultwarden
helm install vaultwarden-release dev-charts/vaultwarden -f your-values.yaml

```
