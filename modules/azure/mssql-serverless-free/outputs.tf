output "server_id" {
  description = "ID del servidor."
  value       = azurerm_mssql_server.this.id
}

output "server_fqdn" {
  description = "FQDN del servidor."
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "database_id" {
  description = "ID de la base."
  value       = azapi_resource.database.id
}

output "database_name" {
  description = "Nombre de la base."
  value       = azapi_resource.database.name
}

output "connection_hint" {
  description = "Cadena de conexión de referencia con autenticación de identidad administrada (sin contraseña)."
  value       = "Server=tcp:${azurerm_mssql_server.this.fully_qualified_domain_name},1433;Database=${azapi_resource.database.name};Authentication=Active Directory Default;Encrypt=True;"
}
