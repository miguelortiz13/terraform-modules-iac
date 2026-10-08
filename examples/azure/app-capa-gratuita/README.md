# Ejemplo: app en la capa gratuita de Azure

API en Container Apps que escala a cero, SPA en Static Web Apps Free, Azure SQL
con la oferta gratuita, Key Vault con RBAC, identidad OIDC para el despliegue
continuo y presupuesto con alertas. Es la base de referencia para los proyectos.

| Recurso | Costo esperado |
|---|---|
| Container App (0.5 vCPU / 1 GiB, escala a 0) | USD 0 hasta ~100 h activas/mes por suscripción |
| Static Web App Free | USD 0 |
| Azure SQL free | USD 0 (se pausa al agotar el cupo) |
| Key Vault | centavos (por operación) |
| Budget, identidades | USD 0 |

```bash
terraform init
terraform plan -var subscription_id=... -var owner=... -var repository=owner/repo \
  -var 'sql_admin={login_username="...",object_id="..."}'
```
