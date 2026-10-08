# azure/budget

Presupuesto mensual de suscripción o grupo de recursos, con alertas por gasto real y pronosticado.

## Uso

```hcl
module "budget" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/budget?ref=v0.2.0"

  name           = module.naming.names.budget
  scope_id       = "/subscriptions/${var.subscription_id}"
  amount         = 10
  contact_emails = ["owner@example.com"]
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
| [azurerm_consumption_budget_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_resource_group) | resource |
| [azurerm_consumption_budget_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_subscription) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| amount | Monto mensual en la moneda de facturación (USD). | `number` | n/a | yes |
| contact\_emails | Correos que reciben las alertas. | `list(string)` | n/a | yes |
| name | Nombre del presupuesto. | `string` | n/a | yes |
| scope\_id | ID del ámbito: una suscripción (`/subscriptions/<id>`) o un grupo de recursos. | `string` | n/a | yes |
| actual\_thresholds | Porcentajes del monto que disparan alerta por gasto real. | `list(number)` | ```[ 80, 100 ]``` | no |
| forecast\_thresholds | Porcentajes del monto que disparan alerta por gasto pronosticado. Avisan antes de que el gasto ocurra. | `list(number)` | ```[ 100 ]``` | no |
| resource\_group\_filter | Solo para presupuestos de suscripción: limita el cálculo a estos grupos de recursos. | `list(string)` | `[]` | no |
| scope\_type | `subscription` o `resource_group`. Se declara aparte porque `scope_id` puede no conocerse hasta el apply (p. ej. una suscripción creada en el mismo apply). | `string` | `"subscription"` | no |
| start\_date | Inicio del presupuesto (primer día de un mes, RFC3339). Por defecto, el mes en curso cuando se crea; después se ignora para no generar cambios cada mes. | `string` | `null` | no |
| tag\_filter | Solo para presupuestos de suscripción: limita el cálculo a recursos con estas etiquetas (p. ej. `{ Project = ["nexpos"] }`). | `map(list(string))` | `{}` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| id | ID del presupuesto. |
<!-- END_TF_DOCS -->
