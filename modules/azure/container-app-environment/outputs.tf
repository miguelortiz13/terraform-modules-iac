output "id" {
  description = "ID del entorno."
  value       = azurerm_container_app_environment.this.id
}

output "default_domain" {
  description = "Dominio por defecto de las apps del entorno."
  value       = azurerm_container_app_environment.this.default_domain
}

output "static_ip_address" {
  description = "IP de entrada del entorno."
  value       = azurerm_container_app_environment.this.static_ip_address
}

output "storage_names" {
  description = "Nombres de los storages montables registrados en el entorno."
  value       = [for s in azurerm_container_app_environment_storage.this : s.name]
}
