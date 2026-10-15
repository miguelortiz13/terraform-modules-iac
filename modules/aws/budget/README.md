# aws/budget

Presupuesto mensual de costo con alertas por gasto real y pronosticado. Se crea en la cuenta de administración y filtra por cuenta miembro (`linked_account_ids`), así que la cuenta del proyecto no necesita recursos propios para tener su alerta.

## Uso

```hcl
module "budget" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/aws/budget?ref=v0.3.0"

  name               = "budget-nexpos"
  amount             = 5
  linked_account_ids = [module.account.id]
  contact_emails     = ["owner@example.com"]
}
```

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.9.0 |
| aws | >= 6.0, < 7.0 |

### Providers

| Name | Version |
| ---- | ------- |
| aws | >= 6.0, < 7.0 |

### Resources

| Name | Type |
| ---- | ---- |
| [aws_budgets_budget.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| amount | Monto mensual en USD. | `number` | n/a | yes |
| contact\_emails | Correos que reciben las alertas. | `list(string)` | n/a | yes |
| name | Nombre del presupuesto. | `string` | n/a | yes |
| actual\_thresholds | Porcentajes del monto que disparan alerta por gasto real. | `list(number)` | ```[ 80, 100 ]``` | no |
| forecast\_thresholds | Porcentajes del monto que disparan alerta por gasto pronosticado. Avisan antes de que el gasto ocurra. | `list(number)` | ```[ 100 ]``` | no |
| linked\_account\_ids | Cuentas miembro cuyo gasto se mide. Vacío = toda la organización (o la cuenta donde se crea). | `list(string)` | `[]` | no |
| tags | Etiquetas del presupuesto. | `map(string)` | `{}` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| id | ID del presupuesto. |
<!-- END_TF_DOCS -->
