# Suscripción gestionada como código (alias ARM).
#
# CUIDADO: destruir el alias de una suscripción la CANCELA. Por eso el recurso
# tiene `prevent_destroy`; para darla de baja hay que quitar este bloque a
# propósito, en un cambio revisado.

resource "azurerm_subscription" "this" {
  alias             = var.alias
  subscription_name = var.display_name
  billing_scope_id  = var.billing_scope_id
  subscription_id   = var.subscription_id
  workload          = var.subscription_id == null ? var.workload : null
  tags              = var.tags

  lifecycle {
    prevent_destroy = true

    precondition {
      condition     = (var.billing_scope_id == null) != (var.subscription_id == null)
      error_message = "Indica billing_scope_id (crear) o subscription_id (adoptar), no ambos ni ninguno."
    }
  }
}

resource "azurerm_management_group_subscription_association" "this" {
  count = var.management_group_id == null ? 0 : 1

  management_group_id = var.management_group_id
  subscription_id     = "/subscriptions/${azurerm_subscription.this.subscription_id}"
}
