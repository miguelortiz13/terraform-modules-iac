variable "name" {
  description = "Nombre de la cuenta (p. ej. `nexpos`). Es el equivalente a una suscripción por proyecto en Azure."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 50
    error_message = "name debe tener entre 1 y 50 caracteres."
  }
}

variable "email" {
  description = "Correo del usuario raíz de la cuenta. Debe ser único en AWS; con Gmail sirve `usuario+aws-<proyecto>@gmail.com`."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.email))
    error_message = "email no es un correo válido."
  }
}

variable "parent_id" {
  description = "OU (`ou-...`) o raíz (`r-...`) donde se ubica la cuenta. De la OU dependen las SCP que la protegen."
  type        = string

  validation {
    condition     = can(regex("^(r-[0-9a-z]{4,32}|ou-[0-9a-z]{4,32}-[a-z0-9]{8,32})$", var.parent_id))
    error_message = "parent_id debe ser el ID de una OU (ou-...) o de la raíz (r-...)."
  }
}

variable "admin_role_name" {
  description = "Rol que AWS crea en la cuenta nueva para administrarla desde la cuenta de administración."
  type        = string
  default     = "OrganizationAccountAccessRole"
}

variable "close_on_deletion" {
  description = "Si `true`, `terraform destroy` cierra la cuenta (queda 90 días suspendida y cuenta para el cupo de cierres). Si `false`, solo la saca de la organización, lo que exige que tenga medio de pago propio."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Etiquetas de la cuenta en Organizations."
  type        = map(string)
  default     = {}
}
