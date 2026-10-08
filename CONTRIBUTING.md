# Contribuir

1. Crea una rama desde `main` (`feat/<módulo>-<cambio>`).
2. Instala los hooks: `pre-commit install`.
3. Sigue [el diseño de módulos](docs/standards/modulos.md).
4. Corre en la carpeta del módulo:
   ```bash
   terraform init -backend=false
   terraform validate
   terraform test
   tflint --config="$(git rev-parse --show-toplevel)/.tflint.hcl"
   ```
5. Regenera el README: `terraform-docs --config .terraform-docs.yml modules/<proveedor>/<módulo>`.
6. Abre un PR con un título en [Conventional Commits](docs/standards/versionado.md).

El CI valida formato, documentación, tflint, checkov, gitleaks, los tests de
cada módulo y los ejemplos.
