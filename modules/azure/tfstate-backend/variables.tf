variable "storage_account_name" {
  description = "Nombre de la cuenta de estados (3-24, minúsculas y dígitos)."
  type        = string
}

variable "resource_group_name" {
  description = "Grupo de recursos (existente)."
  type        = string
}

variable "location" {
  description = "Región de Azure."
  type        = string
}

variable "tags" {
  description = "Etiquetas."
  type        = map(string)
}

variable "projects" {
  description = <<-EOT
    Un contenedor de estados por proyecto. `writers` reciben `Storage Blob Data Contributor`
    solo sobre su contenedor (p. ej. la identidad OIDC del repo); `readers` reciben
    `Storage Blob Data Reader` (p. ej. cloudops-copilot para medir la cobertura de IaC).
  EOT
  type = map(object({
    writers = optional(list(string), [])
    readers = optional(list(string), [])
  }))
}

variable "account_readers" {
  description = "Principales con lectura sobre todos los contenedores."
  type        = list(string)
  default     = []
}

variable "lock_enabled" {
  description = "Bloqueo CanNotDelete sobre la cuenta. Perder los estados es la peor falla posible de IaC."
  type        = bool
  default     = true
}
