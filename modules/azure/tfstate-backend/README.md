# azure/tfstate-backend

Backend centralizado de estados: una cuenta con un contenedor por proyecto, RBAC por contenedor, versionado, borrado suave y bloqueo.

## Uso

```hcl
module "tfstate" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/tfstate-backend?ref=v0.2.0"

  storage_account_name = "sttfstateplatform01"
  resource_group_name  = module.rg.name
  location             = module.rg.location
  tags                 = module.naming.tags

  projects = {
    nexpos = { writers = [module.nexpos_deploy.principal_id] }
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

### Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| storage | ../storage-account | n/a |

### Resources

| Name | Type |
| ---- | ---- |
| [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_role_assignment.account_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.writer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| location | Región de Azure. | `string` | n/a | yes |
| projects | Un contenedor de estados por proyecto. `writers` reciben `Storage Blob Data Contributor` solo sobre su contenedor (p. ej. la identidad OIDC del repo); `readers` reciben `Storage Blob Data Reader` (p. ej. cloudops-copilot para medir la cobertura de IaC). | ```map(object({ writers = optional(list(string), []) readers = optional(list(string), []) }))``` | n/a | yes |
| resource\_group\_name | Grupo de recursos (existente). | `string` | n/a | yes |
| storage\_account\_name | Nombre de la cuenta de estados (3-24, minúsculas y dígitos). | `string` | n/a | yes |
| tags | Etiquetas. | `map(string)` | n/a | yes |
| account\_readers | Principales con lectura sobre todos los contenedores. | `list(string)` | `[]` | no |
| lock\_enabled | Bloqueo CanNotDelete sobre la cuenta. Perder los estados es la peor falla posible de IaC. | `bool` | `true` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| backend\_configs | Configuración `backend "azurerm"` lista para cada proyecto. |
| storage\_account\_id | ID de la cuenta de estados. |
| storage\_account\_name | Nombre de la cuenta de estados. |
<!-- END_TF_DOCS -->
