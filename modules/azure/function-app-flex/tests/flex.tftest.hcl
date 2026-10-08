mock_provider "azurerm" {
  mock_resource "azurerm_user_assigned_identity" {
    defaults = {
      id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id"
      principal_id = "11111111-1111-1111-1111-111111111111"
    }
  }
}

variables {
  name                  = "func-demo-dev-eus2-abcd"
  service_plan_name     = "asp-demo-dev-eus2"
  resource_group_name   = "rg-demo-dev-eus2"
  location              = "eastus2"
  tags                  = {}
  storage_account_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/stdemo"
  storage_blob_endpoint = "https://stdemo.blob.core.windows.net/"
  runtime_name          = "node"
  runtime_version       = "22"
}

run "sin_claves_de_cuenta" {
  command = plan

  assert {
    condition     = azurerm_function_app_flex_consumption.this.storage_authentication_type == "UserAssignedIdentity"
    error_message = "El paquete debe leerse con identidad administrada, no con claves."
  }

  assert {
    condition     = azurerm_service_plan.this.sku_name == "FC1"
    error_message = "El plan debe ser Flex Consumption."
  }
}
