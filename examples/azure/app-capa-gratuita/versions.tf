terraform {
  required_version = ">= 1.9.0"

  # En un proyecto real: backend "azurerm" {} con la configuración que
  # entrega el repo de plataforma (ver docs/standards/proyectos.md).

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.9"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.13"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
}

provider "azapi" {
  subscription_id = var.subscription_id
}
