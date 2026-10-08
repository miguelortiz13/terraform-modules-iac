variable "name" {
  description = "Nombre (usa `module.naming.names.container_app_environment`)."
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

variable "log_analytics_workspace_id" {
  description = "Workspace para los logs de las apps. `null` = sin Log Analytics (USD 0; los logs se ven en vivo con `az containerapp logs show`)."
  type        = string
  default     = null
}

variable "infrastructure_subnet_id" {
  description = "Subred para integrar el entorno en una VNet (mínimo /23 en entornos solo de consumo). `null` = red administrada por Azure, sin costo."
  type        = string
  default     = null
}

variable "storages" {
  description = "Recursos compartidos de Azure Files montables por las apps. La clave es el nombre del storage dentro del entorno."
  type = map(object({
    account_name = string
    share_name   = string
    access_mode  = optional(string, "ReadWrite")
  }))
  default = {}
}

variable "storage_access_keys" {
  description = "Claves de las cuentas de `storages`, con la misma clave del mapa."
  type        = map(string)
  default     = {}
  sensitive   = true
}
