mock_provider "azurerm" {}

variables {
  name                = "log-demo-dev-eus2"
  resource_group_name = "rg-demo-dev-eus2"
  location            = "eastus2"
  tags                = { Project = "demo" }
}

run "tope_diario_por_defecto" {
  command = plan

  assert {
    condition     = azurerm_log_analytics_workspace.this.daily_quota_gb == 0.15
    error_message = "El tope diario por defecto debe mantener el workspace dentro del cupo gratis."
  }

  assert {
    condition     = length(azurerm_application_insights.this) == 0
    error_message = "Application Insights es opcional."
  }
}

run "con_application_insights" {
  command = plan

  variables {
    application_insights_name = "appi-demo-dev-eus2"
  }

  assert {
    condition     = length(azurerm_application_insights.this) == 1
    error_message = "Debe crear Application Insights cuando se indica el nombre."
  }
}
