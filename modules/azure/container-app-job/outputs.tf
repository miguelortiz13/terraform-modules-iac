output "id" {
  description = "ID del job."
  value       = azurerm_container_app_job.this.id
}

output "name" {
  description = "Nombre del job."
  value       = azurerm_container_app_job.this.name
}
