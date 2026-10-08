output "subscription_id" {
  description = "GUID de la suscripción."
  value       = azurerm_subscription.this.subscription_id
}

output "id" {
  description = "ID de recurso de la suscripción (`/subscriptions/<guid>`)."
  value       = "/subscriptions/${azurerm_subscription.this.subscription_id}"
}
