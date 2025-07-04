terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }


    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  features {}

  tenant_id       = "7602ad0d-b3e4-4824-a88d-a49042a4adc4"
  subscription_id = "3a734e32-021d-4243-89ff-c3495e6aa4da"
}
