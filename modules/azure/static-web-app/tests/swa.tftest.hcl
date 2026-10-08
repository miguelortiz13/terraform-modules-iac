mock_provider "azurerm" {}

variables {
  name                = "stapp-demo-dev-eus2"
  resource_group_name = "rg-demo-dev-eus2"
  tags                = {}
}

run "gratis_por_defecto" {
  command = plan

  assert {
    condition     = azurerm_static_web_app.this.sku_tier == "Free"
    error_message = "El SKU por defecto debe ser Free."
  }
}
