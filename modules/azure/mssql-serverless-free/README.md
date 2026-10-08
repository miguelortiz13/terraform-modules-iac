# azure/mssql-serverless-free

Azure SQL Database serverless con la oferta gratuita (100.000 vCore-s y 32 GB al mes) y autenticación solo con Entra ID.

## Uso

```hcl
module "sql" {
  source = "git::https://github.com/miguelortiz13/terraform-modules-iac.git//modules/azure/mssql-serverless-free?ref=v0.2.0"

  server_name         = module.naming.names.mssql_server
  database_name       = module.naming.names.mssql_database
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = module.naming.tags

  entra_admin = {
    login_username = "owner@example.com"
    object_id      = data.azuread_client_config.current.object_id
  }
}
```

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.9.0 |
| azapi | >= 2.0, < 3.0 |
| azurerm | >= 5.0, < 6.0 |

### Providers

| Name | Version |
| ---- | ------- |
| azapi | >= 2.0, < 3.0 |
| azurerm | >= 5.0, < 6.0 |

### Resources

| Name | Type |
| ---- | ---- |
| [azapi_resource.database](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_mssql_firewall_rule.azure_services](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_firewall_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| database\_name | Nombre de la base (usa `module.naming.names.mssql_database`). | `string` | n/a | yes |
| entra\_admin | Administrador de Entra ID del servidor (usuario o grupo). La autenticación SQL con contraseña queda desactivada. | ```object({ login_username = string object_id = string })``` | n/a | yes |
| location | Región. La oferta gratuita no está en todas las regiones: si `eastus2` no tiene capacidad, prueba `centralus` o `westus2`. | `string` | n/a | yes |
| resource\_group\_name | Grupo de recursos. | `string` | n/a | yes |
| server\_name | Nombre del servidor lógico (global; usa `module.naming.names.mssql_server`). | `string` | n/a | yes |
| tags | Etiquetas. | `map(string)` | n/a | yes |
| allow\_azure\_services | Regla 0.0.0.0: admite tráfico originado en Azure (Container Apps de consumo no tiene IP de salida fija). El acceso sigue exigiendo un token de Entra ID. | `bool` | `true` | no |
| firewall\_rules | Reglas adicionales: nombre => { start\_ip, end\_ip }. | ```map(object({ start_ip = string end_ip = string }))``` | `{}` | no |
| free\_limit\_exhaustion\_behavior | Qué hacer al agotar el cupo gratis del mes: `AutoPause` (USD 0, la base se pausa hasta el mes siguiente) o `BillOverUsage` (sigue y factura el excedente). | `string` | `"AutoPause"` | no |
| max\_vcores | vCores máximos del serverless (1-4 dentro de la oferta gratuita). | `number` | `1` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| connection\_hint | Cadena de conexión de referencia con autenticación de identidad administrada (sin contraseña). |
| database\_id | ID de la base. |
| database\_name | Nombre de la base. |
| server\_fqdn | FQDN del servidor. |
| server\_id | ID del servidor. |
<!-- END_TF_DOCS -->
