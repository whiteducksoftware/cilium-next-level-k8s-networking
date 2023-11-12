terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.79.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "=1.2.26"
    }
  }

  required_version = "=1.6.3"
}

provider "azurerm" {
  features {}
}
