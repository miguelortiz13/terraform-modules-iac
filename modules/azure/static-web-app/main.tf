resource "azurerm_static_web_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_tier            = var.sku
  sku_size            = var.sku
  app_settings        = var.app_settings
  tags                = var.tags

  # Se despliega desde GitHub Actions con el token de despliegue; Azure
  # registra el repositorio en el primer despliegue y Terraform no lo gestiona.
  lifecycle {
    ignore_changes = [repository_url, repository_branch]
  }
}
