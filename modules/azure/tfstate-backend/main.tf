# Backend centralizado de estados de Terraform.
#
# Una cuenta con un contenedor por proyecto. Cada pipeline solo puede escribir
# en su contenedor (RBAC a nivel de contenedor) y se autentica con Entra ID
# (`use_azuread_auth = true`): las claves de cuenta quedan desactivadas.
# El versionado y el borrado suave permiten recuperar un estado dañado.

module "storage" {
  source = "../storage-account"

  name                      = var.storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  tags                      = var.tags
  replication_type          = "LRS"
  shared_access_key_enabled = false
  versioning_enabled        = true
  blob_soft_delete_days     = 30
  containers                = toset(keys(var.projects))
}

locals {
  writer_assignments = merge([
    for project, cfg in var.projects : {
      for i, principal in cfg.writers : "${project}-w${i}" => { project = project, principal = principal }
    }
  ]...)

  reader_assignments = merge([
    for project, cfg in var.projects : {
      for i, principal in cfg.readers : "${project}-r${i}" => { project = project, principal = principal }
    }
  ]...)
}

resource "azurerm_role_assignment" "writer" {
  for_each = local.writer_assignments

  scope                = module.storage.container_ids[each.value.project]
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value.principal
}

resource "azurerm_role_assignment" "reader" {
  for_each = local.reader_assignments

  scope                = module.storage.container_ids[each.value.project]
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = each.value.principal
}

resource "azurerm_role_assignment" "account_reader" {
  for_each = toset(var.account_readers)

  scope                = module.storage.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = each.value
}

resource "azurerm_management_lock" "this" {
  count = var.lock_enabled ? 1 : 0

  name       = "lock-${var.storage_account_name}"
  scope      = module.storage.id
  lock_level = "CanNotDelete"
  notes      = "Estados de Terraform: no borrar."
}
