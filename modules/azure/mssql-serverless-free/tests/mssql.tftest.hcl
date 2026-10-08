mock_provider "azurerm" {
  mock_resource "azurerm_mssql_server" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Sql/servers/sql-demo"
    }
  }
}

mock_provider "azapi" {}

variables {
  server_name         = "sql-demo-dev-eus2-abc123"
  database_name       = "sqldb-demo-dev-eus2"
  resource_group_name = "rg-demo-dev-eus2"
  location            = "eastus2"
  tags                = {}
  entra_admin         = { login_username = "admin@example.com", object_id = "11111111-1111-1111-1111-111111111111" }
}

run "solo_entra_y_gratis" {
  command = apply

  assert {
    condition     = azurerm_mssql_server.this.azuread_administrator[0].azuread_authentication_only
    error_message = "El servidor debe aceptar solo autenticación de Entra ID."
  }

  assert {
    condition     = azapi_resource.database.body.properties.useFreeLimit && azapi_resource.database.body.properties.freeLimitExhaustionBehavior == "AutoPause"
    error_message = "La base debe usar la oferta gratuita con AutoPause por defecto."
  }
}
