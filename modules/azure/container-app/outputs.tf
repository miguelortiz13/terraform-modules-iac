output "id" {
  description = "ID de la Container App."
  value       = azurerm_container_app.this.id
}

output "name" {
  description = "Nombre de la Container App."
  value       = azurerm_container_app.this.name
}

output "fqdn" {
  description = "FQDN de la revisión activa (null sin ingress)."
  value       = try(azurerm_container_app.this.ingress[0].fqdn, null)
}

output "url" {
  description = "URL HTTPS de la app (null sin ingress)."
  value       = try("https://${azurerm_container_app.this.ingress[0].fqdn}", null)
}

output "outbound_ip_addresses" {
  description = "IPs de salida (útil para reglas de firewall de bases externas)."
  value       = azurerm_container_app.this.outbound_ip_addresses
}
