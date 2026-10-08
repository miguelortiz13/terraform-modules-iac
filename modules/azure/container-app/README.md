# azure/container-app

Container App de consumo que escala a cero por defecto, con secretos de Key Vault, identidad administrada, Azure Files y sondas de salud. La imagen la despliega el pipeline de la app.

## Uso

```hcl
module "api" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/container-app?ref=v0.2.0"

  name                         = "${module.naming.names.container_app}-api"
  resource_group_name          = module.rg.name
  container_app_environment_id = module.cae.id
  tags                         = module.naming.tags

  image             = "ghcr.io/miguelortiz13/nexpos-backend:latest"
  cpu               = 0.5
  memory            = "1Gi"
  min_replicas      = 0
  ingress           = { target_port = 8088 }
  health_probe_path = "/actuator/health"

  identity_ids      = [module.api_identity.id]
  key_vault_secrets = { "jwt-secret" = "${module.kv.vault_uri}secrets/jwt-secret" }
  secret_env        = { JWT_SECRET = "jwt-secret" }
  env               = { SPRING_PROFILES_ACTIVE = "prod" }
}
```

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.9.0 |
| azurerm | >= 5.0, < 6.0 |

### Providers

| Name | Version |
| ---- | ------- |
| azurerm | >= 5.0, < 6.0 |

### Resources

| Name | Type |
| ---- | ---- |
| [azurerm_container_app.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| container\_app\_environment\_id | ID del entorno de Container Apps. | `string` | n/a | yes |
| name | Nombre (usa `module.naming.names.container_app`; máximo 32 caracteres). | `string` | n/a | yes |
| resource\_group\_name | Grupo de recursos. | `string` | n/a | yes |
| tags | Etiquetas. | `map(string)` | n/a | yes |
| args | Argumentos del contenedor. | `list(string)` | `null` | no |
| command | Comando del contenedor (reemplaza el ENTRYPOINT). | `list(string)` | `null` | no |
| concurrent\_requests | Solicitudes concurrentes por réplica antes de escalar. | `number` | `10` | no |
| cpu | vCPU por réplica (0.25 a 4, en pasos de 0.25). | `number` | `0.5` | no |
| env | Variables de entorno en claro. | `map(string)` | `{}` | no |
| health\_probe\_path | Ruta HTTP para las sondas de arranque, disponibilidad y vida. `null` = sin sondas. | `string` | `null` | no |
| identity\_ids | Identidades administradas asignadas por el usuario. La primera se usa para leer Key Vault y el registro. | `list(string)` | `[]` | no |
| image | Imagen inicial. Después de crear la app, el pipeline de la aplicación despliega las versiones nuevas (`az containerapp update --image`) y Terraform ignora este valor. | `string` | `"mcr.microsoft.com/k8se/quickstart:latest"` | no |
| ingress | Exposición HTTP. `null` = sin ingress (app interna sin endpoint). | ```object({ external = optional(bool, true) target_port = number transport = optional(string, "auto") allow_insecure = optional(bool, false) })``` | `null` | no |
| key\_vault\_secrets | Secretos leídos de Key Vault con la identidad de la app: nombre => URI versionless del secreto. | `map(string)` | `{}` | no |
| max\_inactive\_revisions | Revisiones inactivas que se conservan para volver atrás. | `number` | `5` | no |
| max\_replicas | Réplicas máximas. | `number` | `1` | no |
| memory | Memoria por réplica. Debe ser el doble de la CPU (0.25 -> 0.5Gi, 0.5 -> 1Gi, 1 -> 2Gi). | `string` | `"1Gi"` | no |
| min\_replicas | Réplicas mínimas. 0 = escala a cero (USD 0 sin tráfico, con arranque en frío). 1 = siempre encendida (necesario para procesos en segundo plano). | `number` | `0` | no |
| registry | Registro privado de imágenes. `null` para imágenes públicas (p. ej. GHCR de repos públicos). Con `identity_id` se autentica sin contraseña (AcrPull). | ```object({ server = string identity_id = optional(string) username = optional(string) })``` | `null` | no |
| registry\_password | Contraseña o token del registro, solo si se usa `registry.username`. | `string` | `null` | no |
| secret\_env | Variables de entorno que leen un secreto: nombre de variable => nombre del secreto (clave de `secrets` o `key_vault_secrets`). | `map(string)` | `{}` | no |
| secrets | Secretos con valor directo: nombre (minúsculas y guiones) => valor. | `map(string)` | `{}` | no |
| volumes | Volúmenes de Azure Files: nombre del storage del entorno => ruta de montaje. | `map(string)` | `{}` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| fqdn | FQDN de la revisión activa (null sin ingress). |
| id | ID de la Container App. |
| name | Nombre de la Container App. |
| outbound\_ip\_addresses | IPs de salida (útil para reglas de firewall de bases externas). |
| url | URL HTTPS de la app (null sin ingress). |
<!-- END_TF_DOCS -->
