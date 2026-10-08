variables {
  project     = "nexpos"
  environment = "prod"
  location    = "eastus2"
  unique_seed = "00000000-0000-0000-0000-000000000000"
  owner       = "owner@example.com"
  repository  = "example/nexpos-backend"
}

run "nombres_estandar" {
  command = plan

  assert {
    condition     = output.names.resource_group == "rg-nexpos-prod-eus2"
    error_message = "El nombre del grupo de recursos no sigue la convención."
  }

  assert {
    condition     = length(output.names.storage_account) <= 24 && can(regex("^[a-z0-9]+$", output.names.storage_account))
    error_message = "El nombre del storage account no cumple las restricciones de Azure."
  }

  assert {
    condition     = length(output.names.key_vault) <= 24
    error_message = "El nombre del key vault supera 24 caracteres."
  }
}

run "etiquetas_estandar_prevalecen" {
  command = plan

  variables {
    extra_tags = { Project = "otro", Team = "plataforma" }
  }

  assert {
    condition     = output.tags.Project == "nexpos" && output.tags.Team == "plataforma" && output.tags.ManagedBy == "Terraform"
    error_message = "Las etiquetas estándar deben prevalecer sobre extra_tags."
  }
}

run "sin_region" {
  command = plan

  variables {
    include_region = false
    instance       = "api"
  }

  assert {
    condition     = output.names.container_app == "ca-nexpos-prod-api"
    error_message = "include_region = false debe omitir el código de región."
  }
}

run "nombre_largo_respeta_limites" {
  command = plan

  variables {
    project  = "cloudopscopilot"
    instance = "collector"
  }

  assert {
    condition     = length(output.names.key_vault) <= 24 && length(output.names.storage_account) <= 24
    error_message = "Los nombres globales deben respetar 24 caracteres aun con proyectos largos."
  }
}

run "entorno_invalido" {
  command = plan

  variables {
    environment = "staging"
  }

  expect_failures = [var.environment]
}
