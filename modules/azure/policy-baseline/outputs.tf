output "assignment_ids" {
  description = "IDs de todas las asignaciones de política."
  value = concat(
    [for a in azurerm_management_group_policy_assignment.effect : a.id],
    [for a in azurerm_management_group_policy_assignment.require_tag : a.id],
    [for a in azurerm_management_group_policy_assignment.vm_skus : a.id],
    [for a in azurerm_management_group_policy_assignment.inherit_tag : a.id],
  )
}

output "mode" {
  description = "Modo aplicado (audit o enforce)."
  value       = var.mode
}
