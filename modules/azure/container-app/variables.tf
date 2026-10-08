variable "name" {
  description = "Nombre (usa `module.naming.names.container_app`; máximo 32 caracteres)."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,30}[a-z0-9]$", var.name))
    error_message = "El nombre debe tener 2-32 caracteres en minúsculas, dígitos y guiones."
  }
}

variable "resource_group_name" {
  description = "Grupo de recursos."
  type        = string
}

variable "container_app_environment_id" {
  description = "ID del entorno de Container Apps."
  type        = string
}

variable "tags" {
  description = "Etiquetas."
  type        = map(string)
}

variable "image" {
  description = <<-EOT
    Imagen inicial. Después de crear la app, el pipeline de la aplicación despliega
    las versiones nuevas (`az containerapp update --image`) y Terraform ignora este valor.
  EOT
  type        = string
  default     = "mcr.microsoft.com/k8se/quickstart:latest"
}

variable "cpu" {
  description = "vCPU por réplica (0.25 a 4, en pasos de 0.25)."
  type        = number
  default     = 0.5
}

variable "memory" {
  description = "Memoria por réplica. Debe ser el doble de la CPU (0.25 -> 0.5Gi, 0.5 -> 1Gi, 1 -> 2Gi)."
  type        = string
  default     = "1Gi"
}

variable "min_replicas" {
  description = "Réplicas mínimas. 0 = escala a cero (USD 0 sin tráfico, con arranque en frío). 1 = siempre encendida (necesario para procesos en segundo plano)."
  type        = number
  default     = 0
}

variable "max_replicas" {
  description = "Réplicas máximas."
  type        = number
  default     = 1
}

variable "concurrent_requests" {
  description = "Solicitudes concurrentes por réplica antes de escalar."
  type        = number
  default     = 10
}

variable "ingress" {
  description = "Exposición HTTP. `null` = sin ingress (app interna sin endpoint)."
  type = object({
    external       = optional(bool, true)
    target_port    = number
    transport      = optional(string, "auto")
    allow_insecure = optional(bool, false)
  })
  default = null
}

variable "env" {
  description = "Variables de entorno en claro."
  type        = map(string)
  default     = {}
}

variable "secret_env" {
  description = "Variables de entorno que leen un secreto: nombre de variable => nombre del secreto (clave de `secrets` o `key_vault_secrets`)."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secretos con valor directo: nombre (minúsculas y guiones) => valor."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "key_vault_secrets" {
  description = "Secretos leídos de Key Vault con la identidad de la app: nombre => URI versionless del secreto."
  type        = map(string)
  default     = {}
}

variable "identity_ids" {
  description = "Identidades administradas asignadas por el usuario. La primera se usa para leer Key Vault y el registro."
  type        = list(string)
  default     = []
}

variable "registry" {
  description = "Registro privado de imágenes. `null` para imágenes públicas (p. ej. GHCR de repos públicos). Con `identity_id` se autentica sin contraseña (AcrPull)."
  type = object({
    server      = string
    identity_id = optional(string)
    username    = optional(string)
  })
  default = null
}

variable "registry_password" {
  description = "Contraseña o token del registro, solo si se usa `registry.username`."
  type        = string
  default     = null
  sensitive   = true
}

variable "command" {
  description = "Comando del contenedor (reemplaza el ENTRYPOINT)."
  type        = list(string)
  default     = null
}

variable "args" {
  description = "Argumentos del contenedor."
  type        = list(string)
  default     = null
}

variable "volumes" {
  description = "Volúmenes de Azure Files: nombre del storage del entorno => ruta de montaje."
  type        = map(string)
  default     = {}
}

variable "health_probe_path" {
  description = "Ruta HTTP para las sondas de arranque, disponibilidad y vida. `null` = sin sondas."
  type        = string
  default     = null
}

variable "max_inactive_revisions" {
  description = "Revisiones inactivas que se conservan para volver atrás."
  type        = number
  default     = 5
}
