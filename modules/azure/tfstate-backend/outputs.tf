output "storage_account_id" {
  description = "ID de la cuenta de estados."
  value       = module.storage.id
}

output "storage_account_name" {
  description = "Nombre de la cuenta de estados."
  value       = module.storage.name
}

output "backend_configs" {
  description = "Configuración `backend \"azurerm\"` lista para cada proyecto."
  value = {
    for project in keys(var.projects) : project => {
      resource_group_name  = var.resource_group_name
      storage_account_name = module.storage.name
      container_name       = project
      key                  = "terraform.tfstate"
      use_azuread_auth     = true
    }
  }
}
