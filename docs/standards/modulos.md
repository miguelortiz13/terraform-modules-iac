# Diseño de módulos

## Estructura obligatoria

```
modules/<proveedor>/<módulo>/
├── README.md        # descripción + ejemplo + tabla generada por terraform-docs
├── versions.tf      # required_version y required_providers con rango (>= x, < y)
├── variables.tf     # todas con description y type; validation cuando aplique
├── main.tf
├── outputs.tf       # todas con description; sensitive cuando aplique
└── tests/*.tftest.hcl
```

## Reglas

- **Un propósito por módulo.** Si un módulo necesita otro del repo, lo llama
  con ruta relativa (`../storage-account`).
- **Sin bloques `provider`** dentro del módulo: los configura el proyecto.
- **Versiones de proveedor por rango** (`>= 5.0, < 6.0`). El lock file lo fija el proyecto.
- **Seguro y barato por defecto**: TLS 1.2, sin acceso anónimo, Entra ID en lugar
  de claves, SKU gratuito o el más barato, escala a cero. Lo caro se activa
  explícitamente con una variable.
- **Sin `prevent_destroy`** en módulos (no admite variables). La protección de
  prod se hace con `lock_level` del grupo de recursos.
- **`for_each` con claves estables** (mapas), nunca `count` sobre listas que pueden reordenarse.
- **Nombres y etiquetas desde fuera**: el módulo recibe `name` y `tags`, no los inventa.
- **Validaciones** en las variables con errores claros en español.
- **Tests** con `mock_provider`: corren sin credenciales ni costo en el CI.
- **Excepciones de seguridad** (checkov) justificadas en `.checkov.yaml` o en
  línea con `#checkov:skip=<id>:<motivo>`.

## Agregar un proveedor nuevo

1. Crea `modules/<proveedor>/` (p. ej. `modules/aws/`, `modules/github/`).
2. Si el proveedor necesita convención propia, crea `modules/<proveedor>/naming`
   con la misma interfaz (`project`, `environment`, `owner`, `repository` →
   `names`, `tags`).
3. Agrega el ruleset de tflint del proveedor en `.tflint.hcl`.
4. El CI descubre los módulos solo (`modules/*/*/versions.tf`).
