config {
  format           = "compact"
  call_module_type = "local"
}

plugin "terraform" {
  enabled = true
  preset  = "all"
}

plugin "azurerm" {
  enabled = true
  version = "0.32.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# Los módulos fijan rangos de versión (>= x, < y), no versiones exactas: el
# lock file lo gestiona el proyecto que los consume.
rule "terraform_unused_required_providers" {
  enabled = true
}

# prevent_destroy no admite variables: fijarlo en un módulo impediría
# destruir entornos dev/lab. La protección en prod se da con el bloqueo
# CanNotDelete del módulo resource-group (`lock_level`).
rule "azurerm_resources_missing_prevent_destroy" {
  enabled = false
}
