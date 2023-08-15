terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.69.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "=1.2.25"
    }
  }

  required_version = "=1.5.2"
}

provider "azurerm" {
  features {}
}
