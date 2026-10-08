output "id" {
  description = "ID de la Function App."
  value       = azurerm_function_app_flex_consumption.this.id
}

output "name" {
  description = "Nombre de la Function App."
  value       = azurerm_function_app_flex_consumption.this.name
}

output "default_hostname" {
  description = "Hostname por defecto."
  value       = azurerm_function_app_flex_consumption.this.default_hostname
}

output "principal_id" {
  description = "Object ID de la identidad asignada por el sistema (para dar permisos a la app)."
  value       = azurerm_function_app_flex_consumption.this.identity[0].principal_id
}
