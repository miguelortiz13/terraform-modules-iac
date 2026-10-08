# Línea base de Azure Policy para gobernanza y control de costos.
#
# Solo usa definiciones integradas. En modo `audit` las políticas con
# parámetro `effect` reportan sin bloquear y las demás se asignan con
# enforcement `DoNotEnforce` (se evalúan, pero no deniegan). Así se puede ver
# el cumplimiento de los proyectos existentes antes de pasar a `enforce`.

locals {
  enforce          = var.mode == "enforce"
  effect           = local.enforce ? "Deny" : "Audit"
  enforcement_mode = local.enforce

  builtin = {
    allowed_locations       = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    allowed_locations_rg    = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
    require_tag_rg          = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
    inherit_tag_from_rg     = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
    allowed_vm_skus         = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
    storage_no_public_blobs = "/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751"
    storage_https_only      = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
    denied_resource_types   = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  }

  locations = distinct(concat(var.allowed_locations, ["global"]))

  # Asignaciones con parámetro `effect`.
  effect_assignments = {
    locations = {
      definition = local.builtin.allowed_locations
      display    = "Regiones permitidas"
      parameters = { listOfAllowedLocations = { value = local.locations }, effect = { value = local.effect } }
    }
    rg-locations = {
      definition = local.builtin.allowed_locations_rg
      display    = "Regiones permitidas para grupos de recursos"
      parameters = { listOfAllowedLocations = { value = local.locations }, effect = { value = local.effect } }
    }
    st-public = {
      definition = local.builtin.storage_no_public_blobs
      display    = "Storage sin acceso público anónimo"
      parameters = { effect = { value = local.effect } }
    }
    st-https = {
      definition = local.builtin.storage_https_only
      display    = "Storage solo con HTTPS"
      parameters = { effect = { value = local.effect } }
    }
    deny-types = {
      definition = local.builtin.denied_resource_types
      display    = "Tipos de recurso caros no permitidos"
      parameters = { listOfResourceTypesNotAllowed = { value = var.denied_resource_types }, effect = { value = local.effect } }
    }
  }
}

resource "azurerm_management_group_policy_assignment" "effect" {
  for_each = local.effect_assignments

  name                 = "${var.name_prefix}-${each.key}"
  display_name         = each.value.display
  management_group_id  = var.management_group_id
  policy_definition_id = each.value.definition
  parameters           = jsonencode(each.value.parameters)
}

# Sin parámetro `effect`: siempre deniegan, así que en modo audit se asignan
# sin aplicar (DoNotEnforce).
resource "azurerm_management_group_policy_assignment" "require_tag" {
  for_each = toset(var.required_tags)

  name                 = substr("${var.name_prefix}-tag-${lower(each.value)}", 0, 24)
  display_name         = "Etiqueta obligatoria en grupos de recursos: ${each.value}"
  management_group_id  = var.management_group_id
  policy_definition_id = local.builtin.require_tag_rg
  enforce              = local.enforcement_mode
  parameters           = jsonencode({ tagName = { value = each.value } })
}

resource "azurerm_management_group_policy_assignment" "vm_skus" {
  count = length(var.allowed_vm_skus) > 0 ? 1 : 0

  name                 = "${var.name_prefix}-vm-skus"
  display_name         = "Tamaños de VM permitidos"
  management_group_id  = var.management_group_id
  policy_definition_id = local.builtin.allowed_vm_skus
  enforce              = local.enforcement_mode
  parameters           = jsonencode({ listOfAllowedSKUs = { value = var.allowed_vm_skus } })
}

# Herencia de etiquetas (efecto Modify): siempre activa, porque no bloquea
# nada y corrige recursos creados sin etiquetas. Necesita una identidad con
# permiso de escritura sobre el ámbito.
resource "azurerm_management_group_policy_assignment" "inherit_tag" {
  for_each = toset(var.required_tags)

  name                 = substr("${var.name_prefix}-inh-${lower(each.value)}", 0, 24)
  display_name         = "Heredar etiqueta del grupo de recursos: ${each.value}"
  management_group_id  = var.management_group_id
  policy_definition_id = local.builtin.inherit_tag_from_rg
  location             = var.identity_location
  parameters           = jsonencode({ tagName = { value = each.value } })

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "inherit_tag" {
  for_each = azurerm_management_group_policy_assignment.inherit_tag

  scope                = var.management_group_id
  role_definition_name = "Tag Contributor"
  principal_id         = each.value.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}
