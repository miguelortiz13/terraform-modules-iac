mock_provider "github" {}

variables {
  repository = "demo"
}

run "repo_publico_con_checks" {
  command = plan

  variables {
    required_checks = ["ci / build", "security / gitleaks"]
  }

  assert {
    condition     = github_repository_vulnerability_alerts.this.enabled && github_repository_dependabot_security_updates.this.enabled
    error_message = "Debe activar alertas y actualizaciones de seguridad de Dependabot."
  }

  assert {
    condition     = length(github_repository_ruleset.default_branch) == 1
    error_message = "Debe proteger la rama principal."
  }

  assert {
    condition     = length(github_repository_ruleset.default_branch[0].rules[0].required_status_checks[0].required_check) == 2
    error_message = "Debe exigir los dos checks indicados."
  }

  assert {
    condition     = github_repository_ruleset.default_branch[0].rules[0].pull_request[0].required_approving_review_count == 0
    error_message = "Con un solo mantenedor no puede exigir aprobaciones."
  }

  assert {
    condition     = github_repository_ruleset.default_branch[0].bypass_actors[0].bypass_mode == "pull_request"
    error_message = "El admin solo puede saltar la regla al mergear un PR, nunca con push directo."
  }
}

run "sin_checks" {
  command = plan

  assert {
    condition     = length(github_repository_ruleset.default_branch[0].rules[0].required_status_checks) == 0
    error_message = "Sin checks no debe haber bloque required_status_checks."
  }
}

run "repo_privado_free" {
  command = plan

  variables {
    protect_default_branch = false
  }

  assert {
    condition     = length(github_repository_ruleset.default_branch) == 0 && github_repository_vulnerability_alerts.this.enabled
    error_message = "Sin protección de rama debe seguir activando las alertas."
  }
}
