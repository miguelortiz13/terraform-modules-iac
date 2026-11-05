# github/repository-baseline

Base mínima de un repositorio de GitHub:

- Alertas de Dependabot (también activan el **Dependency graph**, que necesita `dependency-review`).
- Actualizaciones de seguridad automáticas de Dependabot.
- Regla de la **rama principal**: todo cambio entra por PR, sin push forzado ni borrado, y con los **checks obligatorios** indicados.

No gestiona el repositorio en sí (descripción, topics, visibilidad): solo agrega estas piezas, así que no pisa nada.

Decisiones para un mantenedor único:

- **Sin aprobaciones obligatorias**: nadie puede aprobar sus propios PRs.
- **Bypass de admin solo al mergear un PR** (`gh pr merge --admin`), nunca con push directo. Hace falta para los PRs de release-please, que se crean con el `GITHUB_TOKEN` y no disparan CI.
- **Checks obligatorios**: solo los que corren en *todos* los PRs. Uno con filtro de rutas dejaría bloqueados los PRs que no lo disparan.

Con GitHub Free las reglas de rama solo funcionan en **repos públicos**: en los privados usa `protect_default_branch = false`.

## Uso

```hcl
module "baseline" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/github/repository-baseline?ref=v0.4.0"

  repository      = "nexpos-backend"
  required_checks = ["Security baseline / gitleaks", "Maven Compile & Unit Tests / build"]
}
```

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.9.0 |
| github | >= 6.0, < 7.0 |

### Providers

| Name | Version |
| ---- | ------- |
| github | >= 6.0, < 7.0 |

### Resources

| Name | Type |
| ---- | ---- |
| [github_repository_dependabot_security_updates.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_dependabot_security_updates) | resource |
| [github_repository_ruleset.default_branch](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |
| [github_repository_vulnerability_alerts.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_vulnerability_alerts) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| repository | Nombre del repositorio (sin dueño); el dueño lo da el proveedor `github`. | `string` | n/a | yes |
| admin\_bypass | Permite que un admin salte la regla al mergear un PR (`gh pr merge --admin`), p. ej. para los PRs de release-please, que no disparan CI. Nunca permite push directo. | `bool` | `true` | no |
| protect\_default\_branch | Crea la regla de la rama principal. Con GitHub Free solo funciona en repos públicos; en privados, déjalo en false. | `bool` | `true` | no |
| required\_checks | Checks que deben pasar para mergear. Solo los que corren en TODOS los PRs: uno con filtro de rutas dejaría bloqueados los PRs que no lo disparan. | `list(string)` | `[]` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| ruleset\_id | ID de la regla de la rama principal (null si no se crea). |
<!-- END_TF_DOCS -->
