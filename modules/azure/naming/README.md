# azure/naming

Convención de nombres (CAF) y etiquetas estándar. No crea recursos: todos los demás módulos reciben sus `names` y `tags`.

## Uso

```hcl
module "naming" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/naming?ref=v0.1.0"

  project     = "nexpos"
  environment = "prod"
  location    = "eastus2"
  unique_seed = var.subscription_id
  owner       = "owner@example.com"
  repository  = "miguelortiz13/nexpos-backend"
}

# module.naming.names.resource_group  -> "rg-nexpos-prod-eus2"
# module.naming.tags                  -> { Project, Environment, Owner, Repository, CostCenter, ManagedBy }
```

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.9.0 |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| environment | Entorno del despliegue. | `string` | n/a | yes |
| location | Región de Azure (nombre ARM, p. ej. `eastus2`). | `string` | n/a | yes |
| owner | Correo o alias del responsable. Va en la etiqueta `Owner`. | `string` | n/a | yes |
| project | Nombre corto del proyecto en minúsculas (p. ej. `nexpos`). Se usa en todos los nombres. | `string` | n/a | yes |
| repository | Repositorio que gestiona la infraestructura, en formato `owner/repo`. Va en la etiqueta `Repository`. | `string` | n/a | yes |
| unique\_seed | Semilla para el sufijo determinista de los nombres globalmente únicos (storage, key vault, sql). Recomendado: el ID de la suscripción. | `string` | n/a | yes |
| cost\_center | Centro de costo para el showback. Por defecto, el nombre del proyecto. | `string` | `null` | no |
| extra\_tags | Etiquetas adicionales. No pueden sobrescribir las estándar. | `map(string)` | `{}` | no |
| include\_region | Incluye el código corto de la región en los nombres (`rg-nexpos-prod-eus2`). Desactívalo solo para conservar nombres heredados. | `bool` | `true` | no |
| instance | Sufijo opcional para distinguir varias instancias del mismo tipo (p. ej. `api`, `01`). | `string` | `""` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| base | Segmento común de los nombres (`<proyecto>-<entorno>[-<región>][-<instancia>]`). |
| names | Nombres por tipo de recurso, siguiendo las abreviaturas de Cloud Adoption Framework. |
| region\_code | Código corto de la región. |
| standard\_tag\_keys | Claves de etiqueta obligatorias en todos los proyectos (las audita la política de gobierno). |
| tags | Etiquetas estándar más las adicionales. Las estándar tienen prioridad. |
<!-- END_TF_DOCS -->
