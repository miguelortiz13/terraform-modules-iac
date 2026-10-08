variable "name" {
  description = "Nombre de la identidad (usa `module.naming.names.user_assigned_identity`)."
  type        = string
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

variable "role_assignments" {
  description = "Roles a asignar a la identidad. La clave es un nombre estable (no cambia el plan si se reordena)."
  type = map(object({
    scope                = string
    role_definition_name = string
  }))
  default = {}
}

variable "federated_credentials" {
  description = <<-EOT
    Credenciales federadas OIDC (sin secretos). La clave es el nombre de la credencial.
    Para GitHub Actions usa `subject = "repo:<owner>/<repo>:environment:<env>"`.
  EOT
  type = map(object({
    issuer   = optional(string, "https://token.actions.githubusercontent.com")
    subject  = string
    audience = optional(list(string), ["api://AzureADTokenExchange"])
  }))
  default = {}
}
