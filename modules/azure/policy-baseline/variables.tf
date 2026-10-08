variable "management_group_id" {
  description = "Management group donde se asigna la línea base (se hereda a todas sus suscripciones)."
  type        = string
}

variable "name_prefix" {
  description = "Prefijo corto de los nombres de asignación (máximo 24 caracteres en total por asignación)."
  type        = string
  default     = "base"
}

variable "mode" {
  description = <<-EOT
    `audit`: solo reporta incumplimientos (recomendado al empezar, no rompe despliegues).
    `enforce`: bloquea los recursos que incumplen.
  EOT
  type        = string
  default     = "audit"

  validation {
    condition     = contains(["audit", "enforce"], var.mode)
    error_message = "mode debe ser audit o enforce."
  }
}

variable "allowed_locations" {
  description = "Regiones permitidas para recursos y grupos de recursos. `global` se agrega siempre."
  type        = list(string)
}

variable "required_tags" {
  description = "Etiquetas obligatorias en los grupos de recursos. Los recursos las heredan del grupo si les faltan."
  type        = list(string)
  default     = ["Project", "Environment", "Owner", "ManagedBy"]
}

variable "allowed_vm_skus" {
  description = "Tamaños de VM permitidos. Lista vacía = no se restringe."
  type        = list(string)
  default     = ["Standard_B1s", "Standard_B1ms", "Standard_B2s", "Standard_B2ats_v2", "Standard_B2pts_v2", "Standard_B2als_v2", "Standard_B2s_v2"]
}

variable "denied_resource_types" {
  description = "Tipos de recurso caros que no se permiten sin una excepción explícita."
  type        = list(string)
  default = [
    "Microsoft.Network/azureFirewalls",
    "Microsoft.Network/applicationGateways",
    "Microsoft.Network/virtualNetworkGateways",
    "Microsoft.Network/expressRouteCircuits",
    "Microsoft.Network/bastionHosts",
    "Microsoft.Network/ddosProtectionPlans",
    "Microsoft.Databricks/workspaces",
    "Microsoft.Synapse/workspaces",
    "Microsoft.Kusto/clusters",
    "Microsoft.AVS/privateClouds",
  ]
}

variable "identity_location" {
  description = "Región de la identidad que usa la política de herencia de etiquetas."
  type        = string
}
