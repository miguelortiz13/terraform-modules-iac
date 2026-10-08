variable "name" {
  description = "Nombre (3-24; usa `module.naming.names.key_vault`)."
  type        = string
}

variable "resource_group_name" {
  description = "Grupo de recursos."
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

variable "tenant_id" {
  description = "Tenant de Entra ID."
  type        = string
}

variable "purge_protection_enabled" {
  description = "Impide purgar el vault durante la retención. Recomendado en prod; en dev/lab impide reutilizar el nombre tras un destroy."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Días de retención tras borrar (7-90). No se puede cambiar después de crear el vault."
  type        = number
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days debe estar entre 7 y 90."
  }
}

variable "public_network_access_enabled" {
  description = "Acceso por red pública. Sin private endpoints (costo extra) debe quedar en true."
  type        = bool
  default     = true
}

variable "role_assignments" {
  description = <<-EOT
    Roles RBAC sobre el vault. La clave es un nombre estable.
    Roles habituales: `Key Vault Secrets User` (leer), `Key Vault Secrets Officer` (gestionar), `Key Vault Administrator`.
  EOT
  type = map(object({
    principal_id         = string
    role_definition_name = string
    principal_type       = optional(string, "ServicePrincipal")
  }))
  default = {}
}
