mock_provider "azurerm" {}

variables {
  management_group_id = "/providers/Microsoft.Management/managementGroups/mg-workloads"
  allowed_locations   = ["eastus2", "southcentralus"]
  identity_location   = "eastus2"
}

run "audit_no_bloquea" {
  command = plan

  assert {
    condition     = jsondecode(azurerm_management_group_policy_assignment.effect["locations"].parameters).effect.value == "Audit"
    error_message = "En modo audit las políticas con effect deben auditar."
  }

  assert {
    condition     = alltrue([for a in azurerm_management_group_policy_assignment.require_tag : a.enforce == false])
    error_message = "En modo audit las políticas sin effect deben asignarse sin aplicar."
  }

  assert {
    condition     = contains(jsondecode(azurerm_management_group_policy_assignment.effect["locations"].parameters).listOfAllowedLocations.value, "global")
    error_message = "global debe estar siempre permitido (recursos como budgets y DNS)."
  }
}

run "enforce_deniega" {
  command = plan

  variables {
    mode = "enforce"
  }

  assert {
    condition     = jsondecode(azurerm_management_group_policy_assignment.effect["deny-types"].parameters).effect.value == "Deny"
    error_message = "En modo enforce las políticas deben denegar."
  }
}

run "nombres_validos" {
  command = plan

  variables {
    required_tags = ["Environment", "CostCenter"]
  }

  assert {
    condition     = alltrue([for a in azurerm_management_group_policy_assignment.inherit_tag : length(a.name) <= 24])
    error_message = "Los nombres de asignación en management groups no pueden superar 24 caracteres."
  }
}
