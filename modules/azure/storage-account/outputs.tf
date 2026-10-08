output "id" {
  description = "ID de la cuenta."
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "Nombre de la cuenta."
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "Endpoint de blobs."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_access_key" {
  description = "Clave primaria (solo si `shared_access_key_enabled = true`)."
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "container_ids" {
  description = "IDs de los contenedores por nombre."
  value       = { for k, c in azurerm_storage_container.this : k => c.id }
}

output "file_share_names" {
  description = "Nombres de los recursos compartidos de Azure Files."
  value       = [for s in azurerm_storage_share.this : s.name]
}
