# azure/key-vault

Key Vault con autorización RBAC, borrado suave y protección de purga.

## Uso

```hcl
module "kv" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/key-vault?ref=v0.2.0"

  name                = module.naming.names.key_vault
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = module.naming.tags
  tenant_id           = data.azurerm_client_config.current.tenant_id

  role_assignments = {
    api = { principal_id = module.api_identity.principal_id, role_definition_name = "Key Vault Secrets User" }
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
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| location | Región de Azure. | `string` | n/a | yes |
| name | Nombre (3-24; usa `module.naming.names.key_vault`). | `string` | n/a | yes |
| resource\_group\_name | Grupo de recursos. | `string` | n/a | yes |
| tags | Etiquetas. | `map(string)` | n/a | yes |
| tenant\_id | Tenant de Entra ID. | `string` | n/a | yes |
| public\_network\_access\_enabled | Acceso por red pública. Sin private endpoints (costo extra) debe quedar en true. | `bool` | `true` | no |
| purge\_protection\_enabled | Impide purgar el vault durante la retención. Recomendado en prod; en dev/lab impide reutilizar el nombre tras un destroy. | `bool` | `true` | no |
| role\_assignments | Roles RBAC sobre el vault. La clave es un nombre estable. Roles habituales: `Key Vault Secrets User` (leer), `Key Vault Secrets Officer` (gestionar), `Key Vault Administrator`. | ```map(object({ principal_id = string role_definition_name = string principal_type = optional(string, "ServicePrincipal") }))``` | `{}` | no |
| soft\_delete\_retention\_days | Días de retención tras borrar (7-90). No se puede cambiar después de crear el vault. | `number` | `90` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| id | ID del vault. |
| name | Nombre del vault. |
| vault\_uri | URI del vault (para referencias a secretos desde Container Apps o Functions). |
<!-- END_TF_DOCS -->
