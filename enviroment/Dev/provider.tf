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

  tenant_id = "7bac5815-9677-4588-9bf7-8048ea558687"
  subscription_id = "cfc3c167-bab0-41a5-8326-750581db5b43"
}