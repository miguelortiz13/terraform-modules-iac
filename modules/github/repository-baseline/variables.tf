variable "repository" {
  description = "Nombre del repositorio (sin dueño); el dueño lo da el proveedor `github`."
  type        = string
}

variable "protect_default_branch" {
  description = "Crea la regla de la rama principal. Con GitHub Free solo funciona en repos públicos; en privados, déjalo en false."
  type        = bool
  default     = true
}

variable "required_checks" {
  description = "Checks que deben pasar para mergear. Solo los que corren en TODOS los PRs: uno con filtro de rutas dejaría bloqueados los PRs que no lo disparan."
  type        = list(string)
  default     = []
}

variable "admin_bypass" {
  description = "Permite que un admin salte la regla al mergear un PR (`gh pr merge --admin`), p. ej. para los PRs de release-please, que no disparan CI. Nunca permite push directo."
  type        = bool
  default     = true
}
