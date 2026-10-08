mock_provider "azurerm" {}

variables {
  name                         = "caj-demo-dev-eus2"
  resource_group_name          = "rg-demo-dev-eus2"
  location                     = "eastus2"
  container_app_environment_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.App/managedEnvironments/cae"
  tags                         = {}
}

run "programado" {
  command = plan

  variables {
    cron_expression = "0 6 * * *"
  }

  assert {
    condition     = length(azurerm_container_app_job.this.schedule_trigger_config) == 1 && length(azurerm_container_app_job.this.manual_trigger_config) == 0
    error_message = "Con cron debe crear un disparador programado."
  }
}

run "manual" {
  command = plan

  assert {
    condition     = length(azurerm_container_app_job.this.manual_trigger_config) == 1
    error_message = "Sin cron debe crear un disparador manual."
  }
}
