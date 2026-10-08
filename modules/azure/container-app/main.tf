# Container App de consumo.
#
# Contrato con los proyectos: Terraform crea y configura la app; la imagen la
# despliega el pipeline de la aplicación. Por eso se ignoran los cambios de
# imagen después de crearla (ver docs/standards/despliegue.md).

locals {
  identity_type   = length(var.identity_ids) > 0 ? "UserAssigned" : null
  first_identity  = try(var.identity_ids[0], null)
  secret_names    = nonsensitive(toset(keys(var.secrets)))
  registry_secret = "registry-password"
  probe_port      = try(var.ingress.target_port, null)
}

resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode                = "Single"
  max_inactive_revisions       = var.max_inactive_revisions
  tags                         = var.tags

  dynamic "identity" {
    for_each = local.identity_type == null ? [] : [1]
    content {
      type         = local.identity_type
      identity_ids = var.identity_ids
    }
  }

  dynamic "secret" {
    for_each = local.secret_names
    content {
      name  = secret.value
      value = var.secrets[secret.value]
    }
  }

  dynamic "secret" {
    for_each = var.key_vault_secrets
    content {
      name                = secret.key
      key_vault_secret_id = secret.value
      identity            = local.first_identity
    }
  }

  dynamic "secret" {
    for_each = try(var.registry.username, null) != null ? [1] : []
    content {
      name  = local.registry_secret
      value = var.registry_password
    }
  }

  dynamic "registry" {
    for_each = var.registry == null ? [] : [var.registry]
    content {
      server               = registry.value.server
      identity             = registry.value.identity_id
      username             = registry.value.username
      password_secret_name = registry.value.username == null ? null : local.registry_secret
    }
  }

  dynamic "ingress" {
    for_each = var.ingress == null ? [] : [var.ingress]
    content {
      external_enabled           = ingress.value.external
      target_port                = ingress.value.target_port
      transport                  = ingress.value.transport
      allow_insecure_connections = ingress.value.allow_insecure

      traffic_weight {
        latest_revision = true
        percentage      = 100
      }
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    dynamic "http_scale_rule" {
      for_each = var.ingress == null ? [] : [1]
      content {
        name                = "http"
        concurrent_requests = tostring(var.concurrent_requests)
      }
    }

    dynamic "volume" {
      for_each = var.volumes
      content {
        name         = volume.key
        storage_type = "AzureFile"
        storage_name = volume.key
      }
    }

    container {
      name    = "main"
      image   = var.image
      cpu     = var.cpu
      memory  = var.memory
      command = var.command
      args    = var.args

      dynamic "env" {
        for_each = var.env
        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "env" {
        for_each = var.secret_env
        content {
          name        = env.key
          secret_name = env.value
        }
      }

      dynamic "volume_mounts" {
        for_each = var.volumes
        content {
          name = volume_mounts.key
          path = volume_mounts.value
        }
      }

      dynamic "startup_probe" {
        for_each = var.health_probe_path != null && local.probe_port != null ? [1] : []
        content {
          transport               = "HTTP"
          port                    = local.probe_port
          path                    = var.health_probe_path
          failure_count_threshold = 10
          interval_seconds        = 5
        }
      }

      dynamic "readiness_probe" {
        for_each = var.health_probe_path != null && local.probe_port != null ? [1] : []
        content {
          transport = "HTTP"
          port      = local.probe_port
          path      = var.health_probe_path
        }
      }

      dynamic "liveness_probe" {
        for_each = var.health_probe_path != null && local.probe_port != null ? [1] : []
        content {
          transport = "HTTP"
          port      = local.probe_port
          path      = var.health_probe_path
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [template[0].container[0].image]

    precondition {
      condition     = length(var.key_vault_secrets) == 0 || local.first_identity != null
      error_message = "key_vault_secrets requiere al menos una identidad en identity_ids."
    }

    precondition {
      condition     = var.max_replicas >= var.min_replicas
      error_message = "max_replicas debe ser mayor o igual que min_replicas."
    }
  }
}
