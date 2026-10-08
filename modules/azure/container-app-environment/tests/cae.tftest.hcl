mock_provider "azurerm" {}

variables {
  name                = "cae-demo-dev-eus2"
  resource_group_name = "rg-demo-dev-eus2"
  location            = "eastus2"
  tags                = {}
}

run "sin_logs_por_defecto" {
  command = plan

  assert {
    condition     = azurerm_container_app_environment.this.log_analytics_workspace_id == null
    error_message = "Por defecto el entorno no debe enviar logs a Log Analytics (costo)."
  }
}

run "con_azure_files" {
  command = plan

  variables {
    storages            = { data = { account_name = "stdemo", share_name = "data" } }
    storage_access_keys = { data = "clave" }
  }

  assert {
    condition     = azurerm_container_app_environment_storage.this["data"].access_mode == "ReadWrite"
    error_message = "Debe registrar el recurso compartido en el entorno."
  }
}
