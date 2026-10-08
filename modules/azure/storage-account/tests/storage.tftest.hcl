mock_provider "azurerm" {}

variables {
  name                = "stdemodeveus2abc123"
  resource_group_name = "rg-demo-dev-eus2"
  location            = "eastus2"
  tags                = {}
}

run "valores_seguros_por_defecto" {
  command = plan

  assert {
    condition = (
      azurerm_storage_account.this.min_tls_version == "TLS1_2" &&
      azurerm_storage_account.this.allow_nested_items_to_be_public == false &&
      azurerm_storage_account.this.shared_access_key_enabled == false
    )
    error_message = "La cuenta debe nacer con TLS 1.2, sin acceso anónimo y sin claves de cuenta."
  }
}

run "nombre_invalido" {
  command = plan

  variables {
    name = "St-Demo"
  }

  expect_failures = [var.name]
}
