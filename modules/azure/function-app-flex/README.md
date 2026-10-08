# azure/function-app-flex

Azure Functions en Flex Consumption (FC1) con el paquete de despliegue leído por identidad administrada (sin claves de cuenta).

## Uso

```hcl
module "func" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/function-app-flex?ref=v0.1.0"

  name                  = module.naming.names.function_app
  service_plan_name     = module.naming.names.service_plan
  resource_group_name   = module.rg.name
  location              = module.rg.location
  tags                  = module.naming.tags
  storage_account_id    = module.storage.id
  storage_blob_endpoint = module.storage.primary_blob_endpoint
  runtime_name          = "node"
  runtime_version       = "22"
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
| [azurerm_function_app_flex_consumption.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app_flex_consumption) | resource |
| [azurerm_role_assignment.package](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_storage_container.package](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_user_assigned_identity.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| location | Región con Flex Consumption disponible. | `string` | n/a | yes |
| name | Nombre de la Function App (global; usa `module.naming.names.function_app`). | `string` | n/a | yes |
| resource\_group\_name | Grupo de recursos. | `string` | n/a | yes |
| runtime\_name | Runtime: `node`, `python`, `dotnet-isolated`, `java` o `powershell`. | `string` | n/a | yes |
| runtime\_version | Versión del runtime (p. ej. `22` para node, `3.12` para python). | `string` | n/a | yes |
| service\_plan\_name | Nombre del plan FC1 (usa `module.naming.names.service_plan`). | `string` | n/a | yes |
| storage\_account\_id | ID de la cuenta donde se guarda el paquete de despliegue. | `string` | n/a | yes |
| storage\_blob\_endpoint | Endpoint de blobs de esa cuenta (`https://<cuenta>.blob.core.windows.net/`). | `string` | n/a | yes |
| tags | Etiquetas. | `map(string)` | n/a | yes |
| app\_settings | Configuración de la app. No incluyas `AzureWebJobsStorage`: Flex lo gestiona. | `map(string)` | `{}` | no |
| application\_insights\_connection\_string | Cadena de conexión de Application Insights (opcional). | `string` | `null` | no |
| cors\_allowed\_origins | Orígenes CORS permitidos. | `list(string)` | `[]` | no |
| identity\_ids | Identidades adicionales para la app (p. ej. para leer Key Vault). | `list(string)` | `[]` | no |
| instance\_memory\_in\_mb | Memoria por instancia: 512, 2048 o 4096. | `number` | `2048` | no |
| maximum\_instance\_count | Tope de instancias: limita el costo ante picos o abusos. | `number` | `10` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| default\_hostname | Hostname por defecto. |
| id | ID de la Function App. |
| name | Nombre de la Function App. |
| principal\_id | Object ID de la identidad asignada por el sistema (para dar permisos a la app). |
<!-- END_TF_DOCS -->
