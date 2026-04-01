{{- define "affine.validate" -}}
{{- if empty .Values.app.externalUrl -}}
{{- fail "app.externalUrl is required" -}}
{{- end -}}
{{- if ne .Values.app.type "selfhosted" -}}
{{- fail "app.type must be selfhosted" -}}
{{- end -}}
{{- if and .Values.db.indexer.enabled (empty .Values.db.indexer.endpoint) -}}
{{- fail "db.indexer.endpoint is required when db.indexer.enabled is true" -}}
{{- end -}}
{{- if .Values.front.ingress.enabled -}}
  {{- if or (empty .Values.front.ingress.hosts) (eq (len .Values.front.ingress.hosts) 0) -}}
  {{- fail "front.ingress.hosts must contain at least one host when front.ingress.enabled is true" -}}
  {{- end -}}
{{- end -}}
{{- if .Values.front.httpRoute.enabled -}}
  {{- if or (empty .Values.front.httpRoute.parentRefs) (eq (len .Values.front.httpRoute.parentRefs) 0) -}}
  {{- fail "front.httpRoute.parentRefs must contain at least one entry when front.httpRoute.enabled is true" -}}
  {{- end -}}
  {{- if or (empty .Values.front.httpRoute.hostnames) (eq (len .Values.front.httpRoute.hostnames) 0) -}}
  {{- fail "front.httpRoute.hostnames must contain at least one hostname when front.httpRoute.enabled is true" -}}
  {{- end -}}
{{- end -}}
{{- end -}}
