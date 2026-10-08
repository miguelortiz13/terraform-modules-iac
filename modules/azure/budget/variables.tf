variable "name" {
  description = "Nombre del presupuesto."
  type        = string
}

variable "scope_id" {
  description = "ID del ámbito: una suscripción (`/subscriptions/<id>`) o un grupo de recursos."
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[0-9a-fA-F-]{36}(/resourceGroups/[^/]+)?$", var.scope_id))
    error_message = "scope_id debe ser /subscriptions/<id> o /subscriptions/<id>/resourceGroups/<nombre>."
  }
}

variable "scope_type" {
  description = "`subscription` o `resource_group`. Se declara aparte porque `scope_id` puede no conocerse hasta el apply (p. ej. una suscripción creada en el mismo apply)."
  type        = string
  default     = "subscription"

  validation {
    condition     = contains(["subscription", "resource_group"], var.scope_type)
    error_message = "scope_type debe ser subscription o resource_group."
  }
}

variable "amount" {
  description = "Monto mensual en la moneda de facturación (USD)."
  type        = number

  validation {
    condition     = var.amount > 0
    error_message = "amount debe ser mayor que 0."
  }
}

variable "start_date" {
  description = "Inicio del presupuesto (primer día de un mes, RFC3339). Por defecto, el mes en curso cuando se crea; después se ignora para no generar cambios cada mes."
  type        = string
  default     = null
}

variable "contact_emails" {
  description = "Correos que reciben las alertas."
  type        = list(string)

  validation {
    condition     = length(var.contact_emails) > 0
    error_message = "Debe haber al menos un correo de contacto."
  }
}

variable "actual_thresholds" {
  description = "Porcentajes del monto que disparan alerta por gasto real."
  type        = list(number)
  default     = [80, 100]
}

variable "forecast_thresholds" {
  description = "Porcentajes del monto que disparan alerta por gasto pronosticado. Avisan antes de que el gasto ocurra."
  type        = list(number)
  default     = [100]
}

variable "resource_group_filter" {
  description = "Solo para presupuestos de suscripción: limita el cálculo a estos grupos de recursos."
  type        = list(string)
  default     = []
}

variable "tag_filter" {
  description = "Solo para presupuestos de suscripción: limita el cálculo a recursos con estas etiquetas (p. ej. `{ Project = [\"nexpos\"] }`)."
  type        = map(list(string))
  default     = {}
}
