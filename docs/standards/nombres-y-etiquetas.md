# Nombres y etiquetas

Todos los proyectos generan nombres y etiquetas con el módulo
[`naming`](../../modules/azure/naming). No escribas nombres a mano.

## Nombres

Patrón (Cloud Adoption Framework):

```
<abreviatura>-<proyecto>-<entorno>-<región>[-<instancia>]
```

| Recurso | Ejemplo |
|---|---|
| Grupo de recursos | `rg-nexpos-prod-eus2` |
| Container App | `ca-nexpos-prod-eus2-api` |
| Entorno de Container Apps | `cae-nexpos-prod-eus2` |
| Static Web App | `stapp-nexpos-prod-eus2` |
| Identidad | `id-nexpos-prod-eus2-deploy` |
| Key Vault (global) | `kv-nexpos-prod-eus2-1a2b` |
| Storage (global, sin guiones) | `stnexposprodeus21a2b3c` |
| SQL Server (global) | `sql-nexpos-prod-eus2-1a2b3c` |

Los recursos con nombre global llevan un sufijo determinista calculado a
partir del ID de la suscripción (`unique_seed`): es estable entre applies y
no choca entre proyectos.

### Valores permitidos

- **proyecto**: 2-15 caracteres, minúsculas y dígitos, sin guiones (`nexpos`, `cloudops`, `sspm`, `secopshub`).
- **entorno**: `dev`, `qa`, `prod`, `lab`.
- **región**: código corto (`eastus2` → `eus2`, `southcentralus` → `scus`).

### Suscripciones

Una suscripción por proyecto: `sub-<proyecto>` (p. ej. `sub-nexpos`). Cada
suscripción recibe sus propios cupos gratis (Container Apps, Azure SQL).

## Etiquetas obligatorias

| Etiqueta | Ejemplo | Para qué |
|---|---|---|
| `Project` | `nexpos` | Showback de costos y filtros |
| `Environment` | `prod` | Separar costos y políticas por entorno |
| `Owner` | `owner@example.com` | A quién avisar |
| `Repository` | `miguelortiz13/nexpos-backend` | Dónde está el código que lo gestiona |
| `CostCenter` | `nexpos` | Agrupar costos de varios proyectos |
| `ManagedBy` | `Terraform` | Detectar recursos creados a mano |

La línea base de Azure Policy exige `Project`, `Environment`, `Owner` y
`ManagedBy` en los grupos de recursos, y los recursos las heredan del grupo
si les faltan.
