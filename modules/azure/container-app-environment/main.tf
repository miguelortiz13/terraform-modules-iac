# Entorno de Container Apps solo de consumo (sin workload profiles).
#
# Un entorno con workload profiles cobra una tarifa de gestión por hora
# aunque no haya apps corriendo; el de consumo no tiene costo fijo y las apps
# reciben el cupo gratis mensual de la suscripción (180.000 vCPU-s,
# 360.000 GiB-s y 2 millones de solicitudes).

resource "azurerm_container_app_environment" "this" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  log_analytics_workspace_id = var.log_analytics_workspace_id
  logs_destination           = var.log_analytics_workspace_id == null ? null : "log-analytics"
  infrastructure_subnet_id   = var.infrastructure_subnet_id
  tags                       = var.tags
}

resource "azurerm_container_app_environment_storage" "this" {
  for_each = var.storages

  name                         = each.key
  container_app_environment_id = azurerm_container_app_environment.this.id
  account_name                 = each.value.account_name
  share_name                   = each.value.share_name
  access_key                   = var.storage_access_keys[each.key]
  access_mode                  = each.value.access_mode
}
