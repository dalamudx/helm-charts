{{- define "vaultwarden.validate" -}}
{{- $workloadKind := default "Deployment" .Values.workload.kind -}}
{{- $normalizedWorkloadKind := lower $workloadKind -}}
{{- if not (or (eq $normalizedWorkloadKind "deployment") (eq $normalizedWorkloadKind "statefulset")) -}}
{{- fail (printf "workload.kind must be one of: Deployment, StatefulSet (got %q)" $workloadKind) -}}
{{- end -}}
{{- $databaseType := lower .Values.database.type -}}
{{- if not (or (eq $databaseType "sqlite") (eq $databaseType "postgresql") (eq $databaseType "mysql")) -}}
{{- fail "database.type must be one of: sqlite, postgresql, mysql" -}}
{{- end -}}
{{- if .Values.ingress.enabled -}}
  {{- if not .Values.ingress.hosts -}}
  {{- fail "ingress.hosts must contain at least one host when ingress.enabled=true" -}}
  {{- end -}}
  {{- range $index, $host := .Values.ingress.hosts -}}
    {{- if not $host.host -}}
    {{- fail (printf "ingress.hosts[%d].host is required when ingress.enabled=true" $index) -}}
    {{- end -}}
    {{- if not $host.paths -}}
    {{- fail (printf "ingress.hosts[%d].paths must contain at least one path when ingress.enabled=true" $index) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- if .Values.httpRoute.enabled -}}
  {{- if not .Values.httpRoute.parentRefs -}}
  {{- fail "httpRoute.parentRefs must contain at least one parent reference when httpRoute.enabled=true" -}}
  {{- end -}}
  {{- if not .Values.httpRoute.hostnames -}}
  {{- fail "httpRoute.hostnames must contain at least one hostname when httpRoute.enabled=true" -}}
  {{- end -}}
{{- end -}}
{{- end -}}
