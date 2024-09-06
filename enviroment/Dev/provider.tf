terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  features {}

  tenant_id = "7d9bc26e-3c00-4399-b6ac-95449811961e"
  subscription_id = "b2e85258-1f87-4c3f-8af8-8b14278b76ab"
}