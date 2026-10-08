variable "alias" {
  description = "Alias ARM de la suscripción (identificador estable, sin espacios). Convención: `sub-<proyecto>`."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,63}$", var.alias))
    error_message = "alias: 3-63 caracteres en minúsculas, dígitos y guiones."
  }
}

variable "display_name" {
  description = "Nombre visible de la suscripción."
  type        = string
}

variable "billing_scope_id" {
  description = "Sección de factura MCA donde se crea (`/providers/Microsoft.Billing/billingAccounts/.../billingProfiles/.../invoiceSections/...`). Déjalo en null para adoptar una existente con `subscription_id`."
  type        = string
  default     = null
}

variable "subscription_id" {
  description = "ID de una suscripción existente para gestionarla (renombrar, etiquetar, ubicar) sin crear una nueva."
  type        = string
  default     = null
}

variable "workload" {
  description = "`Production` o `DevTest`."
  type        = string
  default     = "Production"

  validation {
    condition     = contains(["Production", "DevTest"], var.workload)
    error_message = "workload debe ser Production o DevTest."
  }
}

variable "management_group_name" {
  description = "Nombre (no ID) del management group donde se ubica la suscripción, p. ej. `mg-workloads`. `null` = sin cambiar. Se pide el nombre porque se conoce en el plan aunque el grupo se cree en el mismo apply."
  type        = string
  default     = null
}

variable "tags" {
  description = "Etiquetas de la suscripción."
  type        = map(string)
  default     = {}
}
