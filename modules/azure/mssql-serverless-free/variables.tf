variable "server_name" {
  description = "Nombre del servidor lógico (global; usa `module.naming.names.mssql_server`)."
  type        = string
}

variable "database_name" {
  description = "Nombre de la base (usa `module.naming.names.mssql_database`)."
  type        = string
}

variable "resource_group_name" {
  description = "Grupo de recursos."
  type        = string
}

variable "location" {
  description = "Región. La oferta gratuita no está en todas las regiones: si `eastus2` no tiene capacidad, prueba `centralus` o `westus2`."
  type        = string
}

variable "tags" {
  description = "Etiquetas."
  type        = map(string)
}

variable "entra_admin" {
  description = "Administrador de Entra ID del servidor (usuario o grupo). La autenticación SQL con contraseña queda desactivada."
  type = object({
    login_username = string
    object_id      = string
  })
}

variable "allow_azure_services" {
  description = "Regla 0.0.0.0: admite tráfico originado en Azure (Container Apps de consumo no tiene IP de salida fija). El acceso sigue exigiendo un token de Entra ID."
  type        = bool
  default     = true
}

variable "firewall_rules" {
  description = "Reglas adicionales: nombre => { start_ip, end_ip }."
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}

variable "free_limit_exhaustion_behavior" {
  description = "Qué hacer al agotar el cupo gratis del mes: `AutoPause` (USD 0, la base se pausa hasta el mes siguiente) o `BillOverUsage` (sigue y factura el excedente)."
  type        = string
  default     = "AutoPause"

  validation {
    condition     = contains(["AutoPause", "BillOverUsage"], var.free_limit_exhaustion_behavior)
    error_message = "Debe ser AutoPause o BillOverUsage."
  }
}

variable "max_vcores" {
  description = "vCores máximos del serverless (1-4 dentro de la oferta gratuita)."
  type        = number
  default     = 1
}
