# Storage account con valores seguros por defecto: TLS 1.2, sin acceso
# anónimo a blobs, solo HTTPS, claves de cuenta desactivadas y borrado suave.

resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = var.replication_type
  access_tier              = "Hot"

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = var.shared_access_key_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  default_to_oauth_authentication = true

  dynamic "blob_properties" {
    for_each = var.blob_soft_delete_days > 0 || var.versioning_enabled ? [1] : []
    content {
      versioning_enabled = var.versioning_enabled

      dynamic "delete_retention_policy" {
        for_each = var.blob_soft_delete_days > 0 ? [1] : []
        content {
          days = var.blob_soft_delete_days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = var.blob_soft_delete_days > 0 ? [1] : []
        content {
          days = var.blob_soft_delete_days
        }
      }
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "this" {
  for_each = var.containers

  name                  = each.value
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_storage_share" "this" {
  for_each = var.file_shares

  name               = each.key
  storage_account_id = azurerm_storage_account.this.id
  quota              = each.value
}

resource "azurerm_storage_table" "this" {
  for_each = var.tables

  name               = each.value
  storage_account_id = azurerm_storage_account.this.id
}
