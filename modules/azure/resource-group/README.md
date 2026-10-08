# azure/resource-group

Grupo de recursos con bloqueo opcional contra borrados (`CanNotDelete` recomendado en prod).

## Uso

```hcl
module "rg" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/resource-group?ref=v0.1.0"

  name       = module.naming.names.resource_group
  location   = "eastus2"
  tags       = module.naming.tags
  lock_level = "CanNotDelete"
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
| [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| location | Región de Azure. | `string` | n/a | yes |
| name | Nombre del grupo de recursos (usa `module.naming.names.resource_group`). | `string` | n/a | yes |
| tags | Etiquetas (usa `module.naming.tags`). | `map(string)` | n/a | yes |
| lock\_level | Bloqueo de gestión: `CanNotDelete`, `ReadOnly` o `null` para no bloquear. Recomendado `CanNotDelete` en prod. | `string` | `null` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| id | ID del grupo de recursos. |
| location | Región del grupo de recursos. |
| name | Nombre del grupo de recursos. |
<!-- END_TF_DOCS -->
