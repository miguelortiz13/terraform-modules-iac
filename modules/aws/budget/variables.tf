variable "name" {
  description = "Nombre del presupuesto."
  type        = string
}

variable "amount" {
  description = "Monto mensual en USD."
  type        = number

  validation {
    condition     = var.amount > 0
    error_message = "amount debe ser mayor que 0."
  }
}

variable "linked_account_ids" {
  description = "Cuentas miembro cuyo gasto se mide. Vacío = toda la organización (o la cuenta donde se crea)."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for id in var.linked_account_ids : can(regex("^[0-9]{12}$", id))])
    error_message = "Cada cuenta debe ser un ID de 12 dígitos."
  }
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

variable "tags" {
  description = "Etiquetas del presupuesto."
  type        = map(string)
  default     = {}
}
