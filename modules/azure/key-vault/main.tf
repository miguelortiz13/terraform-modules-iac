# Key Vault con autorización RBAC (no access policies), borrado suave y
# protección de purga. El SKU standard cobra por operación: unos centavos al mes.

resource "azurerm_key_vault" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled    = true
  purge_protection_enabled      = var.purge_protection_enabled
  soft_delete_retention_days    = var.soft_delete_retention_days
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags

  # Azure no permite cambiar la retención después de crear el vault.
  lifecycle {
    ignore_changes = [soft_delete_retention_days]
  }
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  scope                = azurerm_key_vault.this.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
  principal_type       = each.value.principal_type
}
