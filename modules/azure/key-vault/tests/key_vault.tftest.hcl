mock_provider "azurerm" {}

variables {
  name                = "kv-demo-dev-eus2-abcd"
  resource_group_name = "rg-demo-dev-eus2"
  location            = "eastus2"
  tags                = {}
  tenant_id           = "00000000-0000-0000-0000-000000000000"
}

run "rbac_y_purga_por_defecto" {
  command = plan

  assert {
    condition     = azurerm_key_vault.this.rbac_authorization_enabled && azurerm_key_vault.this.purge_protection_enabled
    error_message = "El vault debe usar RBAC y protección de purga por defecto."
  }
}
