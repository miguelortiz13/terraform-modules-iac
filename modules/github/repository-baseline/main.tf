# Base mínima de un repositorio: alertas y actualizaciones de seguridad de
# Dependabot y protección de la rama principal. No gestiona el repositorio en
# sí (descripción, topics, visibilidad), así que no pisa nada de eso.

locals {
  # IDs fijos de GitHub: el rol "admin" de repositorio y la app de GitHub Actions.
  admin_role_id         = 5
  github_actions_app_id = 15368
}

# También activa el Dependency graph, que necesita dependency-review.
resource "github_repository_vulnerability_alerts" "this" {
  repository = var.repository
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "this" {
  repository = var.repository
  enabled    = true

  depends_on = [github_repository_vulnerability_alerts.this]
}

resource "github_repository_ruleset" "default_branch" {
  count = var.protect_default_branch ? 1 : 0

  name        = "rama-principal"
  repository  = var.repository
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  dynamic "bypass_actors" {
    for_each = var.admin_bypass ? [1] : []
    content {
      actor_id    = local.admin_role_id
      actor_type  = "RepositoryRole"
      bypass_mode = "pull_request"
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    # Todo cambio entra por PR. Sin aprobaciones obligatorias: con un solo
    # mantenedor nadie podría aprobar sus propios PRs.
    pull_request {
      required_approving_review_count = 0
    }

    dynamic "required_status_checks" {
      for_each = length(var.required_checks) > 0 ? [1] : []
      content {
        strict_required_status_checks_policy = false

        dynamic "required_check" {
          for_each = toset(var.required_checks)
          content {
            context        = required_check.value
            integration_id = local.github_actions_app_id
          }
        }
      }
    }
  }
}
