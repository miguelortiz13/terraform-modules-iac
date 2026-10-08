# Azure Functions en Flex Consumption (FC1).
#
# Sin instancias always-ready el costo es por ejecución, dentro de la capa
# gratuita para cargas pequeñas. El paquete de despliegue se lee con una
# identidad administrada propia: no hay claves de cuenta en la configuración.

locals {
  container_name = "app-package-${substr(sha1(var.name), 0, 8)}"
}

resource "azurerm_user_assigned_identity" "storage" {
  name                = "id-${var.name}-storage"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_storage_container" "package" {
  name                  = local.container_name
  storage_account_id    = var.storage_account_id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "package" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.storage.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_service_plan" "this" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "FC1"
  tags                = var.tags
}

resource "azurerm_function_app_flex_consumption" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true

  storage_container_type            = "blobContainer"
  storage_container_endpoint        = "${trimsuffix(var.storage_blob_endpoint, "/")}/${azurerm_storage_container.package.name}"
  storage_authentication_type       = "UserAssignedIdentity"
  storage_user_assigned_identity_id = azurerm_user_assigned_identity.storage.id

  runtime_name           = var.runtime_name
  runtime_version        = var.runtime_version
  instance_memory_in_mb  = var.instance_memory_in_mb
  maximum_instance_count = var.maximum_instance_count

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = concat([azurerm_user_assigned_identity.storage.id], var.identity_ids)
  }

  site_config {
    application_insights_connection_string = var.application_insights_connection_string
    minimum_tls_version                    = "1.2"

    dynamic "cors" {
      for_each = length(var.cors_allowed_origins) > 0 ? [1] : []
      content {
        allowed_origins     = var.cors_allowed_origins
        support_credentials = false
      }
    }
  }

  app_settings = var.app_settings
  tags         = var.tags

  depends_on = [azurerm_role_assignment.package]
}
