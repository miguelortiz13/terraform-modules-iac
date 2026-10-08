# Ejemplo: API en Container Apps (escala a cero) + SPA en Static Web Apps
# Free + Azure SQL gratis + presupuesto + identidad OIDC para el CD.
# Costo esperado: USD 0 dentro de los cupos gratis de la suscripción.

data "azurerm_client_config" "current" {}

module "naming" {
  source = "../../../modules/azure/naming"

  project     = "demo"
  environment = "dev"
  location    = var.location
  unique_seed = var.subscription_id
  owner       = var.owner
  repository  = var.repository
}

module "rg" {
  source = "../../../modules/azure/resource-group"

  name     = module.naming.names.resource_group
  location = var.location
  tags     = module.naming.tags
}

module "api_identity" {
  source = "../../../modules/azure/user-assigned-identity"

  name                = "${module.naming.names.user_assigned_identity}-api"
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = module.naming.tags
}

module "deploy_identity" {
  source = "../../../modules/azure/user-assigned-identity"

  name                = "${module.naming.names.user_assigned_identity}-deploy"
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = module.naming.tags

  role_assignments = {
    rg-contributor = { scope = module.rg.id, role_definition_name = "Contributor" }
  }

  federated_credentials = {
    github-dev = { subject = "repo:${var.repository}:environment:dev" }
  }
}

module "kv" {
  source = "../../../modules/azure/key-vault"

  name                     = module.naming.names.key_vault
  resource_group_name      = module.rg.name
  location                 = module.rg.location
  tags                     = module.naming.tags
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false

  role_assignments = {
    api = { principal_id = module.api_identity.principal_id, role_definition_name = "Key Vault Secrets User" }
  }
}

module "sql" {
  source = "../../../modules/azure/mssql-serverless-free"

  server_name         = module.naming.names.mssql_server
  database_name       = module.naming.names.mssql_database
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = module.naming.tags
  entra_admin         = var.sql_admin
}

module "cae" {
  source = "../../../modules/azure/container-app-environment"

  name                = module.naming.names.container_app_environment
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = module.naming.tags
}

module "web" {
  source = "../../../modules/azure/static-web-app"

  name                = module.naming.names.static_web_app
  resource_group_name = module.rg.name
  tags                = module.naming.tags
}

module "api" {
  source = "../../../modules/azure/container-app"

  name                         = "${module.naming.names.container_app}-api"
  resource_group_name          = module.rg.name
  container_app_environment_id = module.cae.id
  tags                         = module.naming.tags

  ingress           = { target_port = 8080 }
  health_probe_path = "/health"
  identity_ids      = [module.api_identity.id]

  key_vault_secrets = { "jwt-secret" = "${module.kv.vault_uri}secrets/jwt-secret" }
  secret_env        = { JWT_SECRET = "jwt-secret" }

  env = {
    AZURE_CLIENT_ID = module.api_identity.client_id
    DB_SERVER       = module.sql.server_fqdn
    DB_NAME         = module.sql.database_name
    CORS_ORIGINS    = module.web.url
  }
}

module "budget" {
  source = "../../../modules/azure/budget"

  name           = module.naming.names.budget
  scope_id       = "/subscriptions/${var.subscription_id}"
  amount         = 5
  contact_emails = [var.owner]
}
