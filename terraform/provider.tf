terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "891d8502-d3bc-4fa1-8186-9e3649f93897"
  tenant_id       = "7147b932-52e5-40de-92fd-8dd9c3e95a88"
}

provider "azuread" {}