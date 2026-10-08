# azure/static-web-app

Static Web App (Free por defecto) para frontends SPA, desplegada desde GitHub Actions.

## Uso

```hcl
module "web" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/static-web-app?ref=v0.2.0"

  name                = module.naming.names.static_web_app
  resource_group_name = module.rg.name
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
| [azurerm_static_web_app.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/static_web_app) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| name | Nombre (usa `module.naming.names.static_web_app`). | `string` | n/a | yes |
| resource\_group\_name | Grupo de recursos. | `string` | n/a | yes |
| tags | Etiquetas. | `map(string)` | n/a | yes |
| app\_settings | Configuración de la app (solo aplica a las APIs administradas). | `map(string)` | `{}` | no |
| location | Región de Static Web Apps. Solo algunas regiones la ofrecen (p. ej. `eastus2`, `centralus`, `westus2`, `westeurope`, `eastasia`). | `string` | `"eastus2"` | no |
| sku | `Free` (USD 0) o `Standard` (~USD 9/mes: dominios con SSL propio adicional, autenticación personalizada y SLA). | `string` | `"Free"` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| api\_key | Token de despliegue para `Azure/static-web-apps-deploy`. Guárdalo como secreto del entorno en GitHub. |
| default\_host\_name | Dominio por defecto (`*.azurestaticapps.net`). |
| id | ID de la Static Web App. |
| url | URL HTTPS por defecto. |
<!-- END_TF_DOCS -->
