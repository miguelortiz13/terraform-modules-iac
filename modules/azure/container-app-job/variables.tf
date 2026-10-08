variable "name" {
  description = "Nombre (usa `module.naming.names.container_app_job`; máximo 32 caracteres)."
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

variable "location" {
  description = "Región (la misma del entorno)."
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

variable "cron_expression" {
  description = "Horario en cron (UTC). `null` = job manual (se lanza con `az containerapp job start`)."
  type        = string
  default     = null
}

variable "image" {
  description = "Imagen inicial; el pipeline de la aplicación despliega las siguientes y Terraform ignora este valor."
  type        = string
  default     = "mcr.microsoft.com/k8se/quickstart-jobs:latest"
}

variable "cpu" {
  description = "vCPU por ejecución."
  type        = number
  default     = 0.5
}

variable "memory" {
  description = "Memoria por ejecución (el doble de la CPU)."
  type        = string
  default     = "1Gi"
}

variable "replica_timeout_in_seconds" {
  description = "Tiempo máximo de una ejecución."
  type        = number
  default     = 1800
}

variable "replica_retry_limit" {
  description = "Reintentos si la ejecución falla."
  type        = number
  default     = 1
}

variable "command" {
  description = "Comando del contenedor."
  type        = list(string)
  default     = null
}

variable "args" {
  description = "Argumentos del contenedor."
  type        = list(string)
  default     = null
}

variable "env" {
  description = "Variables de entorno en claro."
  type        = map(string)
  default     = {}
}

variable "secret_env" {
  description = "Variable de entorno => nombre del secreto."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secretos con valor directo."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "key_vault_secrets" {
  description = "Secretos de Key Vault: nombre => URI del secreto."
  type        = map(string)
  default     = {}
}

variable "identity_ids" {
  description = "Identidades asignadas por el usuario. La primera lee Key Vault y el registro."
  type        = list(string)
  default     = []
}

variable "registry" {
  description = "Registro privado (`null` para imágenes públicas)."
  type = object({
    server      = string
    identity_id = optional(string)
  })
  default = null
}

variable "volumes" {
  description = "Volúmenes de Azure Files: nombre del storage del entorno => ruta de montaje."
  type        = map(string)
  default     = {}
}
