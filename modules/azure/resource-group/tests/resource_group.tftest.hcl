mock_provider "azurerm" {}

variables {
  name     = "rg-demo-dev-eus2"
  location = "eastus2"
  tags     = { Project = "demo" }
}

run "sin_bloqueo_por_defecto" {
  command = plan

  assert {
    condition     = length(azurerm_management_lock.this) == 0
    error_message = "No debe crear bloqueo si lock_level es null."
  }
}

run "con_bloqueo" {
  command = plan

  variables {
    lock_level = "CanNotDelete"
  }

  assert {
    condition     = azurerm_management_lock.this[0].lock_level == "CanNotDelete"
    error_message = "Debe crear el bloqueo solicitado."
  }
}

run "bloqueo_invalido" {
  command = plan

  variables {
    lock_level = "Delete"
  }

  expect_failures = [var.lock_level]
}
