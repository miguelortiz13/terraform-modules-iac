# Log Analytics con tope diario de ingesta.
#
# Los primeros 5 GB al mes por cuenta de facturación son gratis. Un tope de
# 0.15 GB/día (~4.5 GB/mes) mantiene un workspace dentro de ese cupo; si hay
# varios workspaces, reparte el cupo entre ellos.

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  daily_quota_gb      = var.daily_quota_gb
  tags                = var.tags
}

resource "azurerm_application_insights" "this" {
  count = var.application_insights_name == null ? 0 : 1

  name                = var.application_insights_name
  resource_group_name = var.resource_group_name
  location            = var.location
  workspace_id        = azurerm_log_analytics_workspace.this.id
  application_type    = "web"
  tags                = var.tags
}
