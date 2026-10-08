mock_provider "azurerm" {}

variables {
  name                         = "ca-demo-dev-eus2-api"
  resource_group_name          = "rg-demo-dev-eus2"
  container_app_environment_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.App/managedEnvironments/cae"
  tags                         = {}
}

run "escala_a_cero_por_defecto" {
  command = plan

  variables {
    ingress = { target_port = 8080 }
  }

  assert {
    condition     = azurerm_container_app.this.template[0].min_replicas == 0
    error_message = "Por defecto la app debe escalar a cero."
  }

  assert {
    condition     = azurerm_container_app.this.ingress[0].allow_insecure_connections == false
    error_message = "El ingress no debe aceptar HTTP plano por defecto."
  }
}

run "secretos_y_key_vault" {
  command = plan

  variables {
    identity_ids      = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id"]
    secrets           = { "jwt-secret" = "valor" }
    key_vault_secrets = { "db-conn" = "https://kv-demo.vault.azure.net/secrets/db-conn" }
    secret_env        = { JWT_SECRET = "jwt-secret", DB_CONNECTION = "db-conn" }
  }

  assert {
    condition     = length(azurerm_container_app.this.secret) == 2
    error_message = "Debe declarar el secreto directo y el de Key Vault."
  }
}

run "key_vault_sin_identidad" {
  command = plan

  variables {
    key_vault_secrets = { "db-conn" = "https://kv-demo.vault.azure.net/secrets/db-conn" }
  }

  expect_failures = [azurerm_container_app.this]
}
