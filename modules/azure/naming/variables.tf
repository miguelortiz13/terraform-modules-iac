variable "project" {
  description = "Nombre corto del proyecto en minúsculas (p. ej. `nexpos`). Se usa en todos los nombres."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{1,14}$", var.project))
    error_message = "project: 2-15 caracteres, minúsculas y dígitos, empezando por letra (sin guiones: también se usa en nombres de storage)."
  }
}

variable "environment" {
  description = "Entorno del despliegue."
  type        = string

  validation {
    condition     = contains(["dev", "qa", "prod", "lab"], var.environment)
    error_message = "environment debe ser uno de: dev, qa, prod, lab."
  }
}

variable "location" {
  description = "Región de Azure (nombre ARM, p. ej. `eastus2`)."
  type        = string
}

variable "include_region" {
  description = "Incluye el código corto de la región en los nombres (`rg-nexpos-prod-eus2`). Desactívalo solo para conservar nombres heredados."
  type        = bool
  default     = true
}

variable "instance" {
  description = "Sufijo opcional para distinguir varias instancias del mismo tipo (p. ej. `api`, `01`)."
  type        = string
  default     = ""
}

variable "unique_seed" {
  description = "Semilla para el sufijo determinista de los nombres globalmente únicos (storage, key vault, sql). Recomendado: el ID de la suscripción."
  type        = string
}

variable "owner" {
  description = "Correo o alias del responsable. Va en la etiqueta `Owner`."
  type        = string
}

variable "repository" {
  description = "Repositorio que gestiona la infraestructura, en formato `owner/repo`. Va en la etiqueta `Repository`."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$", var.repository))
    error_message = "repository debe tener el formato owner/repo."
  }
}

variable "cost_center" {
  description = "Centro de costo para el showback. Por defecto, el nombre del proyecto."
  type        = string
  default     = null
}

variable "extra_tags" {
  description = "Etiquetas adicionales. No pueden sobrescribir las estándar."
  type        = map(string)
  default     = {}
}
