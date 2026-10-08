# azure/policy-baseline

Línea base de Azure Policy con definiciones integradas: regiones permitidas, etiquetas obligatorias y heredadas, tamaños de VM, tipos de recurso caros y storage seguro. Modo `audit` o `enforce`.

## Uso

```hcl
module "policies" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/policy-baseline?ref=v0.1.0"

  management_group_id = azurerm_management_group.workloads.id
  mode                = "audit"
  allowed_locations   = ["eastus2", "southcentralus", "centralus"]
  identity_location   = "eastus2"
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
| [azurerm_management_group_policy_assignment.effect](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.inherit_tag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.require_tag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.vm_skus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_role_assignment.inherit_tag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| allowed\_locations | Regiones permitidas para recursos y grupos de recursos. `global` se agrega siempre. | `list(string)` | n/a | yes |
| identity\_location | Región de la identidad que usa la política de herencia de etiquetas. | `string` | n/a | yes |
| management\_group\_id | Management group donde se asigna la línea base (se hereda a todas sus suscripciones). | `string` | n/a | yes |
| allowed\_vm\_skus | Tamaños de VM permitidos. Lista vacía = no se restringe. | `list(string)` | ```[ "Standard_B1s", "Standard_B1ms", "Standard_B2s", "Standard_B2ats_v2", "Standard_B2pts_v2", "Standard_B2als_v2", "Standard_B2s_v2" ]``` | no |
| denied\_resource\_types | Tipos de recurso caros que no se permiten sin una excepción explícita. | `list(string)` | ```[ "Microsoft.Network/azureFirewalls", "Microsoft.Network/applicationGateways", "Microsoft.Network/virtualNetworkGateways", "Microsoft.Network/expressRouteCircuits", "Microsoft.Network/bastionHosts", "Microsoft.Network/ddosProtectionPlans", "Microsoft.Databricks/workspaces", "Microsoft.Synapse/workspaces", "Microsoft.Kusto/clusters", "Microsoft.AVS/privateClouds" ]``` | no |
| mode | `audit`: solo reporta incumplimientos (recomendado al empezar, no rompe despliegues). `enforce`: bloquea los recursos que incumplen. | `string` | `"audit"` | no |
| name\_prefix | Prefijo corto de los nombres de asignación (máximo 24 caracteres en total por asignación). | `string` | `"base"` | no |
| required\_tags | Etiquetas obligatorias en los grupos de recursos. Los recursos las heredan del grupo si les faltan. | `list(string)` | ```[ "Project", "Environment", "Owner", "ManagedBy" ]``` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| assignment\_ids | IDs de todas las asignaciones de política. |
| mode | Modo aplicado (audit o enforce). |
<!-- END_TF_DOCS -->
