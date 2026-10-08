# azure/log-analytics

Log Analytics con tope diario de ingesta (dentro de los 5 GB gratis al mes) y Application Insights opcional.

## Uso

```hcl
module "logs" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/log-analytics?ref=v0.2.0"

  name                      = module.naming.names.log_analytics_workspace
  resource_group_name       = module.rg.name
  location                  = module.rg.location
  tags                      = module.naming.tags
  application_insights_name = module.naming.names.application_insights
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
| [azurerm_application_insights.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| location | Región de Azure. | `string` | n/a | yes |
| name | Nombre del workspace (usa `module.naming.names.log_analytics_workspace`). | `string` | n/a | yes |
| resource\_group\_name | Grupo de recursos. | `string` | n/a | yes |
| tags | Etiquetas. | `map(string)` | n/a | yes |
| application\_insights\_name | Si se indica, crea un Application Insights basado en este workspace. | `string` | `null` | no |
| daily\_quota\_gb | Tope diario de ingesta en GB. Corta la ingesta al llegar al tope: es la protección principal contra facturas sorpresa. `-1` desactiva el tope. | `number` | `0.15` | no |
| retention\_in\_days | Retención en días. 30 está incluido sin costo adicional. | `number` | `30` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| application\_insights\_connection\_string | Cadena de conexión de Application Insights, si se creó. |
| id | ID del workspace. |
| primary\_shared\_key | Clave del workspace (necesaria para Container Apps). |
| workspace\_id | GUID del workspace (customer ID). |
<!-- END_TF_DOCS -->
