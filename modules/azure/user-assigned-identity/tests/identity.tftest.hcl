mock_provider "azurerm" {
  mock_resource "azurerm_user_assigned_identity" {
    defaults = {
      id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-demo"
      principal_id = "11111111-1111-1111-1111-111111111111"
    }
  }
}

variables {
  name                = "id-demo-dev-eus2"
  resource_group_name = "rg-demo-dev-eus2"
  location            = "eastus2"
  tags                = {}
}

run "oidc_github_y_roles" {
  command = apply

  variables {
    role_assignments = {
      contributor = { scope = "/subscriptions/00000000-0000-0000-0000-000000000000", role_definition_name = "Contributor" }
    }
    federated_credentials = {
      github-prod = { subject = "repo:example/app:environment:prod" }
    }
  }

  assert {
    condition     = azurerm_federated_identity_credential.this["github-prod"].issuer == "https://token.actions.githubusercontent.com"
    error_message = "El emisor por defecto debe ser GitHub Actions."
  }

  assert {
    condition     = azurerm_role_assignment.this["contributor"].principal_type == "ServicePrincipal"
    error_message = "principal_type debe fijarse para evitar errores de replicación de Entra ID."
  }
}
