mock_provider "azurerm" {
  mock_resource "azurerm_subscription" {
    defaults = {
      subscription_id = "00000000-0000-0000-0000-000000000000"
    }
  }
}

variables {
  alias        = "sub-demo"
  display_name = "sub-demo"
}

run "crear_nueva" {
  command = plan

  variables {
    billing_scope_id = "/providers/Microsoft.Billing/billingAccounts/x/billingProfiles/y/invoiceSections/z"
  }

  assert {
    condition     = azurerm_subscription.this.workload == "Production"
    error_message = "Una suscripción nueva debe declarar el tipo de carga."
  }
}

run "adoptar_existente" {
  command = plan

  variables {
    subscription_id     = "00000000-0000-0000-0000-000000000000"
    management_group_id = "/providers/Microsoft.Management/managementGroups/mg-workloads"
  }

  assert {
    condition     = length(azurerm_management_group_subscription_association.this) == 1
    error_message = "Debe asociar la suscripción al management group."
  }
}

run "ni_crear_ni_adoptar" {
  command = plan

  expect_failures = [azurerm_subscription.this]
}
