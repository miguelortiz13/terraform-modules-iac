# Changelog

## [0.2.0](https://github.com/miguelortiz13/terraform-modules-iac/compare/v0.1.0...v0.2.0) (2026-10-08)


### ⚠ BREAKING CHANGES

* **subscription,budget:** subscription.management_group_id pasa a management_group_name; budget necesita scope_type = "resource_group" para presupuestos de grupo.

### Features

* **workflow:** plan sin aprobación y apply con environment protegido ([#8](https://github.com/miguelortiz13/terraform-modules-iac/issues/8)) ([8da1504](https://github.com/miguelortiz13/terraform-modules-iac/commit/8da1504e27fee26ddfbe1664265af963b86b3dfd))


### Bug Fixes

* **ci:** fija terraform-docs v0.24.0 en la verificación de README ([#6](https://github.com/miguelortiz13/terraform-modules-iac/issues/6)) ([49c843f](https://github.com/miguelortiz13/terraform-modules-iac/commit/49c843fdc7688fb2958f684bc25e37795f407134))
* **subscription,budget:** valores conocidos en el plan ([#7](https://github.com/miguelortiz13/terraform-modules-iac/issues/7)) ([9473541](https://github.com/miguelortiz13/terraform-modules-iac/commit/9473541d995021b39f35fd5aa97e6c9aedaf5010))

## 0.1.0 (2026-10-08)

### Features

* Módulos de Azure: `naming`, `resource-group`, `budget`, `log-analytics`, `user-assigned-identity`, `storage-account`, `key-vault`, `static-web-app`, `container-app-environment`, `container-app`, `container-app-job`, `mssql-serverless-free`, `function-app-flex`, `tfstate-backend`, `subscription` y `policy-baseline`.
* Workflow reutilizable `terraform-azure.yml` para los proyectos (plan en PR, apply en `main`, OIDC).
* Estándares de nombres, etiquetas, proyectos, módulos, versionado y costos.
* Ejemplo `examples/azure/app-capa-gratuita`.
