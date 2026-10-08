variable "name" {
  description = "Nombre (usa `module.naming.names.static_web_app`)."
  type        = string
}

variable "resource_group_name" {
  description = "Grupo de recursos."
  type        = string
}

variable "location" {
  description = "Región de Static Web Apps. Solo algunas regiones la ofrecen (p. ej. `eastus2`, `centralus`, `westus2`, `westeurope`, `eastasia`)."
  type        = string
  default     = "eastus2"
}

variable "tags" {
  description = "Etiquetas."
  type        = map(string)
}

variable "sku" {
  description = "`Free` (USD 0) o `Standard` (~USD 9/mes: dominios con SSL propio adicional, autenticación personalizada y SLA)."
  type        = string
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard"], var.sku)
    error_message = "sku debe ser Free o Standard."
  }
}

variable "app_settings" {
  description = "Configuración de la app (solo aplica a las APIs administradas)."
  type        = map(string)
  default     = {}
}
