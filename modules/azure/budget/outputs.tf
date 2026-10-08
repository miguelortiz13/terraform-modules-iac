output "id" {
  description = "ID del presupuesto."
  value       = one(concat(azurerm_consumption_budget_subscription.this[*].id, azurerm_consumption_budget_resource_group.this[*].id))
}
