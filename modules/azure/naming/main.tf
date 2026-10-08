# Convención de nombres y etiquetas compartida por todos los proyectos.
#
# No crea recursos: solo calcula valores. Patrón general (CAF):
#   <abreviatura>-<proyecto>-<entorno>[-<región>][-<instancia>]
# Los recursos con nombre global y restricciones de caracteres (storage,
# key vault, sql) llevan un sufijo determinista derivado de `unique_seed`,
# así el nombre es estable entre applies y no choca entre suscripciones.

locals {
  region_codes = {
    eastus         = "eus"
    eastus2        = "eus2"
    centralus      = "cus"
    southcentralus = "scus"
    northcentralus = "ncus"
    westus         = "wus"
    westus2        = "wus2"
    westus3        = "wus3"
    canadacentral  = "cac"
    brazilsouth    = "brs"
    mexicocentral  = "mxc"
    westeurope     = "weu"
    northeurope    = "neu"
  }

  region_code = lookup(local.region_codes, var.location, var.location)
  suffix4     = substr(sha1(var.unique_seed), 0, 4)
  suffix6     = substr(sha1(var.unique_seed), 0, 6)

  parts = compact([
    var.project,
    var.environment,
    var.include_region ? local.region_code : "",
    var.instance,
  ])
  base = join("-", local.parts)

  # Sin guiones, para los recursos que solo aceptan alfanuméricos.
  compact_base = join("", local.parts)

  standard_tags = {
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
    Repository  = var.repository
    CostCenter  = coalesce(var.cost_center, var.project)
    ManagedBy   = "Terraform"
  }
}
