output "id" {
  description = "ID de la identidad."
  value       = azurerm_user_assigned_identity.this.id
}

output "principal_id" {
  description = "Object ID del service principal de la identidad."
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "client_id" {
  description = "Client ID (para `AZURE_CLIENT_ID` en GitHub Actions o en la app)."
  value       = azurerm_user_assigned_identity.this.client_id
}

output "tenant_id" {
  description = "Tenant de la identidad."
  value       = azurerm_user_assigned_identity.this.tenant_id
}
