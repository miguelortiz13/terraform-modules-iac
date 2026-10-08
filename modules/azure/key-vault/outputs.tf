output "id" {
  description = "ID del vault."
  value       = azurerm_key_vault.this.id
}

output "name" {
  description = "Nombre del vault."
  value       = azurerm_key_vault.this.name
}

output "vault_uri" {
  description = "URI del vault (para referencias a secretos desde Container Apps o Functions)."
  value       = azurerm_key_vault.this.vault_uri
}
