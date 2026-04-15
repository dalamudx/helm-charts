{{/*
Expand the name of the chart.
*/}}
{{- define "vaultwarden.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "vaultwarden.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "vaultwarden.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "vaultwarden.labels" -}}
helm.sh/chart: {{ include "vaultwarden.chart" . }}
{{ include "vaultwarden.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels }}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "vaultwarden.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vaultwarden.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Service account name.
*/}}
{{- define "vaultwarden.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "vaultwarden.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the full image reference.
*/}}
{{- define "vaultwarden.image" -}}
{{- $registry := .Values.image.registry -}}
{{- $repository := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- if .Values.image.digest -}}
  {{- if $registry -}}
    {{- printf "%s/%s@%s" $registry $repository .Values.image.digest -}}
  {{- else -}}
    {{- printf "%s@%s" $repository .Values.image.digest -}}
  {{- end -}}
{{- else -}}
  {{- if $registry -}}
    {{- printf "%s/%s:%s" $registry $repository $tag -}}
  {{- else -}}
    {{- printf "%s:%s" $repository $tag -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the ConfigMap name for non-secret runtime envs.
*/}}
{{- define "vaultwarden.configMapName" -}}
{{- include "vaultwarden.fullname" . -}}
{{- end -}}

{{/*
Return a namespaced secret name.
Usage: {{ include "vaultwarden.secretName" (dict "context" . "name" "database" "existingSecret" .Values.database.external.existingSecret) }}
*/}}
{{- define "vaultwarden.secretName" -}}
{{- $context := .context -}}
{{- $name := default "secret" .name -}}
{{- $existing := .existingSecret -}}
{{- if $existing -}}
{{- $existing -}}
{{- else -}}
{{- printf "%s-%s" (include "vaultwarden.fullname" $context) $name -}}
{{- end -}}
{{- end -}}

{{/*
Return the database secret name.
*/}}
{{- define "vaultwarden.database.secretName" -}}
{{- include "vaultwarden.secretName" (dict "context" . "name" "database" "existingSecret" .Values.database.external.existingSecret) -}}
{{- end -}}

{{/*
Return the SMTP secret name.
*/}}
{{- define "vaultwarden.smtp.secretName" -}}
{{- include "vaultwarden.secretName" (dict "context" . "name" "smtp" "existingSecret" .Values.smtp.existingSecret) -}}
{{- end -}}

{{/*
Return the admin token secret name.
*/}}
{{- define "vaultwarden.adminToken.secretName" -}}
{{- include "vaultwarden.secretName" (dict "context" . "name" "admin-token" "existingSecret" .Values.adminToken.existingSecret) -}}
{{- end -}}

{{/*
Return the push notifications secret name.
*/}}
{{- define "vaultwarden.pushNotifications.secretName" -}}
{{- include "vaultwarden.secretName" (dict "context" . "name" "push-notifications" "existingSecret" .Values.pushNotifications.existingSecret) -}}
{{- end -}}

{{/*
Return the SSO secret name.
*/}}
{{- define "vaultwarden.sso.secretName" -}}
{{- include "vaultwarden.secretName" (dict "context" . "name" "sso" "existingSecret" .Values.sso.existingSecret) -}}
{{- end -}}

{{/*
Return the HIBP secret name.
*/}}
{{- define "vaultwarden.hibp.secretName" -}}
{{- include "vaultwarden.secretName" (dict "context" . "name" "hibp" "existingSecret" .Values.security.hibp.existingSecret) -}}
{{- end -}}

{{/*
Return the Yubico secret name.
*/}}
{{- define "vaultwarden.yubico.secretName" -}}
{{- include "vaultwarden.secretName" (dict "context" . "name" "yubico" "existingSecret" .Values.mfa.yubico.existingSecret) -}}
{{- end -}}

{{/*
Return the Duo secret name.
*/}}
{{- define "vaultwarden.duo.secretName" -}}
{{- include "vaultwarden.secretName" (dict "context" . "name" "duo" "existingSecret" .Values.mfa.duo.existingSecret) -}}
{{- end -}}

{{/*
Return the workload type (Deployment or StatefulSet).
*/}}
{{- define "vaultwarden.workloadType" -}}
{{- $kind := default "Deployment" .Values.workload.kind -}}
{{- $normalizedKind := lower $kind -}}
{{- if eq $normalizedKind "deployment" -}}
Deployment
{{- else if eq $normalizedKind "statefulset" -}}
StatefulSet
{{- else -}}
{{- fail (printf "workload.kind must be one of: Deployment, StatefulSet (got %q)" $kind) -}}
{{- end -}}
{{- end -}}
