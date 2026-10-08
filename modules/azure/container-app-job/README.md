# azure/container-app-job

Container Apps Job programado (cron) o manual; solo consume mientras corre.

## Uso

```hcl
module "collector" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/container-app-job?ref=v0.1.0"

  name                         = module.naming.names.container_app_job
  resource_group_name          = module.rg.name
  location                     = module.rg.location
  container_app_environment_id = module.cae.id
  tags                         = module.naming.tags
  cron_expression              = "0 6 * * *"
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
| [azurerm_container_app_job.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_job) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| container\_app\_environment\_id | ID del entorno de Container Apps. | `string` | n/a | yes |
| location | Región (la misma del entorno). | `string` | n/a | yes |
| name | Nombre (usa `module.naming.names.container_app_job`; máximo 32 caracteres). | `string` | n/a | yes |
| resource\_group\_name | Grupo de recursos. | `string` | n/a | yes |
| tags | Etiquetas. | `map(string)` | n/a | yes |
| args | Argumentos del contenedor. | `list(string)` | `null` | no |
| command | Comando del contenedor. | `list(string)` | `null` | no |
| cpu | vCPU por ejecución. | `number` | `0.5` | no |
| cron\_expression | Horario en cron (UTC). `null` = job manual (se lanza con `az containerapp job start`). | `string` | `null` | no |
| env | Variables de entorno en claro. | `map(string)` | `{}` | no |
| identity\_ids | Identidades asignadas por el usuario. La primera lee Key Vault y el registro. | `list(string)` | `[]` | no |
| image | Imagen inicial; el pipeline de la aplicación despliega las siguientes y Terraform ignora este valor. | `string` | `"mcr.microsoft.com/k8se/quickstart-jobs:latest"` | no |
| key\_vault\_secrets | Secretos de Key Vault: nombre => URI del secreto. | `map(string)` | `{}` | no |
| memory | Memoria por ejecución (el doble de la CPU). | `string` | `"1Gi"` | no |
| registry | Registro privado (`null` para imágenes públicas). | ```object({ server = string identity_id = optional(string) })``` | `null` | no |
| replica\_retry\_limit | Reintentos si la ejecución falla. | `number` | `1` | no |
| replica\_timeout\_in\_seconds | Tiempo máximo de una ejecución. | `number` | `1800` | no |
| secret\_env | Variable de entorno => nombre del secreto. | `map(string)` | `{}` | no |
| secrets | Secretos con valor directo. | `map(string)` | `{}` | no |
| volumes | Volúmenes de Azure Files: nombre del storage del entorno => ruta de montaje. | `map(string)` | `{}` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| id | ID del job. |
| name | Nombre del job. |
<!-- END_TF_DOCS -->
