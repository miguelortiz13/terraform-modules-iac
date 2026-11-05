output "ruleset_id" {
  description = "ID de la regla de la rama principal (null si no se crea)."
  value       = try(github_repository_ruleset.default_branch[0].ruleset_id, null)
}
