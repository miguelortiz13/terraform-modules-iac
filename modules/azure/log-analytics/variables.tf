variable "name" {
  description = "Nombre del workspace (usa `module.naming.names.log_analytics_workspace`)."
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

variable "retention_in_days" {
  description = "Retención en días. 30 está incluido sin costo adicional."
  type        = number
  default     = 30

  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 730
    error_message = "retention_in_days debe estar entre 30 y 730."
  }
}

variable "daily_quota_gb" {
  description = "Tope diario de ingesta en GB. Corta la ingesta al llegar al tope: es la protección principal contra facturas sorpresa. `-1` desactiva el tope."
  type        = number
  default     = 0.15
}

variable "application_insights_name" {
  description = "Si se indica, crea un Application Insights basado en este workspace."
  type        = string
  default     = null
}
