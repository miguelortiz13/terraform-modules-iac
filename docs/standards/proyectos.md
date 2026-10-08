# Estructura de un proyecto

Cada repositorio de aplicación sigue la misma estructura de infraestructura,
para que cualquier proyecto se opere igual.

## Carpetas

```
<repo>/
├── infra/
│   └── terraform/
│       ├── versions.tf          # terraform {} + backend "azurerm" {} + providers
│       ├── main.tf              # composición de módulos de terraform-modules-iac
│       ├── variables.tf
│       ├── outputs.tf
│       ├── prod.tfvars.example  # valores de ejemplo, sin secretos
│       └── .terraform.lock.hcl  # se versiona en el proyecto
└── .github/workflows/
    ├── infra.yml                # llama al workflow reutilizable terraform-azure.yml
    └── deploy.yml               # build de la imagen y despliegue de la app
```

## Reglas

1. **Una suscripción por proyecto** (`sub-<proyecto>`), creada desde el repo de plataforma.
2. **Estado remoto central**: contenedor `<proyecto>` en la cuenta de estados de
   la plataforma, con autenticación de Entra ID (`use_azuread_auth = true`).
   Nunca estados locales ni claves de cuenta.
3. **Sin secretos en GitHub**: el pipeline entra con OIDC (identidad federada
   creada por la plataforma). En el repo solo hay *variables* de environment:
   `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`,
   `TFSTATE_RESOURCE_GROUP`, `TFSTATE_STORAGE_ACCOUNT`.
4. **Secretos de la app en Key Vault**, leídos con identidad administrada. Ni en
   `tfvars` ni en variables de entorno en claro.
5. **Módulos con versión fija** (`?ref=vX.Y.Z`). Actualizar es un PR.
6. **Etiquetas con `naming`**: no se escriben a mano.
7. **Contrato de despliegue**: Terraform crea y configura la infraestructura; el
   pipeline de la app publica la imagen (GHCR) y la despliega
   (`az containerapp update --image`). Por eso los módulos de Container Apps
   ignoran cambios de imagen.
8. **Imágenes en GHCR** (gratis para repos públicos) en lugar de ACR (~USD 5/mes).
9. **Presupuesto por suscripción** con alerta pronosticada, gestionado por la plataforma.
10. **Plan en PR, apply en `main`** con el environment de GitHub protegido por aprobación.

## Plantilla de `versions.tf`

```hcl
terraform {
  required_version = ">= 1.9.0"

  backend "azurerm" {}   # lo configura el workflow con -backend-config

  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 5.9" }
    azapi   = { source = "Azure/azapi", version = "~> 2.13" }
  }
}

provider "azurerm" {
  features {}
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
}
```

## Plantilla de `.github/workflows/infra.yml`

```yaml
name: Infra
on:
  pull_request:
    paths: ["infra/**"]
  push:
    branches: [main]
    paths: ["infra/**"]

permissions:
  id-token: write
  contents: read
  pull-requests: write

jobs:
  prod:
    uses: miguelortiz13/terraform-modules-iac/.github/workflows/terraform-azure.yml@v0.1.0
    with:
      environment: prod
      state-container: <proyecto>
```
