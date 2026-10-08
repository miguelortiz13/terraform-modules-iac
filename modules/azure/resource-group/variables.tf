variable "name" {
  description = "Nombre del grupo de recursos (usa `module.naming.names.resource_group`)."
  type        = string
}

variable "location" {
  description = "Región de Azure."
  type        = string
}

variable "tags" {
  description = "Etiquetas (usa `module.naming.tags`)."
  type        = map(string)
}

variable "lock_level" {
  description = "Bloqueo de gestión: `CanNotDelete`, `ReadOnly` o `null` para no bloquear. Recomendado `CanNotDelete` en prod."
  type        = string
  default     = null

  validation {
    condition     = var.lock_level == null || contains(["CanNotDelete", "ReadOnly"], coalesce(var.lock_level, "x"))
    error_message = "lock_level debe ser CanNotDelete, ReadOnly o null."
  }
}
