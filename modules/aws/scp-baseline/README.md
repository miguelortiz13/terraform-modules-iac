# aws/scp-baseline

Línea base de SCP para las OU de proyectos: el equivalente en AWS de `azure/policy-baseline`, pero en modo bloqueo, porque las SCP no tienen modo auditoría. Son 4 políticas, y cada una se apaga dejando su variable vacía o en `false`:

| SCP | Qué bloquea |
|---|---|
| `proteccion-org` | Salir de la organización y usar el usuario raíz de las cuentas miembro. |
| `regiones` | Cualquier región fuera de `allowed_regions`; los servicios globales quedan exentos. |
| `servicios-caros` | GuardDuty, Security Hub, Config, Macie, Inspector, Detective y Shield Advanced; compras de reservas y Savings Plans; NAT Gateway y clústeres EKS. |
| `tamanos` | EC2 y RDS fuera de los tamaños pequeños permitidos. |

Las SCP no afectan a la cuenta de administración de la organización.

## Uso

```hcl
module "scp" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/aws/scp-baseline?ref=v0.3.0"

  target_ids = {
    workloads = aws_organizations_organizational_unit.workloads.id
    sandbox   = aws_organizations_organizational_unit.sandbox.id
  }
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
| [aws_organizations_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| target\_ids | OU, cuentas o raíz donde se adjuntan las SCP, con claves estables (p. ej. `{ workloads = "ou-..." }`). Las SCP no afectan a la cuenta de administración. | `map(string)` | n/a | yes |
| allowed\_ec2\_instance\_types | Tipos de instancia EC2 permitidos. Lista vacía = sin restricción. | `list(string)` | ```[ "t3.micro", "t3.small", "t4g.micro", "t4g.small" ]``` | no |
| allowed\_rds\_instance\_classes | Clases de instancia RDS permitidas. Lista vacía = sin restricción. | `list(string)` | ```[ "db.t3.micro", "db.t4g.micro" ]``` | no |
| allowed\_regions | Regiones permitidas. Los servicios globales (IAM, Organizations, facturación, CloudFront, Route 53...) quedan exentos. Lista vacía = sin restricción. | `list(string)` | ```[ "us-east-1" ]``` | no |
| denied\_actions | Acciones prohibidas por costo: servicios de seguridad de pago, compromisos de compra y recursos con costo fijo alto. Lista vacía = sin esta SCP. | `list(string)` | ```[ "guardduty:CreateDetector", "securityhub:EnableSecurityHub", "config:PutConfigurationRecorder", "config:StartConfigurationRecorder", "macie2:EnableMacie", "inspector2:Enable", "detective:CreateGraph", "shield:CreateSubscription", "ec2:PurchaseReservedInstancesOffering", "ec2:PurchaseHostReservation", "ec2:AllocateHosts", "rds:PurchaseReservedDBInstancesOffering", "savingsplans:CreateSavingsPlan", "aws-marketplace:Subscribe", "route53domains:RegisterDomain", "route53domains:TransferDomain", "ec2:CreateNatGateway", "eks:CreateCluster" ]``` | no |
| deny\_leave\_organization | Impide que una cuenta salga de la organización (y de sus SCP). | `bool` | `true` | no |
| deny\_root\_user | Bloquea al usuario raíz de las cuentas miembro; se entra con IAM Identity Center. | `bool` | `true` | no |
| name\_prefix | Prefijo de los nombres de las SCP. | `string` | `"baseline"` | no |
| tags | Etiquetas de las políticas. | `map(string)` | `{}` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| policy\_contents | JSON de cada SCP, para revisarlo en el plan. |
| policy\_ids | IDs de las SCP creadas, por clave (`proteccion-org`, `regiones`, `servicios-caros`, `tamanos`). |
<!-- END_TF_DOCS -->
