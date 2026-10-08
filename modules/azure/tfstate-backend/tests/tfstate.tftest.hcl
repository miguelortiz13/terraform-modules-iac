mock_provider "azurerm" {
  mock_resource "azurerm_storage_account" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/sttfstateplat01"
    }
  }

  mock_resource "azurerm_storage_container" {
    defaults = {
      id = "https://sttfstate.blob.core.windows.net/proyecto"
    }
  }
}

variables {
  storage_account_name = "sttfstateplat01"
  resource_group_name  = "rg-platform-prod-eus2"
  location             = "eastus2"
  tags                 = {}
  projects = {
    nexpos   = { writers = ["11111111-1111-1111-1111-111111111111"] }
    cloudops = { writers = ["22222222-2222-2222-2222-222222222222"], readers = ["33333333-3333-3333-3333-333333333333"] }
  }
}

run "rbac_por_contenedor" {
  command = apply

  assert {
    condition     = length(azurerm_role_assignment.writer) == 2 && length(azurerm_role_assignment.reader) == 1
    error_message = "Cada proyecto debe tener sus propios permisos de escritura y lectura."
  }

  assert {
    condition     = output.backend_configs["nexpos"].use_azuread_auth
    error_message = "El backend debe autenticarse con Entra ID."
  }
}
