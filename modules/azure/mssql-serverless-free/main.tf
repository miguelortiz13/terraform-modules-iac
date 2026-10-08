# Azure SQL Database con la oferta gratuita.
#
# Cada suscripción puede tener hasta 10 bases gratis y cada una recibe al mes
# 100.000 vCore-segundos de cómputo serverless y 32 GB de datos. La base se
# pausa tras 60 minutos sin conexiones (el retardo no es configurable en la
# oferta gratuita con AutoPause): cada vez que se despierta consume al menos
# ~1.800 vCore-s (0,5 vCore x 1 h). Planifica el cupo con eso en mente.
#
# Solo autenticación con Entra ID: las apps entran con su identidad
# administrada como usuario contenido de la base.

resource "azurerm_mssql_server" "this" {
  name                          = var.server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  minimum_tls_version           = "1.2"
  public_network_access_enabled = true
  tags                          = var.tags

  azuread_administrator {
    login_username              = var.entra_admin.login_username
    object_id                   = var.entra_admin.object_id
    azuread_authentication_only = true
  }
}

resource "azurerm_mssql_firewall_rule" "azure_services" {
  #checkov:skip=CKV2_AZURE_34:0.0.0.0 solo admite tráfico originado en Azure y se puede desactivar con allow_azure_services; el acceso exige token de Entra ID.
  count = var.allow_azure_services ? 1 : 0

  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "this" {
  for_each = var.firewall_rules

  name             = each.key
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = each.value.start_ip
  end_ip_address   = each.value.end_ip
}

# azurerm no expone useFreeLimit ni freeLimitExhaustionBehavior: la base se
# declara con azapi.
resource "azapi_resource" "database" {
  type      = "Microsoft.Sql/servers/databases@2025-01-01"
  name      = var.database_name
  parent_id = azurerm_mssql_server.this.id
  location  = var.location
  tags      = var.tags

  body = {
    sku = {
      name     = "GP_S_Gen5"
      tier     = "GeneralPurpose"
      family   = "Gen5"
      capacity = var.max_vcores
    }
    properties = {
      useFreeLimit                     = true
      freeLimitExhaustionBehavior      = var.free_limit_exhaustion_behavior
      minCapacity                      = 0.5
      maxSizeBytes                     = 34359738368
      zoneRedundant                    = false
      requestedBackupStorageRedundancy = "Local"
    }
  }

  response_export_values = ["properties.status"]
}
