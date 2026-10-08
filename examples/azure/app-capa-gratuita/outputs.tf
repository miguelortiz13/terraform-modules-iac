output "api_url" {
  description = "URL de la API."
  value       = module.api.url
}

output "web_url" {
  description = "URL del frontend."
  value       = module.web.url
}

output "github_environment_variables" {
  description = "Variables para el environment `dev` del repo en GitHub (OIDC, sin secretos)."
  value = {
    AZURE_CLIENT_ID       = module.deploy_identity.client_id
    AZURE_TENANT_ID       = module.deploy_identity.tenant_id
    AZURE_SUBSCRIPTION_ID = var.subscription_id
  }
}
