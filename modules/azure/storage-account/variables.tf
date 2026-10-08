variable "name" {
  description = "Nombre (3-24, minúsculas y dígitos; usa `module.naming.names.storage_account`)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.name))
    error_message = "El nombre debe tener 3-24 caracteres en minúsculas y dígitos."
  }
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

variable "replication_type" {
  description = "Replicación. LRS es la opción de menor costo."
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "ZRS", "GRS", "RAGRS", "GZRS", "RAGZRS"], var.replication_type)
    error_message = "replication_type no válido."
  }
}

variable "shared_access_key_enabled" {
  description = "Permite autenticación con claves de cuenta. Desactívalo si todos los clientes usan Entra ID. Azure Files montado en Container Apps las necesita."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Acceso por red pública. Sin private endpoints (costo extra), debe quedar en true y protegerse con Entra ID y RBAC."
  type        = bool
  default     = true
}

variable "blob_soft_delete_days" {
  description = "Días de retención de blobs y contenedores borrados. 0 lo desactiva."
  type        = number
  default     = 7
}

variable "versioning_enabled" {
  description = "Versionado de blobs (recomendado para estados de Terraform)."
  type        = bool
  default     = false
}

variable "containers" {
  description = "Contenedores de blobs privados a crear."
  type        = set(string)
  default     = []
}

variable "file_shares" {
  description = "Recursos compartidos de Azure Files: nombre => cuota en GB."
  type        = map(number)
  default     = {}
}

variable "tables" {
  description = "Tablas a crear."
  type        = set(string)
  default     = []
}
