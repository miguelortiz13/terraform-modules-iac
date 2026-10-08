## Qué cambia

<!-- Módulo(s) afectado(s) y motivo. -->

## Tipo de cambio (Conventional Commits)

- [ ] `feat:` módulo o variable nueva (versión menor)
- [ ] `fix:` corrección sin cambiar la interfaz (parche)
- [ ] `feat!:` / `BREAKING CHANGE:` cambia la interfaz o recrea recursos (versión mayor)

## Checklist

- [ ] `terraform fmt`, `validate` y `terraform test` pasan.
- [ ] Tests nuevos o actualizados en `tests/`.
- [ ] README regenerado con `terraform-docs`.
- [ ] Si recrea recursos, el PR lo indica y hay `moved {}` cuando aplica.
- [ ] Impacto de costo revisado (¿sigue dentro de la capa gratuita?).
