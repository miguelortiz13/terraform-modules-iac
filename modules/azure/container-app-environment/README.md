# azure/container-app-environment

Entorno de Container Apps solo de consumo: sin costo fijo, Log Analytics y VNet opcionales.

## Uso

```hcl
module "cae" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/container-app-environment?ref=v0.2.0"

  name                = module.naming.names.container_app_environment
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = module.naming.tags
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
| [azurerm_container_app_environment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |
| [azurerm_container_app_environment_storage.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment_storage) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| location | Región de Azure. | `string` | n/a | yes |
| name | Nombre (usa `module.naming.names.container_app_environment`). | `string` | n/a | yes |
| resource\_group\_name | Grupo de recursos. | `string` | n/a | yes |
| tags | Etiquetas. | `map(string)` | n/a | yes |
| infrastructure\_subnet\_id | Subred para integrar el entorno en una VNet (mínimo /23 en entornos solo de consumo). `null` = red administrada por Azure, sin costo. | `string` | `null` | no |
| log\_analytics\_workspace\_id | Workspace para los logs de las apps. `null` = sin Log Analytics (USD 0; los logs se ven en vivo con `az containerapp logs show`). | `string` | `null` | no |
| storage\_access\_keys | Claves de las cuentas de `storages`, con la misma clave del mapa. | `map(string)` | `{}` | no |
| storages | Recursos compartidos de Azure Files montables por las apps. La clave es el nombre del storage dentro del entorno. | ```map(object({ account_name = string share_name = string access_mode = optional(string, "ReadWrite") }))``` | `{}` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| default\_domain | Dominio por defecto de las apps del entorno. |
| id | ID del entorno. |
| static\_ip\_address | IP de entrada del entorno. |
| storage\_names | Nombres de los storages montables registrados en el entorno. |
<!-- END_TF_DOCS -->
