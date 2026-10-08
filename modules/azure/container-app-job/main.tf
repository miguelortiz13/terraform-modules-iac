# Container Apps Job: tareas programadas o manuales que solo consumen
# mientras corren (dentro del cupo gratis de la suscripción).

locals {
  first_identity = try(var.identity_ids[0], null)
  secret_names   = nonsensitive(toset(keys(var.secrets)))
}

resource "azurerm_container_app_job" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  container_app_environment_id = var.container_app_environment_id
  replica_timeout_in_seconds   = var.replica_timeout_in_seconds
  replica_retry_limit          = var.replica_retry_limit
  tags                         = var.tags

  dynamic "schedule_trigger_config" {
    for_each = var.cron_expression == null ? [] : [1]
    content {
      cron_expression          = var.cron_expression
      parallelism              = 1
      replica_completion_count = 1
    }
  }

  dynamic "manual_trigger_config" {
    for_each = var.cron_expression == null ? [1] : []
    content {
      parallelism              = 1
      replica_completion_count = 1
    }
  }

  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 ? [1] : []
    content {
      type         = "UserAssigned"
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

  dynamic "registry" {
    for_each = var.registry == null ? [] : [var.registry]
    content {
      server   = registry.value.server
      identity = registry.value.identity_id
    }
  }

  template {
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
    }
  }

  lifecycle {
    ignore_changes = [template[0].container[0].image]

    precondition {
      condition     = length(var.key_vault_secrets) == 0 || local.first_identity != null
      error_message = "key_vault_secrets requiere al menos una identidad en identity_ids."
    }
  }
}
