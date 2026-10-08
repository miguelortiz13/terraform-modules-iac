output "base" {
  description = "Segmento común de los nombres (`<proyecto>-<entorno>[-<región>][-<instancia>]`)."
  value       = local.base
}

output "region_code" {
  description = "Código corto de la región."
  value       = local.region_code
}

output "names" {
  description = "Nombres por tipo de recurso, siguiendo las abreviaturas de Cloud Adoption Framework."
  value = {
    resource_group            = "rg-${local.base}"
    log_analytics_workspace   = "log-${local.base}"
    application_insights      = "appi-${local.base}"
    container_app_environment = "cae-${local.base}"
    container_app             = "ca-${local.base}"
    container_app_job         = "caj-${local.base}"
    static_web_app            = "stapp-${local.base}"
    function_app              = "func-${local.base}-${local.suffix4}"
    service_plan              = "asp-${local.base}"
    user_assigned_identity    = "id-${local.base}"
    mssql_server              = "sql-${local.base}-${local.suffix6}"
    mssql_database            = "sqldb-${local.base}"
    postgresql_server         = "psql-${local.base}-${local.suffix6}"
    mysql_server              = "mysql-${local.base}-${local.suffix6}"
    virtual_network           = "vnet-${local.base}"
    subnet                    = "snet-${local.base}"
    network_security_group    = "nsg-${local.base}"
    budget                    = "budget-${local.base}"
    # 3-24 caracteres, letras, dígitos y guiones no consecutivos.
    key_vault = "kv-${trimsuffix(substr(local.base, 0, 15), "-")}-${local.suffix4}"
    # Máximo 24 caracteres, solo minúsculas y dígitos.
    storage_account = "st${substr(local.compact_base, 0, 16)}${local.suffix6}"
  }
}

output "tags" {
  description = "Etiquetas estándar más las adicionales. Las estándar tienen prioridad."
  value       = merge(var.extra_tags, local.standard_tags)
}

output "standard_tag_keys" {
  description = "Claves de etiqueta obligatorias en todos los proyectos (las audita la política de gobierno)."
  value       = keys(local.standard_tags)
}
