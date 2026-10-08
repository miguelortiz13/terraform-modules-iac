# azure/subscription

Suscripción como código (alias ARM): crea una nueva en una sección de factura MCA o adopta una existente, y la ubica en un management group. Protegida con `prevent_destroy` porque destruir el alias cancela la suscripción.

## Uso

```hcl
module "sub_nexpos" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/subscription?ref=v0.1.0"

  alias               = "sub-nexpos"
  display_name        = "sub-nexpos"
  billing_scope_id    = var.invoice_section_id
  management_group_name = azurerm_management_group.workloads.name
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
| [azurerm_management_group_subscription_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_subscription_association) | resource |
| [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| alias | Alias ARM de la suscripción (identificador estable, sin espacios). Convención: `sub-<proyecto>`. | `string` | n/a | yes |
| display\_name | Nombre visible de la suscripción. | `string` | n/a | yes |
| billing\_scope\_id | Sección de factura MCA donde se crea (`/providers/Microsoft.Billing/billingAccounts/.../billingProfiles/.../invoiceSections/...`). Déjalo en null para adoptar una existente con `subscription_id`. | `string` | `null` | no |
| management\_group\_name | Nombre (no ID) del management group donde se ubica la suscripción, p. ej. `mg-workloads`. `null` = sin cambiar. Se pide el nombre porque se conoce en el plan aunque el grupo se cree en el mismo apply. | `string` | `null` | no |
| subscription\_id | ID de una suscripción existente para gestionarla (renombrar, etiquetar, ubicar) sin crear una nueva. | `string` | `null` | no |
| tags | Etiquetas de la suscripción. | `map(string)` | `{}` | no |
| workload | `Production` o `DevTest`. | `string` | `"Production"` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| id | ID de recurso de la suscripción (`/subscriptions/<guid>`). |
| subscription\_id | GUID de la suscripción. |
<!-- END_TF_DOCS -->
