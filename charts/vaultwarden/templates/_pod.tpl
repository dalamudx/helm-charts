{{/*
Return the selector labels used by the workload and service.
*/}}
{{- define "vaultwarden.matchLabels" -}}
app.kubernetes.io/component: vaultwarden
{{ include "vaultwarden.selectorLabels" . }}
{{- end }}

{{/*
Render envFrom entries from the current values contract.
*/}}
{{- define "vaultwarden.envFrom" -}}
- configMapRef:
    name: {{ include "vaultwarden.configMapName" . }}
{{- range .Values.extraEnvFrom.configMaps }}
- configMapRef:
    name: {{ . }}
{{- end }}
{{- range .Values.extraEnvFrom.secrets }}
- secretRef:
    name: {{ . }}
{{- end }}
{{- end }}

{{/*
Render a secret-backed environment variable.
*/}}
{{- define "vaultwarden.secretEnvVar" -}}
- name: {{ .name }}
  valueFrom:
    secretKeyRef:
      name: {{ .secretName }}
      key: {{ .secretKey }}
{{- end }}

{{/*
Render built-in container env entries.
*/}}
{{- define "vaultwarden.containerEnv" -}}
{{- $databaseType := lower .Values.database.type -}}
{{- if ne $databaseType "sqlite" }}
  {{- if or .Values.database.external.connectionString.value (and .Values.database.external.existingSecret .Values.database.external.connectionString.existingSecretKey) }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "DATABASE_URL" "secretName" (include "vaultwarden.database.secretName" .) "secretKey" .Values.database.external.connectionString.existingSecretKey) }}
  {{- else }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "DATABASE_USERNAME" "secretName" (include "vaultwarden.database.secretName" .) "secretKey" .Values.database.external.username.existingSecretKey) }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "DATABASE_PASSWORD" "secretName" (include "vaultwarden.database.secretName" .) "secretKey" .Values.database.external.password.existingSecretKey) }}
- name: DATABASE_URL
  value: {{ printf "%s://$(DATABASE_USERNAME):$(DATABASE_PASSWORD)@%s:%v/%s" $databaseType .Values.database.external.host .Values.database.external.port .Values.database.external.database | quote }}
  {{- end }}
{{- end }}
{{- if or .Values.security.hibp.apiKey.value .Values.security.hibp.existingSecret }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "HIBP_API_KEY" "secretName" (include "vaultwarden.hibp.secretName" .) "secretKey" .Values.security.hibp.apiKey.existingSecretKey) }}
{{- end }}
{{- if .Values.mfa.yubico.enabled }}
  {{- if or .Values.mfa.yubico.secretKey.value .Values.mfa.yubico.existingSecret }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "YUBICO_SECRET_KEY" "secretName" (include "vaultwarden.yubico.secretName" .) "secretKey" .Values.mfa.yubico.secretKey.existingSecretKey) }}
  {{- end }}
{{- end }}
{{- if .Values.mfa.duo.enabled }}
  {{- if or .Values.mfa.duo.sKey.value .Values.mfa.duo.existingSecret }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "DUO_SKEY" "secretName" (include "vaultwarden.duo.secretName" .) "secretKey" .Values.mfa.duo.sKey.existingSecretKey) }}
  {{- end }}
{{- end }}
{{- if .Values.smtp.enabled }}
  {{- if or .Values.smtp.username.value .Values.smtp.existingSecret }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "SMTP_USERNAME" "secretName" (include "vaultwarden.smtp.secretName" .) "secretKey" .Values.smtp.username.existingSecretKey) }}
  {{- end }}
  {{- if or .Values.smtp.password.value .Values.smtp.existingSecret }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "SMTP_PASSWORD" "secretName" (include "vaultwarden.smtp.secretName" .) "secretKey" .Values.smtp.password.existingSecretKey) }}
  {{- end }}
{{- end }}
{{- if and (not .Values.config.disableAdminToken) .Values.adminToken }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "ADMIN_TOKEN" "secretName" (include "vaultwarden.adminToken.secretName" .) "secretKey" .Values.adminToken.existingSecretKey) }}
{{- end }}
{{- if .Values.pushNotifications.enabled }}
  {{- if or .Values.pushNotifications.installationId.value .Values.pushNotifications.existingSecret }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "PUSH_INSTALLATION_ID" "secretName" (include "vaultwarden.pushNotifications.secretName" .) "secretKey" .Values.pushNotifications.installationId.existingSecretKey) }}
  {{- end }}
  {{- if or .Values.pushNotifications.installationKey.value .Values.pushNotifications.existingSecret }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "PUSH_INSTALLATION_KEY" "secretName" (include "vaultwarden.pushNotifications.secretName" .) "secretKey" .Values.pushNotifications.installationKey.existingSecretKey) }}
  {{- end }}
{{- end }}
{{- if .Values.sso.enabled }}
  {{- if or .Values.sso.clientId.value .Values.sso.existingSecret }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "SSO_CLIENT_ID" "secretName" (include "vaultwarden.sso.secretName" .) "secretKey" .Values.sso.clientId.existingSecretKey) }}
  {{- end }}
  {{- if or .Values.sso.clientSecret.value .Values.sso.existingSecret }}
{{ include "vaultwarden.secretEnvVar" (dict "name" "SSO_CLIENT_SECRET" "secretName" (include "vaultwarden.sso.secretName" .) "secretKey" .Values.sso.clientSecret.existingSecretKey) }}
  {{- end }}
{{- end }}
{{- with .Values.extraEnvVars }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Render HTTP probes from the current values contract.
Usage: {{ include "vaultwarden.httpProbe" (dict "probe" .Values.livenessProbe "port" "http") }}
*/}}
{{- define "vaultwarden.httpProbe" -}}
httpGet:
  path: {{ .probe.path }}
  port: {{ .port }}
initialDelaySeconds: {{ .probe.initialDelaySeconds }}
periodSeconds: {{ .probe.periodSeconds }}
timeoutSeconds: {{ .probe.timeoutSeconds }}
successThreshold: {{ .probe.successThreshold }}
failureThreshold: {{ .probe.failureThreshold }}
{{- end }}

{{/*
Shared pod spec for runtime workloads.
*/}}
{{- define "vaultwarden.podSpec" -}}
{{- $workloadType := include "vaultwarden.workloadType" . -}}
{{- $storageEnabled := .Values.storage.enabled -}}
{{- $storageVolumeName := "data" -}}
{{- $dataPath := .Values.storage.dataPath -}}
{{- $attachmentsPath := .Values.storage.attachmentsPath -}}
{{- $storageSubPath := .Values.storage.subPath -}}
{{- $needsStorageVolume := and $storageEnabled (or .Values.storage.existingClaim (eq $workloadType "Deployment")) -}}
{{- $hasExtraVolumeMounts := not (empty .Values.extraVolumeMounts) -}}
{{- $hasExtraVolumes := not (empty .Values.extraVolumes) -}}
serviceAccountName: {{ include "vaultwarden.serviceAccountName" . }}
automountServiceAccountToken: {{ .Values.serviceAccount.automount }}
{{- with .Values.image.pullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.podSecurityContext }}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.initContainers }}
initContainers:
  {{- toYaml . | nindent 2 }}
{{- end }}
containers:
  - name: vaultwarden
    image: {{ include "vaultwarden.image" . | quote }}
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    {{- with .Values.containerSecurityContext }}
    securityContext:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    ports:
      - name: http
        containerPort: {{ .Values.config.rocket.port }}
        protocol: TCP
    {{- $containerEnv := include "vaultwarden.containerEnv" . }}
    {{- if $containerEnv }}
    env:
      {{- $containerEnv | nindent 6 }}
    {{- end }}
    {{- if or .Values.extraEnvFrom.configMaps .Values.extraEnvFrom.secrets true }}
    envFrom:
      {{- include "vaultwarden.envFrom" . | nindent 6 }}
    {{- end }}
    {{- if .Values.livenessProbe.enabled }}
    livenessProbe:
      {{- include "vaultwarden.httpProbe" (dict "probe" .Values.livenessProbe "port" "http") | nindent 6 }}
    {{- end }}
    {{- if .Values.readinessProbe.enabled }}
    readinessProbe:
      {{- include "vaultwarden.httpProbe" (dict "probe" .Values.readinessProbe "port" "http") | nindent 6 }}
    {{- end }}
    {{- if .Values.startupProbe.enabled }}
    startupProbe:
      {{- include "vaultwarden.httpProbe" (dict "probe" .Values.startupProbe "port" "http") | nindent 6 }}
    {{- end }}
    {{- with .Values.workload.resources }}
    resources:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- if or $storageEnabled $hasExtraVolumeMounts }}
    volumeMounts:
      {{- if $storageEnabled }}
      - name: {{ $storageVolumeName }}
        mountPath: {{ $dataPath }}
        {{- if $storageSubPath }}
        subPath: {{ $storageSubPath }}
        {{- end }}
      {{- if and $attachmentsPath (not (hasPrefix $dataPath $attachmentsPath)) }}
      - name: {{ $storageVolumeName }}
        mountPath: {{ $attachmentsPath }}
        {{- if $storageSubPath }}
        subPath: {{ printf "%s/attachments" $storageSubPath }}
        {{- end }}
      {{- end }}
      {{- end }}
      {{- with .Values.extraVolumeMounts }}
      {{- toYaml . | nindent 6 }}
      {{- end }}
    {{- end }}
{{- with .Values.sidecars }}
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if or $needsStorageVolume $hasExtraVolumes }}
volumes:
  {{- if $needsStorageVolume }}
  - name: {{ $storageVolumeName }}
    persistentVolumeClaim:
      claimName: {{ if .Values.storage.existingClaim }}{{ .Values.storage.existingClaim }}{{ else }}{{ include "vaultwarden.fullname" . }}{{ end }}
  {{- end }}
  {{- with .Values.extraVolumes }}
  {{- toYaml . | nindent 2 }}
  {{- end }}
{{- end }}
{{- with .Values.workload.priorityClassName }}
priorityClassName: {{ . | quote }}
{{- end }}
{{- with .Values.workload.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.workload.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.workload.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.workload.topologySpreadConstraints }}
topologySpreadConstraints:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
