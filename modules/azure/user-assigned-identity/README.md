# azure/user-assigned-identity

Identidad administrada con roles y credenciales federadas OIDC (GitHub Actions sin secretos).

## Uso

```hcl
module "deploy_identity" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/user-assigned-identity?ref=v0.1.0"

  name                = "${module.naming.names.user_assigned_identity}-deploy"
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = module.naming.tags

  role_assignments = {
    rg-contributor = { scope = module.rg.id, role_definition_name = "Contributor" }
  }

  federated_credentials = {
    github-prod = { subject = "repo:miguelortiz13/nexpos-backend:environment:prod" }
  }
}
```

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.9.0 |
| azurerm | >= 5.0, < 6.0 |

### Providers

| Name | Version |
| ---- | ------- |
| azurerm | >= 5.0, < 6.0 |

### Resources

| Name | Type |
| ---- | ---- |
| [azurerm_federated_identity_credential.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| location | Región de Azure. | `string` | n/a | yes |
| name | Nombre de la identidad (usa `module.naming.names.user_assigned_identity`). | `string` | n/a | yes |
| resource\_group\_name | Grupo de recursos. | `string` | n/a | yes |
| tags | Etiquetas. | `map(string)` | n/a | yes |
| federated\_credentials | Credenciales federadas OIDC (sin secretos). La clave es el nombre de la credencial. Para GitHub Actions usa `subject = "repo:<owner>/<repo>:environment:<env>"`. | ```map(object({ issuer = optional(string, "https://token.actions.githubusercontent.com") subject = string audience = optional(list(string), ["api://AzureADTokenExchange"]) }))``` | `{}` | no |
| role\_assignments | Roles a asignar a la identidad. La clave es un nombre estable (no cambia el plan si se reordena). | ```map(object({ scope = string role_definition_name = string }))``` | `{}` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| client\_id | Client ID (para `AZURE_CLIENT_ID` en GitHub Actions o en la app). |
| id | ID de la identidad. |
| principal\_id | Object ID del service principal de la identidad. |
| tenant\_id | Tenant de la identidad. |
<!-- END_TF_DOCS -->
