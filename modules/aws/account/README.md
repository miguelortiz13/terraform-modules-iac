# aws/account

Cuenta miembro de AWS Organizations para un proyecto: el equivalente de una suscripción por proyecto en Azure. Crear la cuenta no cuesta; lo que se despliega dentro, sí.

Por defecto `terraform destroy` **no cierra** la cuenta (`close_on_deletion = false`). Cerrar una cuenta la deja 90 días suspendida y AWS limita cuántas se pueden cerrar.

## Uso

```hcl
module "account" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/aws/account?ref=v0.3.0"

  name      = "nexpos"
  email     = "owner+aws-nexpos@example.com"
  parent_id = aws_organizations_organizational_unit.workloads.id
  tags      = { Project = "nexpos" }
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
| [aws_organizations_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| email | Correo del usuario raíz de la cuenta. Debe ser único en AWS; con Gmail sirve `usuario+aws-<proyecto>@gmail.com`. | `string` | n/a | yes |
| name | Nombre de la cuenta (p. ej. `nexpos`). Es el equivalente a una suscripción por proyecto en Azure. | `string` | n/a | yes |
| parent\_id | OU (`ou-...`) o raíz (`r-...`) donde se ubica la cuenta. De la OU dependen las SCP que la protegen. | `string` | n/a | yes |
| admin\_role\_name | Rol que AWS crea en la cuenta nueva para administrarla desde la cuenta de administración. | `string` | `"OrganizationAccountAccessRole"` | no |
| close\_on\_deletion | Si `true`, `terraform destroy` cierra la cuenta (queda 90 días suspendida y cuenta para el cupo de cierres). Si `false`, solo la saca de la organización, lo que exige que tenga medio de pago propio. | `bool` | `false` | no |
| tags | Etiquetas de la cuenta en Organizations. | `map(string)` | `{}` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| admin\_role\_arn | ARN del rol de administración que se asume desde la cuenta de administración. |
| arn | ARN de la cuenta en Organizations. |
| id | ID de la cuenta (12 dígitos). |
<!-- END_TF_DOCS -->
