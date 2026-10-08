# Versionado y releases

El repositorio se versiona como un todo con [SemVer](https://semver.org/lang/es/)
y etiquetas `vX.Y.Z`. Los proyectos referencian una etiqueta fija:

```hcl
source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/naming?ref=v0.1.0"
```

## Commits

[Conventional Commits](https://www.conventionalcommits.org/es/) con el módulo como ámbito:

| Commit | Versión |
|---|---|
| `fix(container-app): corrige la sonda de arranque` | parche |
| `feat(budget): filtro por etiquetas` | menor |
| `feat(naming)!: cambia el patrón de nombres` | mayor |

[release-please](https://github.com/googleapis/release-please) abre un PR de
release con el CHANGELOG; al fusionarlo crea la etiqueta.

## Qué es un cambio incompatible

- Renombrar o quitar variables u outputs.
- Cambiar un valor por defecto que modifica recursos existentes.
- Cualquier cambio que **recree** recursos (nombre, ubicación, SKU de base de datos...).
  Si se puede evitar con un bloque `moved {}`, inclúyelo.

Mientras la versión sea `0.x`, los cambios incompatibles suben la versión
menor (`0.1.0` → `0.2.0`).

## Actualizar un proyecto

1. Cambia `?ref=` en un PR.
2. Revisa el `terraform plan` que comenta el pipeline: no debe destruir nada inesperado.
3. Fusiona; el apply corre en `main` con aprobación.
