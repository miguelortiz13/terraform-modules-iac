output "id" {
  description = "ID del workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_id" {
  description = "GUID del workspace (customer ID)."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "primary_shared_key" {
  description = "Clave del workspace (necesaria para Container Apps)."
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Cadena de conexión de Application Insights, si se creó."
  value       = one(azurerm_application_insights.this[*].connection_string)
  sensitive   = true
}
