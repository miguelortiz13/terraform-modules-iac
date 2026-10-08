variable "subscription_id" {
  description = "Suscripción del proyecto."
  type        = string
}

variable "location" {
  description = "Región principal."
  type        = string
  default     = "eastus2"
}

variable "owner" {
  description = "Responsable (etiqueta Owner y alertas de presupuesto)."
  type        = string
}

variable "repository" {
  description = "Repositorio del proyecto (owner/repo)."
  type        = string
}

variable "sql_admin" {
  description = "Administrador de Entra ID de la base."
  type = object({
    login_username = string
    object_id      = string
  })
}
