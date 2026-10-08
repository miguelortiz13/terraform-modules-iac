# terraform-modules-iac

Biblioteca de módulos de Terraform reutilizables para todos mis proyectos, con
estándares comunes de nombres, etiquetas, seguridad, costo y versionado.

Está organizada por proveedor (`modules/<proveedor>/<módulo>`): hoy contiene
Azure y está preparada para sumar otros (AWS, GitHub, Cloudflare...) con las
mismas reglas.

## Catálogo

### Azure: base

| Módulo | Para qué |
|---|---|
| [`naming`](modules/azure/naming) | Nombres (CAF) y etiquetas estándar. Lo usan todos los demás. |
| [`resource-group`](modules/azure/resource-group) | Grupo de recursos con bloqueo opcional. |
| [`user-assigned-identity`](modules/azure/user-assigned-identity) | Identidad administrada con roles y OIDC para GitHub Actions. |
| [`key-vault`](modules/azure/key-vault) | Key Vault con RBAC y protección de purga. |
| [`storage-account`](modules/azure/storage-account) | Storage con valores seguros por defecto. |
| [`log-analytics`](modules/azure/log-analytics) | Logs con tope diario dentro del cupo gratis. |
| [`budget`](modules/azure/budget) | Presupuesto con alertas reales y pronosticadas. |

### Azure: cómputo y datos

| Módulo | Para qué | Costo típico |
|---|---|---|
| [`container-app-environment`](modules/azure/container-app-environment) | Entorno de Container Apps solo de consumo | USD 0 fijo |
| [`container-app`](modules/azure/container-app) | API o web en contenedor, escala a cero | USD 0 dentro del cupo |
| [`container-app-job`](modules/azure/container-app-job) | Tareas programadas o manuales | USD 0 dentro del cupo |
| [`static-web-app`](modules/azure/static-web-app) | Frontends SPA | USD 0 (Free) |
| [`function-app-flex`](modules/azure/function-app-flex) | Azure Functions en Flex Consumption | USD 0 en cargas pequeñas |
| [`mssql-serverless-free`](modules/azure/mssql-serverless-free) | Azure SQL con la oferta gratuita | USD 0 |

### Azure: plataforma y gobierno

| Módulo | Para qué |
|---|---|
| [`subscription`](modules/azure/subscription) | Crear o adoptar suscripciones y ubicarlas en management groups. |
| [`policy-baseline`](modules/azure/policy-baseline) | Azure Policy: regiones, etiquetas, SKUs y recursos caros. |
| [`tfstate-backend`](modules/azure/tfstate-backend) | Backend central de estados con RBAC por proyecto. |

## Uso

Fija siempre una versión con `?ref=`:

```hcl
module "naming" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/naming?ref=v0.2.0"

  project     = "nexpos"
  environment = "prod"
  location    = "eastus2"
  unique_seed = var.subscription_id
  owner       = "owner@example.com"
  repository  = "miguelortiz13/nexpos-backend"
}
```

Hay un ejemplo completo en [`examples/azure/app-capa-gratuita`](examples/azure/app-capa-gratuita).

Los proyectos también pueden usar el pipeline estándar de infraestructura
(plan en PR, apply en `main` con aprobación, OIDC sin secretos):

```yaml
jobs:
  infra:
    uses: miguelortiz13/terraform-modules-iac/.github/workflows/terraform-azure.yml@v0.2.0
    with:
      environment: prod
```

## Estándares

- [Nombres y etiquetas](docs/standards/nombres-y-etiquetas.md)
- [Estructura de un proyecto](docs/standards/proyectos.md)
- [Diseño de módulos](docs/standards/modulos.md)
- [Versionado y releases](docs/standards/versionado.md)
- [Costos y capa gratuita](docs/standards/costos.md)

## Requisitos

- Terraform >= 1.9 (CI usa 1.16)
- Proveedores: `azurerm` 5.x, `azapi` 2.x

## Desarrollo

```bash
pre-commit install
cd modules/azure/<módulo>
terraform init -backend=false && terraform test
```

Ver [CONTRIBUTING.md](CONTRIBUTING.md).

## Licencia

[MIT](LICENSE)
