output "id" {
  description = "ID de la Static Web App."
  value       = azurerm_static_web_app.this.id
}

output "default_host_name" {
  description = "Dominio por defecto (`*.azurestaticapps.net`)."
  value       = azurerm_static_web_app.this.default_host_name
}

output "url" {
  description = "URL HTTPS por defecto."
  value       = "https://${azurerm_static_web_app.this.default_host_name}"
}

output "api_key" {
  description = "Token de despliegue para `Azure/static-web-apps-deploy`. Guárdalo como secreto del entorno en GitHub."
  value       = azurerm_static_web_app.this.api_key
  sensitive   = true
}
