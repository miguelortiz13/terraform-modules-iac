resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
  tags     = var.tags
}

# Evita borrados accidentales (también desde Terraform: hay que quitar el
# bloqueo en un apply previo antes de destruir el grupo).
resource "azurerm_management_lock" "this" {
  count = var.lock_level == null ? 0 : 1

  name       = "lock-${var.name}"
  scope      = azurerm_resource_group.this.id
  lock_level = var.lock_level
  notes      = "Gestionado por Terraform. Retirar el bloqueo en un apply antes de destruir."
}
