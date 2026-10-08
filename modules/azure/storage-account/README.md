# azure/storage-account

Storage account con valores seguros por defecto (TLS 1.2, sin acceso anónimo, sin claves de cuenta, borrado suave) y contenedores, shares y tablas.

## Uso

```hcl
module "storage" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/storage-account?ref=v0.1.0"

  name                = module.naming.names.storage_account
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = module.naming.tags
  containers          = ["reports"]
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
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_share.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [azurerm_storage_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| location | Región de Azure. | `string` | n/a | yes |
| name | Nombre (3-24, minúsculas y dígitos; usa `module.naming.names.storage_account`). | `string` | n/a | yes |
| resource\_group\_name | Grupo de recursos. | `string` | n/a | yes |
| tags | Etiquetas. | `map(string)` | n/a | yes |
| blob\_soft\_delete\_days | Días de retención de blobs y contenedores borrados. 0 lo desactiva. | `number` | `7` | no |
| containers | Contenedores de blobs privados a crear. | `set(string)` | `[]` | no |
| file\_shares | Recursos compartidos de Azure Files: nombre => cuota en GB. | `map(number)` | `{}` | no |
| public\_network\_access\_enabled | Acceso por red pública. Sin private endpoints (costo extra), debe quedar en true y protegerse con Entra ID y RBAC. | `bool` | `true` | no |
| replication\_type | Replicación. LRS es la opción de menor costo. | `string` | `"LRS"` | no |
| shared\_access\_key\_enabled | Permite autenticación con claves de cuenta. Desactívalo si todos los clientes usan Entra ID. Azure Files montado en Container Apps las necesita. | `bool` | `false` | no |
| tables | Tablas a crear. | `set(string)` | `[]` | no |
| versioning\_enabled | Versionado de blobs (recomendado para estados de Terraform). | `bool` | `false` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| container\_ids | IDs de los contenedores por nombre. |
| file\_share\_names | Nombres de los recursos compartidos de Azure Files. |
| id | ID de la cuenta. |
| name | Nombre de la cuenta. |
| primary\_access\_key | Clave primaria (solo si `shared_access_key_enabled = true`). |
| primary\_blob\_endpoint | Endpoint de blobs. |
<!-- END_TF_DOCS -->
