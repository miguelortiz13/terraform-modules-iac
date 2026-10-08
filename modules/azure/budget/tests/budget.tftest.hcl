mock_provider "azurerm" {}

variables {
  name           = "budget-demo"
  amount         = 10
  contact_emails = ["owner@example.com"]
}

run "presupuesto_de_suscripcion" {
  command = plan

  variables {
    scope_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = length(azurerm_consumption_budget_subscription.this) == 1 && length(azurerm_consumption_budget_resource_group.this) == 0
    error_message = "Un scope de suscripción debe crear un presupuesto de suscripción."
  }

  assert {
    condition     = length(azurerm_consumption_budget_subscription.this[0].notification) == 3
    error_message = "Por defecto debe haber 2 alertas reales y 1 pronosticada."
  }
}

run "presupuesto_de_grupo" {
  command = plan

  variables {
    scope_type = "resource_group"
    scope_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-demo"
  }

  assert {
    condition     = length(azurerm_consumption_budget_resource_group.this) == 1
    error_message = "Un scope de grupo de recursos debe crear un presupuesto de grupo."
  }
}

run "scope_invalido" {
  command = plan

  variables {
    scope_id = "rg-demo"
  }

  expect_failures = [var.scope_id]
}

run "tipo_y_scope_inconsistentes" {
  command = plan

  variables {
    scope_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-demo"
  }

  expect_failures = [azurerm_consumption_budget_subscription.this]
}
